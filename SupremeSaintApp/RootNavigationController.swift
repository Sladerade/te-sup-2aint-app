//
//  RootNavigationController.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/19/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    
    var logoIV:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logoIV = UIImageView()
        logoIV.contentMode = .scaleAspectFit
//        logoIV.translatesAutoresizingMaskIntoConstraints = false
        logoIV.image = #imageLiteral(resourceName: "logo")
                navigationBar.topItem?.titleView = logoIV
//        navigationBar.addSubview(logoIV)
//        let aspect = logoIV.image!.size.height/logoIV.image!.size.width
//        let width = navigationBar.frame.height/aspect
//        logoIV = UIImageView(frame:CGRect(x:(view.frame.width - width)/2,y:0,width:width-40,height:navigationBar.frame.height))

    }
    
    override func viewDidLayoutSubviews() {
        
//        let aspect = logoIV.image!.size.height/logoIV.image!.size.width
//        let width = navigationBar.frame.height/aspect
//        logoIV = UIImageView(frame:CGRect(x:(view.frame.width - width)/2,y:0,width:width,height:navigationBar.frame.height))
    }

}

class ViewControllerWithLogo:UIViewController{
    override func viewDidLoad() {
        let logoIV = UIImageView()
        logoIV.contentMode = .scaleAspectFit
        logoIV.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = logoIV
    }
}
