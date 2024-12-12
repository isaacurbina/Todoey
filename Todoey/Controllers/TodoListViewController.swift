//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	private var itemArray : [Item]  = []
	private let defaults = UserDefaults.standard
	private let defaultsKey = "TodoListArray"

	// MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
		let newItem = Item()
		newItem.title = "Find Mike"
		newItem.done = true
		itemArray.append(newItem)
		
		let newItem2 = Item()
		newItem2.title = "Buye Eggos"
		itemArray.append(newItem2)
		
		let newItem3 = Item()
		newItem3.title = "Destroy Demogorgons"
		itemArray.append(newItem3)
		
		if let safeItems = defaults.array(forKey: defaultsKey) as? [Item] {
			itemArray = safeItems
		}
    }
	
	// MARK: - TableView DataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]
		cell.textLabel?.text = item.title
		cell.accessoryType = item.done ? .checkmark : .none
		return cell
	}
	
	// MARK: - TableView Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - IBActions
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { action in
			if let input = textField.text {
				let newItem = Item()
				newItem.title = input
				self.itemArray.append(newItem)
				self.defaults.set(self.itemArray, forKey: self.defaultsKey)
				self.tableView.reloadData()
			}
		}
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Create New Item"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}
