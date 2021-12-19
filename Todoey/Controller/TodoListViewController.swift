//
//  ViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud on 11/05/2021.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView datasourse methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: S.TODO_ITEM_CELL, for: indexPath)

        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.itmeTitle
            cell.accessoryType = item.checkStatus ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items added"
        }
       return cell
    }
    
    //MARK: - TableView delegate mehtod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Row checkmark selection & deselection
        itemArray![indexPath.row].checkStatus = !itemArray![indexPath.row].checkStatus
        
        //self.saveItems()
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
        itemArray = selectedCategory?.items.sorted(byKeyPath: "itmeTitle", ascending: true)
        tableView.reloadData()
    }

}


//MARK: - Search bar controller
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text == ""{
//
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//        else{
//
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            let predicate = NSPredicate(format: "itemTitle CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "itemTitle", ascending: true)]
//
//            loadItems(with: request, predicate: predicate)
//        }
//    }
//}
