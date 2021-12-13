//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Ferdous Mahmud Akash on 11/13/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {
    
    var catagoryArray = [Catagory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading percistance data
        loadItems()
    }

    
    //MARK: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: S.CATAGORY_CELL , for: indexPath)
        
        let item = catagoryArray[indexPath.row]

        cell.textLabel!.text = item.name
        
        return cell
    }
    
    //MARK: - TableView Delegates methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: S.GOTO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catagoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data menupulation mehtods
    
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
    func loadItems(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()){
        
        do{
            catagoryArray =  try context.fetch(request)
        }
        catch{
            print("Error fetching data form context  \(error)")
        }
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
                    let newItem = Catagory(context: self.context)
                    newItem.name = text
                    self.catagoryArray.append(newItem)
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
}
