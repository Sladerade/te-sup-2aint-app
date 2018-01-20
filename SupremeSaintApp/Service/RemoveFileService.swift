//
//  RemoveFileService.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/18/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import Foundation

public class RemoteFileService{
    static let instance = RemoteFileService()
    
    private var pendingLoads = [String]()
    private let urlVsDataDict = Dictionary<String,Data>()
    
    private var loadCallbackDict = Dictionary<String,[((String,Data?)->())?]>()
    
    
    func loadFile(url:String,callback:((String,Data?)->())?)->Bool
    {
        let urlCased = url.lowercased()
        if let data = urlVsDataDict[urlCased]
        {
            callback?(url,data)
            return true
        }
        
        if pendingLoads.contains(urlCased)
        {
            addCallbackToLoadDict(url: urlCased, callback: callback)
            return false
        }
        
        pendingLoads.append(urlCased)
        addCallbackToLoadDict(url: urlCased, callback: callback)
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response,error) in

            DispatchQueue.main.async {
                self.onUrlDataLoaded(url: url, data: data)
            }
        }
        task.resume()
        return false
    }
    
    private func onUrlDataLoaded(url:String,data:Data?)
    {
        if let index = pendingLoads.index(where: {$0 == url.lowercased()})
        {
            pendingLoads.remove(at: index)
        }
        
        if let callbacks = loadCallbackDict[url.lowercased()]
        {
            callbacks.forEach({ (callback) in
                callback?(url, data)
            })
        }
    }
    
    private func addCallbackToLoadDict(url:String,callback:((String,Data?)->())?)
    {
        if var v = loadCallbackDict[url.lowercased()]
        {
            v.append(callback)
            loadCallbackDict.updateValue(v, forKey: url.lowercased())
        }
        else
        {
            loadCallbackDict.updateValue([callback], forKey: url.lowercased())
        }
    }
    
}
