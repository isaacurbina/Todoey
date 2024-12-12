//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	private var itemArray : [String]  = ["Find Mike", "Buye Eggos", "Destroy Demogorgons"]
	private let defaults = UserDefaults.standard
	private let defaultsKey = "TodoListArray"

	// MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
		if let safeItems = defaults.array(forKey: defaultsKey) as? [String] {
			itemArray = safeItems
		}
    }
	
	// MARK: - TableView DataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
	}
	
	// MARK: - TableView Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath)
		if cell?.accessoryType == .checkmark {
			cell?.accessoryType = .none
		} else {
			cell?.accessoryType = .checkmark
		}
	}
	
	// MARK: - IBActions
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { action in
			if let input = textField.text {
				self.itemArray.append(input)
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
