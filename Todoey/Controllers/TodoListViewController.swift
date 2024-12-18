//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
	
	private let realm = try! Realm()
	private var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	private var items : Results<Item>? = nil
	
	// MARK: - IBOutlets
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.separatorStyle = .none
		title = selectedCategory?.name
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if let categoryColour = selectedCategory?.colour {
			guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}
			if let bgColour = UIColor(hexString: categoryColour) {
				let contrastColour = ContrastColorOf(bgColour, returnFlat: true)
				navBar.barTintColor = bgColour
				navBar.tintColor = bgColour
				navBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColour, returnFlat: true)]
				navBar.compactAppearance?.backgroundColor = bgColour
				navBar.standardAppearance.backgroundColor = bgColour
				navBar.scrollEdgeAppearance?.backgroundColor = bgColour
				navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: contrastColour]
				navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColour]
				searchBar.tintColor = bgColour
				searchBar.barTintColor = contrastColour
			}
		}
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
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if let item = items?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
			if let category = selectedCategory {
				let percentage = CGFloat(indexPath.row) / CGFloat(items!.count)
				if let backgroundColour = UIColor(hexString: category.colour) {
					cell.backgroundColor = backgroundColour.darken(byPercentage: percentage)
					cell.textLabel?.textColor = ContrastColorOf(backgroundColour, returnFlat: true)
				}
			}
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
	
	// MARK: - SwipeTableViewController
	
	override func updateModel(at indexPath: IndexPath) {
		if let todoToDelete = self.items?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(todoToDelete)
				}
			} catch {
				print("Error deleting todo item: \(error)")
			}
		}
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
