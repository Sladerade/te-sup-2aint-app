//
//  WalkthroughImageController.swift
//  SupremeSaintApp
//
//  Created by Faizan on 13/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase

class WalkthroughImageController: UIPageViewController, UIPageViewControllerDataSource {


    var storedData = UserDefaults.standard
    var imagesArray = [String]()
    
    var feed:Feed?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        queryImage()
        
        
    }
    
    
    
    func queryImage()
    {
        if let feed = feed{
            if self.storedData.integer(forKey: "ForVote") == 0{
                Database.database().reference().child("Catalog").child(feed.id).child("Photos").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let photos = snapshot.value as? NSArray
                    {
                        for i in 1..<photos.count
                        {
                            if let _ = URL(string: photos[i] as! String)
                            {
                                self.imagesArray.append(photos[i] as! String)
                            }
                            
                        }
                        self.openPermission()
                    }
                })
                
            }
            else{
                Database.database().reference().child("Catalog").child(feed.id).child("Photos").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let photos = snapshot.value as? NSArray
                    {
                        for i in 1..<photos.count
                        {
                            if let _ = URL(string: photos[i] as! String)
                            {
                                self.imagesArray.append(photos[i] as! String)
                            }
                        }
                        self.openPermission()
                    }
                })
                
            }
            
        }
    }
    
    func openPermission()
    {
        if let startingViewController = self.contentViewController(at: 0) {
            self.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughImageContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughImageContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    
    func contentViewController(at index: Int) -> WalkthroughImageContentViewController? {
        if index < 0 || index >= imagesArray.count {
            return nil
        }
        
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughImageContentViewController") as? WalkthroughImageContentViewController {
            
            pageContentViewController.imageFile = imagesArray[index]
            pageContentViewController.index = index
            pageContentViewController.numberPages = imagesArray.count
            pageContentViewController.imagesArray = imagesArray
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
