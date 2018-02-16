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
    
    
    @IBAction func forgotPwd(_ sender: Any) {
        
        showAlertWithTextFields()
    }
    

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func showAlertWithTextFields() {
        
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter your email address to recover password", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
            alert -> Void in
            
            let emailTextField = alertController.textFields![0] as UITextField
            
            
            if emailTextField.text != ""{
                
                Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                    
                    if let error = error
                    {
                        self.showAlert(_message: error.localizedDescription)
                        return
                    }
                    
                    self.succesfullMsg()
                    
                })
                
            }
            else{
                
                self.showAlert(_message: "Field should not be empty, Please enter email address..")
                return
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func succesfullMsg()
    {
        let alert = UIAlertController(title: "Email Sent", message: "Your Password recovery email has been sent. Check your email to recover it.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
