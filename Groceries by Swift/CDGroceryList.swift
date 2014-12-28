//
//  CDGroceryList.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 12/27/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import Foundation
import CoreData

@objc(CDGroceryList)
class CDGroceryList: NSManagedObject {
    
    @NSManaged var listName: String
    @NSManaged var groceries: NSSet
    
}
