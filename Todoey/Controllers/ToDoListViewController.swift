//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    var category: Category? {
        didSet {
            loadData()
        }
    }
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        self.navigationItem.title = category?.name
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller not found")}
        
        if let colorHex = category?.cellColour {
            title = category?.name
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
            navBarAppearance.backgroundColor = UIColor(hexString: colorHex)
            
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)
//            navBar.barStyle = .default
            navBar.barStyle = .black
            
            searchBar.barTintColor = UIColor(hexString: colorHex)
            searchBar.isTranslucent = true
            searchBar.searchTextField.backgroundColor = .white
            searchBar.tintColor = UIColor(hexString: colorHex)
            searchBar.searchTextField.textColor = UIColor(hexString: colorHex)
            searchBar.searchTextField.leftView?.tintColor = UIColor(hexString: colorHex)
        }
        
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = items?[indexPath.row] {
            cell.textLabel!.text = item.title
            cell.accessoryType = item.isDone ?  .checkmark :  .none
        } else {
            cell.textLabel!.text = "No Items added yet"
        }
        
        if let colour  = UIColor(hexString: category!.cellColour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)){
            cell.backgroundColor = colour
            cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
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
            
            if let newitemTitle = alert.textFields?[0].text{
                if newitemTitle != ""{
                    
                    if self.category != nil {
                        
                        let newTodoItem = Item()
                        newTodoItem.title = newitemTitle
                        newTodoItem.dateCreated = Date()
                        
                        do {
                            try self.realm.write{
                                self.category?.items.append(newTodoItem)
                                self.tableView.reloadData()
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
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.items?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch {
                print("error deleting category \(error)")
            }
        }
    }
    
    
    func loadData(){
        
        items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
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
        
        items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
    }
}
