//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/15/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["buy apple", "buy milk", "buy cheese", "buy natto"]
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
        print(indexPath)
        cell.textLabel!.text = "\(itemArray[indexPath.row])"
        return cell
    }
}
