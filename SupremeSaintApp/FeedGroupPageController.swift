//
//  FeedGroupPageController.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class FeedGroupPageController: UIPageViewController {

    var viewModel:ViewModel?
    {
        didSet{
            if isViewLoaded
            {
                refreshPageViewController()
            }
        }
    }
    
    private var feedViewControllers:[FeedViewController]?
//    private var inilized:Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logoIV = UIImageView()
        logoIV.contentMode = .scaleAspectFit
        logoIV.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = logoIV

        navigationItem.backBarButtonItem?.title = "Back"

        if feedViewControllers == nil
        {
            refreshPageViewController()
        }
        
        // Do any additional setup after loading the view.
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if let index = feedViewControllers?.index(where: {$0 == viewController})
//       {
//            if index < feedViewControllers!.count - 1
//            {
//                return feedViewControllers![index+1]
//             }
//        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if let index = feedViewControllers?.index(where: {$0 == viewController})
//        {
//            if index > 0
//            {
//                return feedViewControllers![index-1]
//            }
//        }
        return nil
    }
    
    private func refreshPageViewController()
    {
        feedViewControllers = []
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let model = viewModel
        {
            for feed in model.feeds
            {
                let vc = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
                vc.feed = feed
                feedViewControllers!.append(vc)
            }
        
        dataSource = nil
        dataSource = nil
        if let index = feedViewControllers?.index(where: {$0.feed!.name ==  model.selectedFeed.name})
        {
            setViewControllers([feedViewControllers![index]], direction: .forward, animated: false, completion: nil)
        }
        }
    }

    struct ViewModel {
        var feeds:[Feed]
        var selectedFeed:Feed
    }
    
}
