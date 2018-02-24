

import UIKit
import TwitterKit

class NewsVC: TWTRTimelineViewController,TabBarPage, TWTRTweetViewDelegate {

    var tabBarViewController: TabBarViewController!
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "thesupremesaint", apiClient: client)
        self.tweetViewDelegate = self
    }
    
    func tweetView(_ tweetView: TWTRTweetView, didTap image: UIImage, with imageURL: URL) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TweetImageVc") as! TweetImageVc
        vc.img = image
        present(vc, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
}
