//
//  Feed.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import Foundation
import UIKit

struct Feed {
    var id:String
    var description:String
    var droplist:Bool
    var name:String
    var photoUrl:String
    var priceEU:String
    var priceUS:String
    var season:String
    var throwBack:Bool
    var week:Int
    
    
    static func fromDict(id:String,dict:NSDictionary)->Feed?
    {
        let photos = dict["Photos"] as? NSArray
        if let description = dict["Description"] as? String ,let name = dict["ProductName"] as? String ,let dropList = dict["Droplist"] as? String,let photoUrl = photos![1] as? String,let priceEU = dict["Price-EU"] as? String,let priceUS = dict["Price-US"] as? String,let season = dict["Season"] as? String,let throwBack = dict["Throwback"] as? String ,let week = dict["Week"] as? Int
        {
            return Feed(id: id, description: description, droplist: dropList == "True", name: name, photoUrl: photoUrl, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwBack == "True", week: week)
        }
        
      return nil
    }
    
}
