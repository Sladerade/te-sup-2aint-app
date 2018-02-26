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
  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var copBtn: UIButton!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copdopBtnStckView: UIStackView!
    @IBOutlet weak var copdopLblStckView: UIStackView!
    
    let currentUser = Auth.auth().currentUser?.uid
    
    
    
    var totalYesVote:Double = 0
    var totalNoVote:Double = 0
    var storedData = UserDefaults.standard
    
    
    
    
    var id:String!
    var imageNumber = 0
    var countYesVotes = 0
    var countNoVotes = 0
    var totalVote:Double = 0
    var imagesArray = [String]()
    
    struct ViewModel {
        var selectedFeed:Feed
    }
    
    
    var feed:ViewModel?
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
        
        
        
        copdopBtnStckView.isHidden = true
        copdopLblStckView.isHidden = true
        
        let logoIV = UIImageView()
        logoIV.contentMode = .scaleAspectFit
        logoIV.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = logoIV
        
        
        id = Database.database().reference().childByAutoId().key
        updateUIs()
        //getAllVotes()
        getVotes()
        
        
    
    }
   
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let feed = feed {
            Database.database().reference().child("Catalog").child(feed.selectedFeed.id).child("VotedBy").observeSingleEvent(of: .value, with: { (snapshot) in
                
                    if let votesBy = snapshot.value as? Dictionary<String,Any>
                    {
                        if !votesBy.keys.contains(self.currentUser!)
                        {
                            UIView.animate(withDuration: 0.1, animations: {
                                self.copdopBtnStckView.alpha = 1.0
                            }, completion: { (finished) in
                                if finished
                                {
                                    self.copdopBtnStckView.isHidden = false
                                }
                            })
                        }
                    }
            })
            
        }
        
    }
    
    
    
    
    
    func getVotes(){
        if let feed = feed {
            if self.storedData.integer(forKey:"ForVote") == 0 || self.storedData.integer(forKey:"ForVote") == 1{
                
                
                copdopLblStckView.isHidden = false
                
                //Entry in catalog
                Database.database().reference().child("Catalog").child(feed.selectedFeed.id).observe(.value, with: { (snapshot) in
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
                
            }
        }
    }
    
    
    
    
    func updateUIs() {
        if let feed = feed
        {
            descriptionLabel.text = feed.selectedFeed.description
            titleLabel.text = feed.selectedFeed.name
            priceLabel.text = "\(feed.selectedFeed.priceUS) / \(feed.selectedFeed.priceEU)"
            
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EmbedSegue") {
            if let feed = feed
            {
                let embed = segue.destination as! WalkthroughImageController
                embed.feed = feed.selectedFeed
            }
        }
    }
    
    
    
    //    func removeSpecialCharsFromString(str: String) -> String {
    //        let chars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_®/".characters)
    //        return String(str.characters.filter { chars.contains($0) })
    //    }
    
    
    @IBAction func btn_buy(_ sender: UIButton) {
        let nameRemoveAt = feed!.selectedFeed.name.replacingOccurrences(of: "®", with: " ")
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
                if self.storedData.integer(forKey: "ForVote") == 0 || self.storedData.integer(forKey: "ForVote") == 1{
                    Database.database().reference().child("Catalog").child(feed.selectedFeed.id).updateChildValues(["YesVotes":self.countYesVotes + 1])
                    
                    Database.database().reference().child("Catalog").child(feed.selectedFeed.id).child("VotedBy").updateChildValues([currentUser! : true])
                    
                    animatecopDropBtn()
                    sender.isEnabled = false
                }
                else{
                    Database.database().reference().child("Catalog").child(feed.selectedFeed.id).updateChildValues(["YesVotes":self.countYesVotes + 1])
                    
                    Database.database().reference().child("Catalog").child(feed.selectedFeed.id).child("VotedBy").updateChildValues([currentUser! : true])
                    
                    animatecopDropBtn()
                    sender.isEnabled = false
                }
                
            }
        }
        else
        {
            self.showAlert(_message: "You can't cop or drop the item without authentication. Kindly login first")
        }
        
    }
    
    
    func animatecopDropBtn()
    {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.copdopBtnStckView.alpha = 0
            
        }) { (finished) in
            
            if finished
            {
                self.copdopBtnStckView.isHidden = true
            }
        }
    }
    
    
    
    @IBAction func btn_no(_ sender: UIButton) {
        if let feed = feed{
            if self.storedData.integer(forKey: "ForVote") == 0 || self.storedData.integer(forKey: "ForVote") == 1 {
                Database.database().reference().child("Catalog").child(feed.selectedFeed.id).updateChildValues(["NoVotes":self.countNoVotes + 1])
                
                Database.database().reference().child("Catalog").child(feed.selectedFeed.id).child("VotedBy").updateChildValues([currentUser! : true])
                
                
                animatecopDropBtn()
                sender.isEnabled = false
            }
            else{
                Database.database().reference().child("Catalog").child(feed.selectedFeed.id).updateChildValues(["NoVotes":self.countNoVotes + 1])
                
                Database.database().reference().child("Catalog").child(feed.selectedFeed.id).child("VotedBy").updateChildValues([currentUser! : true])
                animatecopDropBtn()
                sender.isEnabled = false
            }
        }
        
    }
    
    
}



