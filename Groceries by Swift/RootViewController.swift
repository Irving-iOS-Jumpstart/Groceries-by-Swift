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
        
        let currentViewController = self.pageViewController!.viewControllers[0] as DataViewController
        navItem.title = self.modelController.titleOfViewController(currentViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroceries() {
        groceryLists.append(GroceryList(listName: "Walmart", groceries: ["milk", "candy", "cookies", "water"]))
        groceryLists.append(GroceryList(listName: "Kroger", groceries: ["beer", "bread"]))
        groceryLists.append(GroceryList(listName: "Target", groceries: ["doughnuts", "coffee", "creamer"]))
        groceryLists.append(GroceryList(listName: "Tom Thumb", groceries: ["bagels", "cream cheese"]))
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController(pageData: groceryLists)
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
            let currentViewController = self.pageViewController!.viewControllers[0] as DataViewController
            navItem.title = self.modelController.titleOfViewController(currentViewController)
    }
}

