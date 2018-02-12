//
//  LeftMenuVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 12/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LeftMenuVC: UIViewController {

    
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Auth.auth().currentUser != nil
        {
            if Auth.auth().currentUser!.isAnonymous
            {
                usernameLbl.text = "Anonymous"
            }
            else
            {
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                    if let user = snapshot.value as? Dictionary<String,Any>
                    {
                        let username = user["username"] as! String
                        self.usernameLbl.text = username
                    }
                    
                })
            }
        }
        
        
    }

    

}
