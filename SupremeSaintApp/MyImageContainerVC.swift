//
//  MyImageContainerVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 23/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Kingfisher

class MyImageContainerVC: UIViewController {

    @IBOutlet weak var outletImg: UIImageView!
    
    
    var index = 0
    var imageFile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outletImg.kf.setImage(with: URL(string: imageFile))
    
    }

    

}
