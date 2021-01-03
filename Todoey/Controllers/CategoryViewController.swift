//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/27/20.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75
        loadData()
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.text = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.category = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add new Category method
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Enter New Category"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            if let newCategory = alert.textFields?[0].text{
                if newCategory != ""{
                    let category = Category()
                    category.name = newCategory
                    
                    self.save(category: category)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data manipulation methods
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
    }
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let category = self.categories?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(category)
                }
            } catch {
                print("error deleting category \(error)")
            }
        }
    }
}
