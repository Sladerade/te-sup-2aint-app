
//
//  AccountVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 12/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class AccountVC: UIViewController,Alertable {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if Auth.auth().currentUser != nil
        {
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let user = snapshot.value as? Dictionary<String,Any>
                {
                    let username = user["username"] as! String
                    self.usernameField.text = username
                }
                
            })
            
        }
    }
    
    
    @IBAction func continueTapped(_ sender: Any)
    {
        ProgressHUD.show()
        guard let username = usernameField.text, username != ""  else {
            
            self.showAlert(_message: "Please Type Something")
            ProgressHUD.dismiss()
            return
        }
        continueBtn.isEnabled = false
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["username": username]) { (error, refrence) in
            
            self.continueBtn.isEnabled = true
            ProgressHUD.dismiss()
            self.Message()
            self.showAlert(_message: error!.localizedDescription)
            
        }
        
    }
    
    
    func Message()
    {
        let alert = UIAlertController(title: "Account Updated", message: "Your Account has been updated", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
}
