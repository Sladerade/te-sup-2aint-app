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

class FeedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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

        updateUIs()

    }
    
    func updateUIs() {
        if let feed = feed
        {
            titleLabel.text = feed.name
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

}
