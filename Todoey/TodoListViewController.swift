//
//  ViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud on 11/05/2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Buy eggs", "Find Arone", "Do Home Work"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaults.array(forKey: S.TODO_LIST_ARRAY) as? [String] {
            itemArray = item
        }
    }
    
    //MARK: - TableView datasourse methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel!.text = itemArray[indexPath.row]
           
       return cell
    }
    
    //MARK: - TableView delegate mehtod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let text = textField.text{
                self.itemArray.append(text)
                
                // Making user data percistance
                self.defaults.set(self.itemArray, forKey: S.TODO_LIST_ARRAY)
                
                // Reload data after item added
                self.tableView.reloadData()
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

