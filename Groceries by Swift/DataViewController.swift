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
    var rvc: RootViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataObject! as CDGroceryList).groceries.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        let groceries = (dataObject! as CDGroceryList).groceries.allObjects
        
        if indexPath.row == groceries.count {
            cell.textLabel!.text = "Add item..."
        } else {
            let gItem = groceries[indexPath.row] as CDGroceryItem
            cell.textLabel!.text = gItem.itemName + (gItem.done == true ? "  \u{2713}" : "")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gList = dataObject! as CDGroceryList
        
        if(gList.groceries.count == indexPath.row) {
            // Add Item...
            let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler{ (txtItemName:UITextField!) -> Void in
                txtItemName.placeholder = "Enter an item name"
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                let itemName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if itemName == "" {
                    self.showMsg("Missing Name!", msg: "Enter a valid item name.")
                } else {
                    // gList.groceries.append(GroceryItem(itemName: itemName))
                    var groceries = gList.groceries.allObjects as [CDGroceryItem]
                    groceries.append(self.rvc!.insertGroceryItem(itemName))
                    gList.groceries = NSSet(array: groceries)
                    self.rvc!.redoPages()
                    tableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: false, completion: nil)
        }
        else {
            // Edit Item...
            var gItem = gList.groceries.allObjects[indexPath.row] as CDGroceryItem
            
            let alert = UIAlertController(title: "Item: " + gItem.itemName, message: "Edit name and tap update.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler{ (txtItemName:UITextField!) -> Void in
                txtItemName.placeholder = "Enter an item name"
                txtItemName.text = gItem.itemName
            }
            
            alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                let itemName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if itemName == "" {
                    self.showMsg("Missing Name!", msg: "Enter a valid item name.")
                } else {
                    gItem.itemName = itemName
                    self.rvc!.redoPages()
                    tableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: gItem.done == true ? "Uncheck" : "Check!", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                let itemName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if itemName == "" {
                    self.showMsg("Missing Name!", msg: "Enter a valid item name.")
                } else {
                    gItem.itemName = itemName
                    gItem.done = (gItem.done == true ? false : true)
                    self.rvc!.redoPages()
                    tableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
                self.rvc!.moCtx.deleteObject(gItem)
                self.rvc!.redoPages()
                tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: false, completion: nil)
        }
    }
    
    // Show message dialog
    
    func showMsg(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
}

