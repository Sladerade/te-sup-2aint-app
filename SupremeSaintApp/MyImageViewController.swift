//
//  MyImageViewController.swift
//  SupremeSaintApp
//
//  Created by Sanan on 2/2/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class MyImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var img:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = img
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_back(_ sender: UIButton) {
        ModalService.dismiss(self, exitTo: .right, duration: 0.5)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
