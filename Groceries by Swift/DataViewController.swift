//
//  DataViewController.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 10/2/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import UIKit

class DataViewController: UITableViewController {

    var dataObject: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataObject! as GroceryList).groceries.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        let groceries: [String] = (dataObject! as GroceryList).groceries
        
        if indexPath.row == groceries.count {
            cell.textLabel!.text = "Add item..."
        } else {
            cell.textLabel!.text = (dataObject! as GroceryList).groceries[indexPath.row]
        }
        return cell
    }

}

