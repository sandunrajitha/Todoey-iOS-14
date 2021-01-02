//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var items: Results<Item>?
    var category: Category? {
        didSet {
            loadData()
        }
    }
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        
        if let item = items?[indexPath.row] {
            cell.textLabel!.text = item.title
            cell.accessoryType = item.isDone ?  .checkmark :  .none
        } else {
            cell.textLabel!.text = "No Items added yet"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do {
                try realm.write{
                    
//                    realm.delete(item)
                    item.isDone = !item.isDone
                    self.tableView.reloadData()
                }
            } catch {
                print("error marking as done \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                    
                    if self.category != nil {
                        
                        let newTodoItem = Item()
                        newTodoItem.title = newitem
                        
                        do {
                            try self.realm.write{
                                self.category?.items.append(newTodoItem)
                            }
                        } catch {
                            print("error saving item \(error)")
                        }
                        
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadData(){
        
        items = category?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar Delegate methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchData(for: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchData(for: searchBar.text!)
        }
    }

    func searchData(for searchText: String){
        
        items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
}
