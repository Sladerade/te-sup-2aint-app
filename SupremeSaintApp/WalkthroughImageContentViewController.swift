//
//  WalkthroughImageContentViewController.swift
//  SupremeSaintApp
//
//  Created by Faizan on 13/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Kingfisher

class WalkthroughImageContentViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var outletImg: UIImageView!
    
    var index = 0
    var imageFile = ""
    var numberPages  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("faizan ka \(index)")
        pageControl.numberOfPages = numberPages
        print(imageFile)
    }

   
}
