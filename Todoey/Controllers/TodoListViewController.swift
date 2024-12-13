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
	private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	// MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
		loadItems()
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
		saveItems()
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
				self.saveItems()
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
	
	// MARK: - private functions
	private func saveItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding item array: \(error)")
		}
	}
	
	private func loadItems() {
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array: \(error)")
			}
		}
	}
}
