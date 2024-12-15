//
//  Data.swift
//  Todoey
//
//  Created by Isaac Urbina on 12/15/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var age: Int = 0
}
