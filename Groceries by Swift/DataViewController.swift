//
//  DataViewController.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 10/2/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import UIKit

class DataViewController: UITableViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: AnyObject?
    
    var groceries: [String] = ["1 gallon of regular milk", "Bud light 6 pack", "Whole wheat bread", "Dozen doughnuts"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Need to figure out how to set this label later....
        if let obj: AnyObject = dataObject {
            // self.dataLabel!.text = obj.description
        } else {
            // self.dataLabel!.text = ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groceries.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = groceries[indexPath.row]
        return cell
    }

}

