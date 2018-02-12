//
//  DesignableButton.swift
//  SupremeSaintApp
//
//  Created by Faizan on 11/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class DesignableButton: UIButton {

   
    override func awakeFromNib() {
        setupView()
    }
    
    
    func setupView()
    {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
    }

}
