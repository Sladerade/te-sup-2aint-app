//
//  SlideImageController.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/16/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class SlideImageController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var slide:Slide?
    var touchEventListener:TouchEventLister?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let slide = slide
        {
            imageView.downloadImage(from: slide.imgUrl)
//            linkBtn.setTitle(slide.link, for: .normal)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTabbed)))
    }
    
    @objc func onTabbed()
    {
        if slide == nil
        {
            return
        }
        UIApplication.shared.open(URL.init(string: slide!.link)!, options: [:], completionHandler: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchEventListener?.onTouchBegan(in: self, touches: touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEventListener?.onTouchEnd(in: self, touches: touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEventListener?.onTouchEnd(in: self, touches: touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchEventListener?.touchesMoved(in: self, touches, with: event)
    }
    


}

