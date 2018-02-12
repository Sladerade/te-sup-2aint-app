//
//  LoginVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 11/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class LoginVC: UIViewController,Alertable {
    
    @IBOutlet weak var pwdField: DesignableField!
    @IBOutlet weak var emailField: DesignableField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {

        ProgressHUD.show("Please Wait ..")
        
        guard let email = emailField.text, let password = pwdField.text, email != "" , password != "" else {
            
            self.showAlert(_message: "Please fill all fields to log in")
            ProgressHUD.dismiss()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
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
                print(error!.localizedDescription)
            }
            
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
