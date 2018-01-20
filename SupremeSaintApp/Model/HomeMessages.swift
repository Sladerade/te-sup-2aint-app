//
//  HomeMessages.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/19/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

struct HomeMessages {
    var bannerMessage:String
    var throwBackMessage:String
    var droplistMessage:String
    
    static func fromDict(dict:Dictionary<String,Any?>)->HomeMessages?
    {
        if let bannerMessage = dict["bannerMessage"] as? String, let throwbackMessage = dict["throwbackMessage"] as? String,let dropListMessage = dict["droplistMessage"] as? String
        {
            return HomeMessages(bannerMessage: bannerMessage, throwBackMessage: throwbackMessage, droplistMessage: dropListMessage)
        }
        return nil
    }
}
