//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Isaac Urbina on 12/17/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			self.updateModel(at: indexPath)
		}
		deleteAction.image = UIImage(named: "delete-icon")
		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
		options.transitionStyle = .border
		return options
	}
	
	func updateModel(at indexPath: IndexPath) {
		// NOOP, to be overriden by subclass
	}
}
