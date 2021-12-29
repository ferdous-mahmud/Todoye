//
//  ViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud on 11/05/2021.
//

// TODO: fix child item not deleted bug when parent item deleted
// Realm DB

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60.0
    }
    
    //MARK: - TableView datasourse methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.itmeTitle
            cell.accessoryType = item.checkStatus ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items added yet"
        }
       return cell
    }
    
    //MARK: - TableView delegate mehtod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Row checkmark selection & deselection
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.checkStatus = !item.checkStatus
                }
            }catch{
                print("Error saving check status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let text = textField.text{
                
                if text == ""{
                    // create the alert
                    let alert = UIAlertController(title: "Error!", message: "Empty item title", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let newItem = Item()
                    newItem.itmeTitle = text

                    self.saveItems(item: newItem)
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    
    // Save items data
    func saveItems(item: Item) {
        
        if let currentCategory = self.selectedCategory{
            do{
                try realm.write{
                    currentCategory.items.append(item)
                }
            }
            catch{
                print("Error saving item on Realm! \(error) ")
            }
        }
        self.tableView.reloadData()
    }
    
    // Load saved items
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    // Delete data form swipe
    override func updateModel(at indexpath: IndexPath) {
        do{
            try realm.write{
                realm.delete(itemArray![indexpath.row])
            }
        }
        catch{
            print("Error deleting category on Realm! \(error) ")
        }
    }

}


//MARK: - Search bar controller

extension TodoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text == ""{

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else{
            
            itemArray = itemArray?.filter("itmeTitle CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}
