//
//  Slide.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//


struct Slide {
    var link:String
    var imgUrl:String
    
    static func fromDict(dict:Dictionary<String,Any?>)->Slide?
    {
        if let link = dict["Link"] as? String,let pictureUrl = dict["Picture"] as? String
        {
           return Slide(link: link, imgUrl: pictureUrl)
        }
        return nil
    }
}
