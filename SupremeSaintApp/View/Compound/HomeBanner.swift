//
//  HomeBanner.swift
//  SupremeSaintApp
//
//  Created by Darsan Pakeerathan on 1/16/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class HomeBanner: UIView {

    var viewModel:ViewModel?
    {
        didSet{
            messageButton.setTitle(viewModel?.message, for: .normal)
        }
    }
    
    private lazy var messageButton:UIButton = {
       return self.viewWithTag(1) as! UIButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public class ViewModel{
      var  message:String?
        var onClick:((_ place:Place)->())?
        
        init(message:String?,onClick:((_ place:Place)->())?) {
            self.message = message
            self.onClick = onClick
        }
        
    }
    @IBAction func onClickClose(_ sender: Any) {
        viewModel?.onClick?(.close)
    }
    
    @IBAction func onClickItem(_ sender: Any) {
        viewModel?.onClick?(.item)
    }
    
    
    public enum Place{
        case close
        case item
    }
    
}

