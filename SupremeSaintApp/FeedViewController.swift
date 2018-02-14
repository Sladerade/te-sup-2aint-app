//
//  FeedViewController.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toaster
import Firebase
import FirebaseAuth
import Kingfisher





class FeedViewController: UIViewController, Alertable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var copBtn: UIButton!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    @IBOutlet weak var copLbl: UILabel!
    @IBOutlet weak var dropLbl: UILabel!
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl : UIPageControl!
    
    var totalYesVote:Double = 0
    var totalNoVote:Double = 0
    var storedData = UserDefaults.standard
    
    
    
    
    var id:String!
    var imageNumber = 0
    var countYesVotes = 0
    var countNoVotes = 0
    var totalVote:Double = 0
    var imagesArray = [String]()
    
    var feed:Feed?
    {
        didSet{
            if isViewLoaded
            {
                updateUIs()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id = Database.database().reference().childByAutoId().key
        updateUIs()
        //getAllVotes()
        getVotes()
        votesDisapper()
    }
    
    
    
    func votesDisapper()
    {
        copLbl.alpha = 0
        dropLbl.alpha  = 0
        superView.alpha = 0
        likes.alpha = 0
        disLikes.alpha = 0
    }
    
    func votesAppear()
    {
        copLbl.alpha = 1
        dropLbl.alpha  = 1
        superView.alpha = 1
        likes.alpha = 1
        disLikes.alpha = 1
    }
    
    
    
    func getVotes(){
        if let feed = feed {
            if self.storedData.integer(forKey:"ForVote") == 0{
                //Entry in catalog
                Database.database().reference().child("Catalog").child(feed.id).observe(.value, with: { (snapshot) in
                    for view in self.superView.subviews{
                        view.removeFromSuperview()
                    }
                    let value =  snapshot.value as? NSDictionary
                    self.countYesVotes = value?["YesVotes"] as? Int ?? 0
                    self.countNoVotes = value?["NoVotes"] as? Int ?? 0
                    self.likes.text = "\(self.countYesVotes)"
                    self.disLikes.text = "\(self.countNoVotes)"
                    
                    self.totalVote = Double(value?["YesVotes"] as? Int ?? 0) + Double(value?["NoVotes"] as? Int ?? 0)
                    let a = Double (self.countYesVotes)/self.totalVote
                    print("sanan \(a)")
                    if !a.isNaN{
                        let screenSize: CGRect = self.superView.bounds
                        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * CGFloat(a), height: screenSize.height))
                        myView.backgroundColor = UIColor.green
                        self.superView.addSubview(myView)
                    }
                })
            }
            else{
                //Entry in catalog
//                Database.database().reference().child("Catalog").child(feed.id).observe(.value, with: { (snapshot) in
//                    for view in self.superView.subviews{
//                        view.removeFromSuperview()
//                    }
//                    let value =  snapshot.value as? NSDictionary
//                    self.countYesVotes = value?["YesVotes"] as? Int ?? 0
//                    self.countNoVotes = value?["NoVotes"] as? Int ?? 0
//                    self.likes.text = "\(self.countYesVotes)"
//                    self.disLikes.text = "\(self.countNoVotes)"
//
//                    self.totalVote = Double(value?["YesVotes"] as? Int ?? 0) + Double(value?["NoVotes"] as? Int ?? 0)
//                    let a = Double (self.countYesVotes)/self.totalVote
//                    print("sanan \(a)")
//                    if !a.isNaN{
//                        let screenSize: CGRect = self.superView.bounds
//                        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * CGFloat(a), height: screenSize.height))
//                        myView.backgroundColor = UIColor.green
//                        self.superView.addSubview(myView)
//                    }
//                })
                superView.isHidden = true
                votesDisapper()
                copBtn.isHidden = true
                dropBtn.isHidden = true
            }
        }
    }
    
    
    func getAllVotes(){
        if let feed = feed{
            if self.storedData.integer(forKey: "ForVote") == 0{
                Database.database().reference().child("Catalog").child(feed.id).child("Votes").observe(.childAdded, with: { (snapshot) in
                    if snapshot.exists(){
                        self.totalVote = 1 + self.totalVote
                        let value = snapshot.value as? Bool
                        if value! == true{
                            self.totalYesVote = 1 + self.totalYesVote
                            self.likes.text = "\(Int(self.totalYesVote) )"
                        }
                        else{
                            self.totalNoVote = 1 + self.totalNoVote
                            self.disLikes.text = "\(Int(self.totalNoVote))"
                        }
                        DispatchQueue.main.async {
                            let a = self.totalYesVote/self.totalVote
                            let screenSize: CGRect = self.superView.bounds
                            let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * CGFloat(a), height: screenSize.height))
                            myView.backgroundColor = UIColor.green
                            self.superView.addSubview(myView)
                            
                        }
                    }
                }) { (error) in
                    Toast.init(text: "\(error.localizedDescription)").show()
                }
            }
            else{
                Database.database().reference().child("Catalog").child(feed.id).child("Votes").observe(.childAdded, with: { (snapshot) in
                    if snapshot.exists(){
                        self.totalVote = 1 + self.totalVote
                        let value = snapshot.value as? Bool
                        if value! == true{
                            self.totalYesVote = 1 + self.totalYesVote
                            self.likes.text = "\(Int(self.totalYesVote) )"
                        }
                        else{
                            self.totalNoVote = 1 + self.totalNoVote
                            self.disLikes.text = "\(Int(self.totalNoVote))"
                        }
                        DispatchQueue.main.async {
                            let a = self.totalYesVote/self.totalVote
                            let screenSize: CGRect = self.superView.bounds
                            let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * CGFloat(a), height: screenSize.height))
                            myView.backgroundColor = UIColor.green
                            self.superView.addSubview(myView)
                            
                        }
                    }
                }) { (error) in
                    Toast.init(text: "\(error.localizedDescription)").show()
                }
            }
            
        }
    }
    
    
    func updateUIs() {
        if let feed = feed
        {
            descriptionLabel.text = feed.description
            titleLabel.text = feed.name
            priceLabel.text = "\(feed.priceUS) / \(feed.priceEU)"
            
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EmbedSegue") {
            if let feed = feed
            {
                let embed = segue.destination as! WalkthroughImageController
                embed.feed = feed
            }
        }
    }
    
    
    
    //    func removeSpecialCharsFromString(str: String) -> String {
    //        let chars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_®/".characters)
    //        return String(str.characters.filter { chars.contains($0) })
    //    }
    
    
    @IBAction func btn_buy(_ sender: UIButton) {
        let nameRemoveAt = feed!.name.replacingOccurrences(of: "®", with: " ")
        let nameRemoveC = nameRemoveAt.replacingOccurrences(of: "©", with: " ")
        let nameRemoveSlash = nameRemoveC.replacingOccurrences(of: "/", with: " ")
        let nameRemoveDoubleSpace = nameRemoveSlash.replacingOccurrences(of: "  ", with: " ")
        let name = nameRemoveDoubleSpace.replacingOccurrences(of: " ", with: "-")
        
        let urlInString = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=TheSupre-TheSupre-PRD-9134e8f72-e3436f81&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=\(name)"
        print(urlInString)
        let url = URL(string: urlInString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil{
                return
            }
            do{
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                if responseString != nil{
                    let json = JSON(data!)
                    let findItemsByKeywordsResponse = json["findItemsByKeywordsResponse"]
                    for item in findItemsByKeywordsResponse{
                        let itemSearchURL = item.1["itemSearchURL"][0].string ?? "http://"
                        
                        let searchResult = item.1["searchResult"][0]
                        
                        let getItems = searchResult["item"][0]
                        
                        let itemId = getItems["itemId"][0].string ?? ""
                        let appURL = NSURL(string: "ebay://launch?itm=\(itemId)")!
                        let webURL = NSURL(string: itemSearchURL)!
                        
                        let application = UIApplication.shared
                        
                        if application.canOpenURL(appURL as URL) {
                            application.open(appURL as URL)
                        } else {
                            // if eBay app is not installed, open URL inside Safari
                            application.open(webURL as URL)
                        }
                        
                        
                        //                        if let url = URL(string: itemSearchURL!) {
                        //                            if #available(iOS 10, *) {
                        //                                UIApplication.shared.open(url, options: [:],completionHandler: { (success) in
                        //                                })
                        //                            } else {
                        //                                let success = UIApplication.shared.openURL(url)
                        //                            }
                        //                        }
                        //                        print(itemSearchURL!)
                    }
                    DispatchQueue.main.async {
                    }
                }
                else{
                    Toast.init(text: "There are some issue").show()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func btn_yes(_ sender: UIButton) {
        
        if Auth.auth().currentUser != nil
        {
            if let feed = feed{
                if self.storedData.integer(forKey: "ForVote") == 0{
                    Database.database().reference().child("Catalog").child(feed.id).updateChildValues(["YesVotes":self.countYesVotes + 1])
                    animateDropBtn()
                    sender.isEnabled = false
                }
                else{
                    Database.database().reference().child("Catalog").child(feed.id).updateChildValues(["YesVotes":self.countYesVotes + 1])
                    animateDropBtn()
                    sender.isEnabled = false
                }
                
            }
        }
        else
        {
            self.showAlert(_message: "You can't cop or drop the item without authentication. Kindly login first")
        }
        
    }
    
    
    func animateCopBtn()
    {
        UIView.animate(withDuration: 0.2) {
            self.copBtn.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.votesAppear()
                self.copBtn.isHidden = true
            })
        }
    }
    
    func animateDropBtn()
    {
        UIView.animate(withDuration: 0.2) {
            self.dropBtn.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.votesAppear()
                self.dropBtn.isHidden = true
            })
        }
    }
    
    
    
    @IBAction func btn_no(_ sender: UIButton) {
        if let feed = feed{
            if self.storedData.integer(forKey: "ForVote") == 0{
                Database.database().reference().child("Catalog").child(feed.id).updateChildValues(["NoVotes":self.countNoVotes + 1])
                animateCopBtn()
                sender.isEnabled = false
            }
            else{
                Database.database().reference().child("Catalog").child(feed.id).updateChildValues(["NoVotes":self.countNoVotes + 1])
                animateCopBtn()
                sender.isEnabled = false
            }
        }
        
    }
    
    

    
}


