//
//  Alertable.swift
//  RideShare
//
//  Created by Faizan on 06/01/2018.
//  Copyright © 2018 Faizan. All rights reserved.
//

import UIKit

protocol Alertable
{
    
}



extension Alertable where Self : UIViewController
{
    func showAlert(_message: String)
    {
        let alertController = UIAlertController(title: "Error", message: _message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
}
