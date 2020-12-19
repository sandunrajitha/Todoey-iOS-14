//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray: [TodoItem] = [TodoItem("buy apple",false), TodoItem("buy milk",false), TodoItem("buy cheese",true), TodoItem("buy natto",false)]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let todos = defaults.array(forKey: "todoListArray") {
            print(todos)
        }
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel!.text = "\(itemArray[indexPath.row].title)"
        
        cell.accessoryType = itemArray[indexPath.row].isDone ?  .checkmark :  .none
      
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(itemArray)
        
    }
    
    // MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (newItemTextField) in
            newItemTextField.placeholder = "Enter new todo item"
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (alertAction) in
            
            if let newitem = alert.textFields?[0].text{
                if newitem != ""{
                    let newTodoItem = TodoItem(newitem, false)
                    self.itemArray.append(newTodoItem)
                    self.defaults.set(self.itemArray, forKey: "todoListArray")
                    self.tableView.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
