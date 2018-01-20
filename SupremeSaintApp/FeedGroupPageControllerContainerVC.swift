//
//  FeedGroupPageControllerContainerVC.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class FeedGroupPageControllerContainerVC: UIViewController {

    @IBOutlet weak var pageContainer: UIView!
    
    var viewModel:ViewModel!
    {
        didSet{
            if isViewLoaded
            {
                feedPageViewController?.viewModel = FeedGroupPageController.ViewModel(feeds: viewModel.feeds, selectedFeed: viewModel.selectedFeed)
            }
        }
    }
    
    private var feedPageViewController:FeedGroupPageController?{
       
        if !isViewLoaded
        {
            return nil
        }
        
        return pageContainer.subviews[0].next as? FeedGroupPageController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if feedPageViewController?.viewModel == nil
       {
        feedPageViewController?.viewModel = FeedGroupPageController.ViewModel(feeds: viewModel.feeds, selectedFeed: viewModel.selectedFeed)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    public struct ViewModel
    {
        var feeds:[Feed]
        var selectedFeed:Feed
    }

}
