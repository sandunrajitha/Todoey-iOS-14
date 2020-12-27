//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/27/20.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    // MARK: - Add new Category methods
    
    // MARK: - Data manipulation methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching category \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
