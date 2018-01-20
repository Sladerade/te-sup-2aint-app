//
//  FirebaseService.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService{
    static let instance = FirebaseService()
    
    func loadFeeds(callback:(([Feed])->())?){
        var feeds = [Feed]()
        Database.database().reference().child("Catalog").observeSingleEvent(of: .value) { (datashot) in
            for child in datashot.children
            {
                if let child = child as? DataSnapshot ,let feed = Feed.fromDict(id: child.key,dict: child.value as! Dictionary<String,Any?>)
                {
                    
                    feeds.append(feed)
                }
                
            }
            callback?(feeds)
        }
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
    
}


