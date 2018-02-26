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
    var imagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.currentPage = index
        pageControl.numberOfPages = numberPages
        outletImg.kf.setImage(with: URL(string: imageFile), placeholder: #imageLiteral(resourceName: "preview"), options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(WalkthroughImageContentViewController.itemImg(tap:)))
        tap.numberOfTapsRequired = 1
        outletImg.addGestureRecognizer(tap)
    }
    
    
    @objc func itemImg(tap : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "ItemImageView", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemImageView"
        {
            if imagesArray.count > 0
            {
                let vc = segue.destination as! MyImageViewController
                vc.imagesArray = imagesArray
            }
            
        }
    }
    

   
}
