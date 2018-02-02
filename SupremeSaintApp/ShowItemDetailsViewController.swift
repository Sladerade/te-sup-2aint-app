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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var id = ""
    var itemId = ""
    var titleForItem = ""
    var imageUrl = ""
    var price = ""
    var value = 0
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    @IBOutlet weak var superView: UIView!
    var totalVote:Double = 0
    var totalYesVote:Double = 0
    var totalNoVote:Double = 0
    
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
            priceLabel.text = price
            imageView.downloadImage(from: imageUrl)
            getAllVotes(value: value)
        }
        
    }
    @IBAction func btn_buy(_ sender: UIButton) {
        let urlInString = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=TheSupre-TheSupre-PRD-9134e8f72-e3436f81&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=Supreme-\(titleLabel.text!.replacingOccurrences(of: " ", with: "-"))"
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
    
    func getAllVotes(value:Int){
        if value == 0{
            databaseRef.child("Catalog").child(itemId).child("votes").observe(.childAdded, with: { (snapshot) in
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
        else if value == 1{
            databaseRef.child("Old Catalog").child(itemId).child("votes").observe(.childAdded, with: { (snapshot) in
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
    
    
    @IBAction func btn_yes(_ sender: UIButton) {
        if value == 0{
            databaseRef.child("Catalog").child(itemId).child("votes").updateChildValues([id : true])
        }
        else if value == 1{
            databaseRef.child("Old Catalog").child(itemId).child("votes").updateChildValues([id : true])
        }
        
    }
    @IBAction func btn_no(_ sender: UIButton) {
        if value == 0{
            databaseRef.child("Catalog").child(itemId).child("votes").updateChildValues([id : false])
        }
        else if value == 1{
            databaseRef.child("Old Catalog").child(itemId).child("votes").updateChildValues([id : false])
        }
        
    }
    @IBAction func btn_back(_ sender: UIButton) {
        ModalService.dismiss(self, exitTo: .right, duration: 0.5)
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
//        present(vc, animated: false, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    class ModalService {
        
        enum presentationDirection {
            case left
            case right
            case top
            case bottom
        }
        
        class func present(_ modalViewController: UIViewController,
                           presenter fromViewController: UIViewController,
                           enterFrom direction: presentationDirection = .right,
                           duration: CFTimeInterval = 0.3) {
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn
            transition.subtype = ModalService.transitionSubtype(for: direction)
            let containerView: UIView? = fromViewController.view.window
            containerView?.layer.add(transition, forKey: nil)
            fromViewController.present(modalViewController, animated: false)
        }
        
        class func dismiss(_ modalViewController: UIViewController,
                           exitTo direction: presentationDirection = .right,
                           duration: CFTimeInterval = 0.3) {
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = ModalService.transitionSubtype(for: direction, forExit: true)
            if let layer = modalViewController.view?.window?.layer {
                layer.add(transition, forKey: nil)
            }
            modalViewController.dismiss(animated: false)
        }
        
        private class func transitionSubtype(for direction: presentationDirection, forExit: Bool = false) -> String {
            if (forExit == false) {
                switch direction {
                case .left:
                    return kCATransitionFromLeft
                case .right:
                    return kCATransitionFromRight
                case .top:
                    return kCATransitionFromBottom
                case .bottom:
                    return kCATransitionFromTop
                }
            } else {
                switch direction {
                case .left:
                    return kCATransitionFromRight
                case .right:
                    return kCATransitionFromLeft
                case .top:
                    return kCATransitionFromTop
                case .bottom:
                    return kCATransitionFromBottom
                }
            }
        }
    }
}

