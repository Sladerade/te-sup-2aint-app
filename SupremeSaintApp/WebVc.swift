//
//  WebVc.swift
//  SupremeSaintApp
//
//  Created by Faizan on 12/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit
import ProgressHUD

class WebVc: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var webUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        webView.delegate = self
        
        if webUrl != nil
        {
            let url = URL(string: webUrl)
            webView.loadRequest(URLRequest(url: url!))
        }
        
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        ProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        ProgressHUD.dismiss()
    }
    
    
    

    

}
