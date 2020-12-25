//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
        tableView.reloadData()
        print(itemArray)
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel!.text = "\(itemArray[indexPath.row].title ?? "")"
        
        cell.accessoryType = itemArray[indexPath.row].isDone ?  .checkmark :  .none
      
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
//        print(itemArray)
        
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
                    
                    let newTodoItem = Item(context: self.context)
                    newTodoItem.title = newitem
                    newTodoItem.isDone = false
                    
                    self.itemArray.append(newTodoItem)
                    
                    self.saveItems()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data \(error)")
        }
    }
    
}
