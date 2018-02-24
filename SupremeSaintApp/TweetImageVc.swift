//
//  TweetImageVc.swift
//  SupremeSaintApp
//
//  Created by Faizan on 23/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class TweetImageVc: UIViewController {

    @IBOutlet weak var outletImg: UIImageView!
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outletImg.image = img
    }

    @IBAction func btn_back(_ sender: UIButton) {
        
        ModalService.dismiss(self, exitTo: .right, duration: 0.5)
        
    }
    
    
    
    
    class ModalService {
        
        enum presentationDirection {
            case left
            case right
            case top
            case bottom
        }
        
        class func present(_ modalViewController: UIViewController,
                           presenter fromViewController: UIViewController,
                           enterFrom direction: presentationDirection = .right,
                           duration: CFTimeInterval = 0.3) {
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionMoveIn
            transition.subtype = ModalService.transitionSubtype(for: direction)
            let containerView: UIView? = fromViewController.view.window
            containerView?.layer.add(transition, forKey: nil)
            fromViewController.present(modalViewController, animated: false)
        }
        
        class func dismiss(_ modalViewController: UIViewController,
                           exitTo direction: presentationDirection = .right,
                           duration: CFTimeInterval = 0.3) {
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype = ModalService.transitionSubtype(for: direction, forExit: true)
            if let layer = modalViewController.view?.window?.layer {
                layer.add(transition, forKey: nil)
            }
            modalViewController.dismiss(animated: false)
        }
        
        private class func transitionSubtype(for direction: presentationDirection, forExit: Bool = false) -> String {
            if (forExit == false) {
                switch direction {
                case .left:
                    return kCATransitionFromLeft
                case .right:
                    return kCATransitionFromRight
                case .top:
                    return kCATransitionFromBottom
                case .bottom:
                    return kCATransitionFromTop
                }
            } else {
                switch direction {
                case .left:
                    return kCATransitionFromRight
                case .right:
                    return kCATransitionFromLeft
                case .top:
                    return kCATransitionFromTop
                case .bottom:
                    return kCATransitionFromBottom
                }
            }
        }
    }

}
