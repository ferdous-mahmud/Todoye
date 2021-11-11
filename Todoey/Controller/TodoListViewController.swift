//
//  ViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud on 11/05/2021.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading percistance data
        loadItems()
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
        
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let text = textField.text{
                
                if text == ""{
                    let newItem = Item(context: self.context)
                    newItem.itemTitle = text
                    newItem.checkStatus = false
                    self.itemArray.append(newItem)
                }
                else{
                    let newItem = Item(context: self.context)
                    newItem.itemTitle = text
                    newItem.checkStatus = false
                    self.itemArray.append(newItem)
                }
                
                // Making user data percistance
                self.saveItems()
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
    func saveItems() {
        do{
            try context.save()
        }
        catch{
            print("Error saving context! \(error) ")
        }
        self.tableView.reloadData()
    }
    
    // Load saved items
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data form context  \(error)")
        }
    }

}

