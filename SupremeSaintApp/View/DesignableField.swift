//
//  DesignableField.swift
//  SupremeSaintApp
//
//  Created by Faizan on 11/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class DesignableField: UITextField {

   
    override func awakeFromNib() {
        setPlaceHolderColor()
    }
    
    
    func setPlaceHolderColor()
    {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.9994935393, green: 0.01752460562, blue: 0.00630321214, alpha: 1)])
    }
    
    let padding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
