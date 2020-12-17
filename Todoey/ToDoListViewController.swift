//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["buy apple", "buy milk", "buy cheese", "buy natto"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel!.text = "\(itemArray[indexPath.row])"
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
            
            cell.setSelected(false, animated: true)
        }
        
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
                    self.itemArray.append(newitem)
                    self.tableView.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
