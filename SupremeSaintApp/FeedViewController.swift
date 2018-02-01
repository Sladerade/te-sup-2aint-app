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

class FeedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    @IBOutlet weak var superView: UIView!
    var totalVote:Double = 0
    var totalYesVote:Double = 0
    var totalNoVote:Double = 0
    
    var id:String!
    
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
        getAllVotes()
        
    }
    
    
    func getAllVotes(){
        if let feed = feed{
            Database.database().reference().child("Catalog").child(feed.id).child("votes").observe(.childAdded, with: { (snapshot) in
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
    
    
    func updateUIs() {
        if let feed = feed
        {
            titleLabel.text = feed.name
            priceLabel.text = "\(feed.priceUS) / \(feed.priceEU)"
            imageView.downloadImage(from: feed.photoUrl)
        }
    }
    @IBAction func btn_buy(_ sender: UIButton) {
        let urlInString = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=TheSupre-TheSupre-PRD-9134e8f72-e3436f81&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=arabic-facemask\(feed!.name.replacingOccurrences(of: " ", with: "-")).json"
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
                        let itemSearchURL = item.1["itemSearchURL"][0].string
                        if let url = URL(string: itemSearchURL!) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],completionHandler: { (success) in
                                })
                            } else {
                                let success = UIApplication.shared.openURL(url)
                            }
                        }
                        print(itemSearchURL!)
                    }
                    DispatchQueue.main.async {
                    }
                }
                else{
                    //                    Toast.init(text: "There are some issue").show()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func btn_yes(_ sender: UIButton) {
        if let feed = feed{
            Database.database().reference().child("Catalog").child(feed.id).child("votes").updateChildValues([id! : true])
        }
        
    }
    @IBAction func btn_no(_ sender: UIButton) {
        if let feed = feed{
            Database.database().reference().child("Catalog").child(feed.id).child("votes").updateChildValues([id! : false])
        }
        
    }

}
