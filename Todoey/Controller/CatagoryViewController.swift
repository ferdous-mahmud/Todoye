//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud Akash on 11/13/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CatagoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading percistance data
        loadItems()
        
        tableView.rowHeight = 70.0
    }

    //MARK: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel!.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        let color = UIColor(hexString: categoryArray?[indexPath.row].color ?? "#FFFFFF")
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        return cell
    }
    
    //MARK: - TableView Delegates methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: S.GOTO_ITEMS, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data manipulation mehtods
    
    // Save items data
    func saveItems(category: Category) {
        
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("Error saving category on Realm! \(error) ")
        }
        self.tableView.reloadData()
    }
    
    // Load saved items
    func loadItems(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // Delete data form swipe
    override func updateModel(at indexpath: IndexPath) {
        do{
            try realm.write{
                realm.delete(categoryArray![indexpath.row])
            }
        }
        catch{
            print("Error deleting category on Realm! \(error) ")
        }
    }
    
    
    
    
    //MARK: - Add new catagories
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
                    let newItem = Category()
                    newItem.name = text
                    newItem.color = UIColor.randomFlat().hexValue()
                    
                    self.saveItems(category: newItem)
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
}
