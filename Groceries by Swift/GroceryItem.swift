//
//  GroceryItem.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 12/27/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import Foundation

class GroceryItem {
    var itemName: String
    var done: Bool = false
    
    init(itemName: String) {
        self.itemName = itemName
    }
}
