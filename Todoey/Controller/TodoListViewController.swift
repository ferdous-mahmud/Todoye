//
//  ViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud on 11/05/2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // Path where percistance data are saved
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.itemTitle = "Save The World"
        newItem.checkStatus = true
        
        let newItem2 = Item()
        newItem2.itemTitle = "Save The World"
        newItem2.checkStatus = false
        
        itemArray.append(newItem)
        itemArray.append(newItem2)
        itemArray.append(newItem)
        itemArray.append(newItem)
        itemArray.append(newItem2)
        
//        if let item = defaults.array(forKey: S.TODO_LIST_ARRAY) as? [Item] {
//            itemArray = item
//        }
    }
    
    //MARK: - TableView datasourse methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel!.text = item.itemTitle
        
        cell.accessoryType = item.checkStatus ? .checkmark : .none
        
       return cell
    }
    
    //MARK: - TableView delegate mehtod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Row checkmark selection & deselection
        itemArray[indexPath.row].checkStatus = !itemArray[indexPath.row].checkStatus
        
        // Reload tableView when selecting & deselceting row
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
                    let newItem = Item()
                    newItem.itemTitle = text
                    self.itemArray.append(newItem)
                }
                else{
                    let newItem = Item()
                    newItem.itemTitle = text
                    self.itemArray.append(newItem)
                }
                
                // Making user data percistance
                let encoder = PropertyListEncoder()
                
                do{
                    let data = try encoder.encode(self.itemArray)
                    try data.write(to: self.dataFilePath!)
                }
                catch{
                    print("Error encoding item array \(error) ")
                }
                
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

