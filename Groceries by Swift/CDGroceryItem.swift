//
//  CDGroceryItem.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 12/27/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import Foundation
import CoreData

@objc(CDGroceryItem)
class CDGroceryItem: NSManagedObject {

    @NSManaged var itemName: String
    @NSManaged var done: NSNumber
    @NSManaged var list: NSManagedObject

}
