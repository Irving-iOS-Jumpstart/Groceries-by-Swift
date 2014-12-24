//
//  GroceryList.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 12/24/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import Foundation

class GroceryList {
    var listName: String
    var groceries: [String] = []
    
    init(listName: String, groceries: [String]) {
        self.listName = listName
        self.groceries = groceries
    }
}