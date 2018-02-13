//
//  LeftMenuVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 12/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import FirebaseAuth

class LeftMenuVC: UIViewController {

    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var accountSettings: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    
    var webUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(LeftMenuVC.logoImg(tap:)))
        tap.numberOfTapsRequired = 1
        logoImg.addGestureRecognizer(tap)
        
    }
    
    @objc func logoImg(tap : UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "HomeVC", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if Auth.auth().currentUser != nil
        {
            if Auth.auth().currentUser!.isAnonymous
            {
                usernameLbl.text = "Anonymous"
                accountSettings.isHidden = true
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
        
        ProgressHUD.dismiss()
    }
    
    
    
    @IBAction func meetSaintTapped(_ sender: Any) {
        webUrl = "http://thesupremesaint.com/meet-the-saints/"
       performSegue(withIdentifier: "WebSegue", sender: nil)
    }

    @IBAction func FAQTapped(_ sender: Any) {
        webUrl = "http://thesupremesaint.com/faq/"
        performSegue(withIdentifier: "WebSegue", sender: nil)
    }

    @IBAction func reviewsTapped(_ sender: Any) {
        let appstoreURL = URL(string: "itms://itunes.apple.com/us/app/id1227236636")
        if UIApplication.shared.canOpenURL(appstoreURL!) {
            UIApplication.shared.open(appstoreURL!, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open((URL(string: "https://itunes.apple.com/us/app/id1227236636"))!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func blogTapped(_ sender: Any) {
        webUrl = "http://thesupremesaint.com/blog/"
        performSegue(withIdentifier: "WebSegue", sender: nil)
    }

    @IBAction func fandfeedTapped(_ sender: Any) {
        webUrl = "http://www.instagram.com/TheSupremeSaint"
        performSegue(withIdentifier: "WebSegue", sender: nil)
    }
    
    @IBAction func instaFollowTapped(_ sender: Any) {
        let instagramURL = URL(string: "instagram://user?screen_name=TheSupremeSaint")
        if UIApplication.shared.canOpenURL(instagramURL!) {
            UIApplication.shared.open(instagramURL!, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open((URL(string: "http://www.instagram.com/TheSupremeSaint"))!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func twitterFollowTapped(_ sender: Any) {
        let twitterURL = URL(string: "twitter://user?screen_name=TheSupremeSaint")
        if UIApplication.shared.canOpenURL(twitterURL!) {
            UIApplication.shared.open(twitterURL!, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open((URL(string: "http://www.twitter.com/TheSupremeSaint"))!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "AuthVC", sender: nil)
        }catch(let error)
        {
            print(error)
        }
    }
    
    @IBAction func accountSettingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "AccountVC", sender: nil)
    }
    
    @IBAction func termConTapped(_ sender: Any) {
        webUrl = "http://thesupremesaint.com/terms-and-conditions/"
        performSegue(withIdentifier: "WebSegue", sender: nil)
    }

    @IBAction func privacyPolicyTapped(_ sender: Any) {
        webUrl = "http://thesupremesaint.com/privacy-policy/"
        performSegue(withIdentifier: "WebSegue", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebSegue"
        {
            if let navigationController = segue.destination as? UINavigationController {
                let vc = navigationController.topViewController as! WebVc
                vc.webUrl = webUrl
            }
        }
    }
    
    
    
    





    

}
