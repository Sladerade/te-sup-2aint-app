//
//  SecondSlidePageVC.swift
//  SupremeSaintApp
//
//  Created by Faizan on 24/02/2018.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class SecondSlidePageVC: UIPageViewControllerWithOverlayIndicator, TouchEventLister{
    
    
    private let TIME_INTERVARL_BETWEEN_MOVE = 10
    
    public var slides:[Slide] = []
    {
        didSet{
            if isViewLoaded
            {
                dataSource = nil
                createOrRefreshSlideImageControllers()
                dataSource = self
                if slideImageControllers.count > 0
                {
                    setViewControllers([slideImageControllers.first!], direction: .forward, animated: true, completion: nil)
                    stopTimerOfSliding()
                    startTimerOfSliding()
                }
                
            }
        }
    }
    
    
    
    fileprivate var slideImageControllers = [SecondSlideImageVC]()
    fileprivate var currentIndex:Int? {
        if let controller = viewControllers?.first as? SecondSlideImageVC
        {
            return slideImageControllers.index(of: controller)
        }
        return nil
    }
    
    private var timer:Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = self
        createOrRefreshSlideImageControllers()
        modalPresentationStyle = .fullScreen
        if slideImageControllers.count > 0
        {
            setViewControllers([slideImageControllers.first!], direction: .forward, animated: true, completion: nil)
            
            stopTimerOfSliding()
            startTimerOfSliding()
        }
        
    }
    
    private func createOrRefreshSlideImageControllers()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        slideImageControllers.removeAll()
        for slide in slides
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "SecondSlideImageVC") as! SecondSlideImageVC
            vc.slide = slide
            vc.touchEventListener = self
            let _ = vc.view
            
            slideImageControllers.append(vc)
        }
        
    }
    
    func onTouchBegan(in controller: UIViewController, touches: Set<UITouch>, with event: UIEvent?) {
        stopTimerOfSliding()
        startTimerOfSliding()
    }
    
    func onTouchEnd(in controller: UIViewController, touches: Set<UITouch>, with event: UIEvent?) {
        stopTimerOfSliding()
        startTimerOfSliding()
        print("update timer")
    }
    
    func touchesMoved(in controller: UIViewController, _ touches: Set<UITouch>, with event: UIEvent?) {
        stopTimerOfSliding()
        startTimerOfSliding()
        print("update timer")
    }
    
    
    private func startTimerOfSliding()
    {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(TIME_INTERVARL_BETWEEN_MOVE), repeats: true, block: { (timer) in
            self.autoSlideImage()
        })
        
    }
    
    private func stopTimerOfSliding()
    {
        timer?.invalidate()
        timer = nil
        
    }
    
    private func autoSlideImage()
    {
        if currentIndex! < slideImageControllers.count - 1
        {
            setViewControllers([slideImageControllers[currentIndex!+1]], direction: .forward, animated: true, completion: nil)
        }
        else
        {
            setViewControllers([slideImageControllers[0]], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
}


extension SecondSlidePageVC:UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = slideImageControllers.index { (controller) -> Bool in
            viewController == controller
            }!
        
        if index == 0
        {
            return nil
        }
        return slideImageControllers[index-1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = slideImageControllers.index {
            viewController == $0
            }!
        if index == slideImageControllers.count - 1
        {
            return nil
        }
        return slideImageControllers[index+1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return slideImageControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
        
    }
    
    //    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    //        guard completed else {
    //            return
    //        }
    //        currentIndex = slideImageControllers.index(where: {
    //            pageViewController.childViewControllers.first == $0
    //        })!
    //    }
    
}

