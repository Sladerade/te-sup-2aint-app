//
//  SignUpVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 11/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class SignUpVC: UIViewController,Alertable {
    
    @IBOutlet weak var usernameField: DesignableField!
    @IBOutlet weak var pwdField: DesignableField!
    @IBOutlet weak var emailField: DesignableField!
    @IBOutlet weak var confirmPwdField: DesignableField!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        ProgressHUD.show("Please Wait ..")
        
        guard let email = emailField.text, let password = pwdField.text, let username = usernameField.text, let confirmPwd = confirmPwdField.text, email != "" , username != "" , password != "", confirmPwd != "" else {
            
            self.showAlert(_message: "Please fill all fields to log in")
            ProgressHUD.dismiss()
            return
            
        }
        
        Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists()
            {
                self.showAlert(_message: "Sorry username already has been taken. Choose a diffrent one")
                return 
            }
            else
            {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error == nil
                    {
                        ProgressHUD.dismiss()
                        
                        let userData = ["userEmail":email, "username": username, "provider": user!.providerID ] as [String:Any]
                        FirebaseService.instance.createFirebaseUser(uid: user!.uid, userData: userData)
                        
                        
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
        
        if password != confirmPwd
        {
            self.showAlert(_message: "Password does'nt matched. Try Again.")
            ProgressHUD.dismiss()
            return
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
