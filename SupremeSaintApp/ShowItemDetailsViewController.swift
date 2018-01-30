//
//  ShowItemDetailsViewController.swift
//  SupremeSaintApp
//
//  Created by Sanan on 1/30/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toaster
import Firebase

class ShowItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var totalPercentage: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var id = ""
    var itemId = ""
    var titleForItem = ""
    var imageUrl = ""
    
    var totalVote:Float = 0
    var totalYesVote:Float = 0
    
    var databaseRef:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        id = databaseRef.childByAutoId().key;
        updateUIs()
        
    }
    
    func updateUIs() {
        if titleForItem != ""{
            titleLabel.text = titleForItem
            imageView.downloadImage(from: imageUrl)
            getAllVotes()
        }
        
    }
    @IBAction func btn_buy(_ sender: UIButton) {
        let urlInString = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=TheSupre-TheSupre-PRD-9134e8f72-e3436f81&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=arabic-facemask\(titleLabel.text!.replacingOccurrences(of: " ", with: "-")).json"
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
                    Toast.init(text: "There are some issue").show()
                }
            }
        }
        task.resume()
    }
    
    func getAllVotes(){
        databaseRef.child("Catalog").child(itemId).child("votes").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists(){
                self.totalVote = 1 + self.totalVote
                let value = snapshot.value as? Bool
                if value! == true{
                    self.totalYesVote = 1 + self.totalYesVote
                }
                DispatchQueue.main.async {
                    let a = self.totalYesVote/self.totalVote
                    self.totalPercentage.text = "\(Int(a*100))%"
                }
            }
        }) { (error) in
            Toast.init(text: "\(error.localizedDescription)").show()
        }
    }
    
    
    @IBAction func btn_yes(_ sender: UIButton) {
        
        databaseRef.child("Catalog").child(itemId).child("votes").updateChildValues([id : true])
    }
    @IBAction func btn_no(_ sender: UIButton) {
        databaseRef.child("Catalog").child(itemId).child("votes").updateChildValues([id : false])
    }
    @IBAction func btn_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

