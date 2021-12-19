//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud Akash on 11/13/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading percistance data
        loadItems()
    }

    
    //MARK: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: S.CATAGORY_CELL , for: indexPath)
        
        cell.textLabel!.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
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
    
    
    
    //MARK: - Data menupulation mehtods
    
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
    
//     Load saved items
    func loadItems(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
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
