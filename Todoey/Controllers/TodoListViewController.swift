//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	private var itemArray : [Item]  = []
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
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
		context.delete(itemArray[indexPath.row])
		itemArray.remove(at: indexPath.row)
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
				let newItem = Item(context: self.context)
				newItem.title = input
				newItem.done = false
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
		do {
			try context.save()
		} catch {
			print("Error saving context: \(error)")
		}
	}
	
	private func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest()) {
		do {
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context: \(error)")
		}
	}
}

// MARK: - UISearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request : NSFetchRequest<Item> = Item.fetchRequest()
		if let query = searchBar.text {
			if (!query.isEmpty) {
				request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
				request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.title, ascending: true)]
			}
			loadItems(request)
			tableView.reloadData()
		}
	}
}
