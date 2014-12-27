//
//  RootViewController.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 10/2/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?
    var groceryLists: [GroceryList] = []
    
    @IBOutlet weak var navItem: UINavigationItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroceries()
        
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)

        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        doTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroceries() {
        groceryLists.append(GroceryList(listName: "Walmart", groceries: [GroceryItem(itemName: "milk"), GroceryItem(itemName: "candy"), GroceryItem(itemName: "cookies"), GroceryItem(itemName: "water")]))
        groceryLists.append(GroceryList(listName: "Kroger", groceries: [GroceryItem(itemName: "beer"), GroceryItem(itemName: "bread")]))
        groceryLists.append(GroceryList(listName: "Target", groceries: [GroceryItem(itemName: "doughnuts"), GroceryItem(itemName: "coffee"), GroceryItem(itemName: "creamer")]))
        groceryLists.append(GroceryList(listName: "Tom Thumb", groceries: [GroceryItem(itemName: "bagels"), GroceryItem(itemName: "cream cheese")]))
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
            _modelController!.updateList(self.groceryLists)
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
            doTitle()
    }

    // Add a new list
    
    @IBAction func addListButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Grocery List", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler{ (txtListName:UITextField!) -> Void in
            txtListName.placeholder = "Enter a list name"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            let listName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if listName == "" {
                self.showMsg("Missing Name!", msg: "Enter a valid list name.")
            } else {
                self.groceryLists.append(GroceryList(listName: listName, groceries: []))
                self.modelController.updateList(self.groceryLists)
                let newListController: DataViewController = self.modelController.viewControllerAtIndex(self.groceryLists.count - 1, storyboard: self.storyboard!)!
                self.pageViewController!.setViewControllers([newListController], direction: .Forward, animated: true, completion: {done in })
                self.navItem.title = listName
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    // Edit current list
    
    @IBAction func editListButtonPressed(sender: UIBarButtonItem) {
        
        let currentViewController = self.pageViewController!.viewControllers[0] as DataViewController
        var index = self.modelController.indexOfViewController(currentViewController as DataViewController)
        
        let alert = UIAlertController(title: "List: " + self.groceryLists[index].listName, message: "Edit name and tap update.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler{ (txtListName:UITextField!) -> Void in
            txtListName.placeholder = "Enter a list name"
            txtListName.text = self.groceryLists[index].listName
        }
        
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            let listName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if listName == "" {
                self.showMsg("Missing Name!", msg: "Enter a valid item name.")
            } else {
                self.groceryLists[index].listName = listName
                self.modelController.updateList(self.groceryLists)
                self.navItem.title = listName
            }
        }))
        
        
        
        if groceryLists.count > 1 {
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
                
                let alert2 = UIAlertController(title: "Delete List: " + self.groceryLists[index].listName, message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alert2.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                    self.groceryLists.removeAtIndex(index)
                    self.modelController.updateList(self.groceryLists)
                    
                    var direction = UIPageViewControllerNavigationDirection.Forward
                    if self.groceryLists.count == index {
                        direction = UIPageViewControllerNavigationDirection.Reverse
                        index--
                    }
                    
                    let newListController: DataViewController = self.modelController.viewControllerAtIndex(index, storyboard: self.storyboard!)!
                    self.pageViewController!.setViewControllers([newListController], direction: direction, animated: true, completion: {done in })
                    self.doTitle()
                }))
            
                alert2.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            
                self.presentViewController(alert2, animated: false, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    // Show message dialog
    
    func showMsg(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    func doTitle() {
        let currentViewController = self.pageViewController!.viewControllers[0] as DataViewController
        navItem.title = self.modelController.titleOfViewController(currentViewController)
    }
}

