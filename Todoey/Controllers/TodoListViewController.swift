//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
	
	private let realm = try! Realm()
	private var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	private var items : Results<Item>? = nil
	
	// MARK: - UIViewController
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// MARK: - Setter/getter
	
	func setCategory(_ category: Category) {
		self.selectedCategory = category
	}
	
	// MARK: - TableView DataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		if let item = items?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
		}
		return cell
	}
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let item = items?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
					//realm.delete(item)
				}
			} catch {
				print("Error saving done status: \(error)")
			}
		}
		tableView.reloadData()
	}
	
	// MARK: - IBActions
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { action in
			
			if let input = textField.text {
				if let parentCategory = self.selectedCategory {
					do {
						try self.realm.write {
							let newItem = Item()
							newItem.title = input
							newItem.done = false
							newItem.dateCreated = Date()
							parentCategory.items.append(newItem)
						}
					} catch {
						print("Error saving new item: \(error)")
					}
					self.loadItems()
				}
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
	
	private func loadItems() {
		items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}
}

// MARK: - UISearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let query = searchBar.text {
			if !query.isEmpty {
				items = items?.filter("title CONTAINS[cd] %@", query).sorted(byKeyPath: "dateCreated", ascending: true)
				tableView.reloadData()
			}
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if let query = searchBar.text {
			if query.isEmpty {
				loadItems()
				DispatchQueue.main.async {
					searchBar.resignFirstResponder()
				}
			}
		}
	}
}
