//
//  MyImagePageController.swift
//  SupremeSaintApp
//
//  Created by Faizan on 23/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class MyImagePageController: UIPageViewController, UIPageViewControllerDataSource {

    

    var imagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataSource = self
        openPermission()
        
    }

    func openPermission()
    {
        if let startingViewController = self.contentViewController(at: 0) {
            self.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
   
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! MyImageContainerVC).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! MyImageContainerVC).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    
    func contentViewController(at index: Int) -> MyImageContainerVC? {
        if index < 0 || index >= imagesArray.count {
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "MyImageContainerVC") as? MyImageContainerVC {
            
            pageContentViewController.imageFile = imagesArray[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
        
    }
    
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    

}
