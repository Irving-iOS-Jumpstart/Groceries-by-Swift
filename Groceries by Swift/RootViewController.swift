//
//  RootViewController.swift
//  Groceries by Swift
//
//  Created by Ramesh Somasundaram on 10/2/14.
//  Copyright (c) 2014 Will Learn. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UIViewController, UIPageViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    var pageViewController: UIPageViewController?
    var cdGroceryLists: [CDGroceryList] = []
    
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    let moCtx = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var gListFetcher: NSFetchedResultsController = NSFetchedResultsController()
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCDGroceries()
        
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
    
    func loadCDGroceries() {
        gListFetcher = getGroceryListFetcher()
        gListFetcher.delegate = self
        
        if gListFetcher.performFetch(nil) {
            cdGroceryLists = gListFetcher.fetchedObjects! as [CDGroceryList]
            if(cdGroceryLists.count == 0) {
                println("No List! Creating two...")
                insertGroceryList("Walmart").groceries = NSSet(array: [insertGroceryItem("Dozen Donughts"), insertGroceryItem("Coffee 1lb bag")])
                insertGroceryList("Kroger").groceries = NSSet(array: [insertGroceryItem("Whole Wheat Bread"), insertGroceryItem("Budlight 6 pack")])
                self.appDel.saveContext()
                loadCDGroceries()
            }
            else {
                for gList in gListFetcher.fetchedObjects! as [CDGroceryList] {
                    println("List: " + gList.listName)
                    for gItem in gList.groceries {
                        println(" - Item: " + (gItem as CDGroceryItem).itemName + " - \((gItem as CDGroceryItem).done)" )
                    }
                }
                println("----")
                var fReq = NSFetchRequest(entityName: "CDGroceryItem")
                var error:NSError? = nil
                var results: NSArray = self.moCtx.executeFetchRequest(fReq, error: &error)!
                for res in results as [CDGroceryItem] {
                    println("Item: \(res.itemName) - \(res.done)")
                }
                println("----")
            }
        }
    }
    
    func redoPages() {
        println("Saving and reloading lists...")
        self.appDel.saveContext()
        loadCDGroceries()
        modelController.updateList(self.cdGroceryLists)
    }
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
            _modelController!.setRVC(self)
            _modelController!.updateList(self.cdGroceryLists)
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
                self.insertGroceryList(listName)
                self.redoPages()
                
                let newListController: DataViewController = self.modelController.viewControllerAtIndex(self.cdGroceryLists.count - 1, storyboard: self.storyboard!)!
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
        
        let alert = UIAlertController(title: "List: " + self.cdGroceryLists[index].listName, message: "Edit name and tap update.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler{ (txtListName:UITextField!) -> Void in
            txtListName.placeholder = "Enter a list name"
            txtListName.text = self.cdGroceryLists[index].listName
        }
        
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            let listName: String = (alert.textFields![0] as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if listName == "" {
                self.showMsg("Missing Name!", msg: "Enter a valid item name.")
            } else {
                self.cdGroceryLists[index].listName = listName
                self.redoPages()
                self.navItem.title = listName
            }
        }))
        
        if cdGroceryLists.count > 1 {
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
                
                let alert2 = UIAlertController(title: "Delete List: " + self.cdGroceryLists[index].listName, message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alert2.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
                    self.moCtx.deleteObject(self.cdGroceryLists[index])
                    self.redoPages()
                    
                    var direction = UIPageViewControllerNavigationDirection.Forward
                    if self.cdGroceryLists.count == index {
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
    
    // Core Data Insert & Fetch
    
    func insertGroceryList(listName: String) -> CDGroceryList {
        let eDesc = NSEntityDescription.entityForName("CDGroceryList", inManagedObjectContext: self.moCtx)
        let gList = CDGroceryList(entity: eDesc!, insertIntoManagedObjectContext: self.moCtx)
        gList.listName = listName
        return gList
    }
    
    func updateGroceryList(listName: String) {
        
    }
    
    
    func insertGroceryItem(itemName: String) -> CDGroceryItem {
        let eDesc = NSEntityDescription.entityForName("CDGroceryItem", inManagedObjectContext: self.moCtx)
        let gItem = CDGroceryItem(entity: eDesc!, insertIntoManagedObjectContext: self.moCtx)
        gItem.itemName = itemName
        gItem.done = false
        return gItem
    }
    
    func getGroceryListFetchReq() -> NSFetchRequest {
        let fReq = NSFetchRequest(entityName: "CDGroceryList")
        // This sorts all upper and then lower case - not very useful! Need to sort this after retrieving from db
        // let sortDesc = NSSortDescriptor(key: "listName", ascending: true)
        // fReq.sortDescriptors = [sortDesc]
        fReq.sortDescriptors = []
        return fReq
    }
    
    func getGroceryListFetcher() -> NSFetchedResultsController {
        return NSFetchedResultsController(fetchRequest: getGroceryListFetchReq(), managedObjectContext: moCtx, sectionNameKeyPath: nil, cacheName: nil)
    }
}

