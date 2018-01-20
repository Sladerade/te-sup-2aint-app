//
//  FeedCollectionVCell.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/17/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class FeedCollectionVCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
 
    var feed:Feed?{
        get{
            return _feed
        }
        set(v){
            _feed = v
            if let photoUrl = feed?.photoUrl
            {
               _ = RemoteFileService.instance.loadFile(url: photoUrl, callback: { (url, data) in
                    
                    if data != nil && url.lowercased() == self._feed?.photoUrl.lowercased()
                    {
                        self.imageView.image = UIImage(data: data!)
                    }
                    
                })
            }
        }
    }
    
    private var _feed:Feed? = nil
    
}


