//
//  FeedViewController.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var feed:Feed?
    {
        didSet{
            if isViewLoaded
            {
                updateUIs()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUIs()

    }
    
    func updateUIs() {
        if let feed = feed
        {
            titleLabel.text = feed.name
            imageView.downloadImage(from: feed.photoUrl)
        }
    }


}
