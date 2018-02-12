//
//  FirebaseService.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = Database.database().reference()


class FirebaseService{
    static let instance = FirebaseService()
    
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_USERS : DatabaseReference
    {
        return _REF_USERS
    }
    
    func loadFeeds(callback:(([Feed])->())?){
        var feeds = [Feed]()
        var throwback:Bool!
        var droplist:Bool!
        Database.database().reference().child("Catalog").observe(.childAdded, with: { (datashot) in
            if datashot.exists(){
                
                let value = datashot.value as? NSDictionary
                if value?["Droplist"] as? String ?? "" == "True"{
                    droplist = true
                }
                else{
                    droplist = false
                }
                let photos = value?["Photos"] as? NSArray
                let image = photos![1] as? String ?? "http://"
                let name = value?["ProductName"] as? String ?? ""
                let priceUS = value?["Price-US"] as? String ?? ""
                let priceEU = value?["Price-EU"] as? String ?? ""
                let description = value?["Description"] as? String ?? ""
                let season = value?["Season"] as? String ?? ""
                
                if value?["Throwback"] as? String ?? "" == "True"{
                    throwback = true
                }
                else{
                    throwback = false
                }
                let week = value?["Week"] as? Int ?? 0
                
                let model = Feed(id: datashot.key, description: description, droplist: droplist, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                
                feeds.append(model)
                
                callback?(feeds)
            }
        }) { (error) in
            
        }
//        Database.database().reference().child("Catalog").observeSingleEvent(of: .value) { (datashot) in
//            for child in datashot.children
//            {
//
//                if let child = child as? DataSnapshot ,let feed = Feed.fromDict(id: child.key,dict: child.value as! Dictionary<String,Any?>){
//                    print("hello there \(datashot.children)")
//                    feeds.append(feed)
//                }
//
//            }
//            callback?(feeds)
//        }
    }
    
    func loadHomeMessage(callback:((HomeMessages?)->())?) {
        Database.database().reference().child("Homepage").child("HomeMessages").observeSingleEvent(of: .value) { (datashot) in
                callback?(HomeMessages.fromDict(dict: datashot.value as! Dictionary<String,Any?>))
            
            
        }
    }
    
    func loadVersion(callback:((String?)->())?)
    {
        Database.database().reference().child("Homepage").child("Version").observeSingleEvent(of: .value) { (snapshot) in
             callback?(snapshot.value as? String)
        }
    }
    
    func loadSlides(callback:(([Slide])->())?) {
        Database.database().reference().child("Homepage").child("NewsBanner").observeSingleEvent(of:.value) { (datasgot) in
            var slides = [Slide]()
            for child in datasgot.children
            {
                if let child = child as? DataSnapshot,let slide = Slide.fromDict(dict: child.value as! Dictionary<String,Any?>)
                {
                    slides.append(slide)
                }
            }
            callback?(slides)
        }
    }
    
    func createFirebaseUser(uid: String, userData : Dictionary<String, Any>)
    {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}


