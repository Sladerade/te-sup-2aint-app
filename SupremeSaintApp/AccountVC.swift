
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
    @IBOutlet weak var pwdField: DesignableField!
   // @IBOutlet weak var emailField: DesignableField!
    @IBOutlet weak var confirmPwdField: DesignableField!
    
    
    let user = Auth.auth().currentUser
    var credential: AuthCredential!
    
    var useremail = ""
    
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
                    let email = user["userEmail"] as! String
                    
                    self.useremail = email
                    self.usernameField.text = username
                }
                
            })
            
        }
    }
    
    
    @IBAction func continueTapped(_ sender: Any)
    {
        
        ProgressHUD.show("Please Wait ..")
        
        guard let username = usernameField.text , username != ""  else {
            
            self.showAlert(_message: "Please fill field to change username")
            ProgressHUD.dismiss()
            return
            
        }
        
        Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists()
            {
                ProgressHUD.dismiss()
                self.showAlert(_message: "Sorry username already has been taken. Choose a diffrent one")
                return
            }
            else
            {
                ProgressHUD.dismiss()
                self.Message()
                let userData = ["username": username] as [String:Any]
            Database.database().reference().child("users").child(self.user!.uid).updateChildValues(userData)
                
            }
            
        }
        
    
    }
    
    @IBAction func continuePasswordTapped(_ sender: Any)
    {
        ProgressHUD.show("Please Wait ..")
        
        guard let password = pwdField.text, let confirmPwd = confirmPwdField.text  , password != "", confirmPwd != "" else {
            
            self.showAlert(_message: "Please fill all fields to change password")
            ProgressHUD.dismiss()
            return
            
        }
        
        if password != confirmPwd
        {
            self.showAlert(_message: "Password does'nt matched. Try Again.")
            ProgressHUD.dismiss()
            return
        }
        
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                ProgressHUD.dismiss()
                self.showAlert(_message: error.localizedDescription)
                return
            }
            
            self.pwdField.text = ""
            self.confirmPwdField.text = ""
            ProgressHUD.dismiss()
            self.Message()
        
        })
    }
    
    
    @IBAction func homeTapped(_ sender: Any)
    {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = board.instantiateViewController(withIdentifier: "tabBarcontroller")
        UIApplication.shared.keyWindow?.rootViewController = tabBar
        
    }
    
    
    
    
    
    
    
    func Message()
    {
        let alert = UIAlertController(title: "Account Updated", message: "Your Account has been updated", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    
}
