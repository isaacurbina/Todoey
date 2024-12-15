//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Isaac Urbina on 12/14/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

	private var categories : [Category] = []
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
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
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text
			self.categories.append(newCategory)
			self.saveCategories()
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
		return categories.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		let item = categories[indexPath.row]
		cell.textLabel?.text = item.name
		return cell
	}
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			let selectedCategory = categories[indexPath.row]
			destinationVC.setCategory(selectedCategory)
		}
	}
	
	// MARK: - Data Manipulation Methods
	
	private func saveCategories() {
		do {
			try context.save()
		} catch {
			print("Error saving categories: \(error)")
		}
		tableView.reloadData()
	}
	
	private func loadCategories() {
		let request : NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error loading categories: \(error)")
		}
		tableView.reloadData()
	}
}
