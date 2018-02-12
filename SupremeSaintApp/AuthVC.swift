//
//  AuthVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 11/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class AuthVC: UIViewController,Alertable {

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }

    @IBAction func anonymousTapped(_ sender: Any) {
        
        ProgressHUD.show("Please Wait ..")
        
        Auth.auth().signInAnonymously { (user, error) in
            
            if error == nil
            {
                ProgressHUD.dismiss()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller")
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
            else
            {
                ProgressHUD.dismiss()
                self.showAlert(_message: error!.localizedDescription)
                print(error.debugDescription)
            }
        }
        
    }

}
