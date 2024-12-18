//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Isaac Urbina on 12/14/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
	
	private let realm = try! Realm()
	private var categories : Results<Category>? = nil
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadCategories()
	}
	
	// MARK: - IBActions
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { _ in
			let newCategory = Category()
			newCategory.name = textField.text!
			self.save(newCategory)
		}
		alert.addAction(action)
		alert.addTextField { field in
			textField = field
			textField.placeholder = "Add a new category"
		}
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - TableView DataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		if let item = categories?[indexPath.row] {
			cell.textLabel?.text = item.name
		}
		return cell
	}
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			if let selectedCategory = categories?[indexPath.row] {
				destinationVC.setCategory(selectedCategory)
			}
		}
	}
	
	// MARK: - Data Manipulation Methods
	
	private func save(_ category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving categories: \(error)")
		}
		tableView.reloadData()
	}
	
	private func loadCategories() {
		categories = realm.objects(Category.self)
		tableView.reloadData()
	}
	
	// MARK: - SwipeTableViewController
	
	override func updateModel(at indexPath: IndexPath) {
		if let categoryToDelete = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryToDelete)
				}
			} catch {
				print("Error deleting category: \(error)")
			}
		}
	}
}
