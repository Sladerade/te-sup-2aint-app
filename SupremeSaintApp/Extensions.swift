//
//  Extensions.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/16/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response,error) in
            
            if error != nil{
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
    
    
    
}

class UIPageViewControllerWithOverlayIndicator: UIPageViewController {
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubview(toFront: subView)
            }
        }
        super.viewDidLayoutSubviews()
    }
}
