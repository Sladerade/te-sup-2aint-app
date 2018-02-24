import UIKit

class TabBarViewController: ViewControllerWithLogo {
    
    private static let SELECTED_BG_COLOR = UIColor.red
    
    // TabBar Connections
    @IBOutlet weak var shopIcon: UIImageView!
    @IBOutlet weak var shopBg: UIImageView!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var homeBg: UIImageView!
    
    @IBOutlet weak var newsIcon: UIImageView!
    @IBOutlet weak var newsBg: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    private var selectedTabBarItem:TabBarItem!
    
    lazy var homeVC:HomeVC = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.tabBarViewController = self
        return vc
    }()
    
    lazy var shopVC:ShopVC = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShopVC") as! ShopVC
        vc.tabBarViewController = self
        return vc
    }()
    
    lazy var newsVC:NewsVC = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
        vc.tabBarViewController = self
        
        return vc
    }()
    
    private var homeTabBarItem:TabBarItem!
    private var shopTabBarItem:TabBarItem!
    private var newsTabBarItem:TabBarItem!
    
    private var selectedItem:TabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Navigation Bar Image
//        let image = #imageLiteral(resourceName: "SaintNavBar")
//        let imageView = UIImageView(image: image)
//        
//        self.navigationItem.titleView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFill
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Tab Bar Image Connections
        homeIcon.image = homeIcon.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        homeBg.image = homeBg.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        homeTabBarItem = TabBarItem(identifier:.home,icon: homeIcon, bg: homeBg, controller: homeVC, title: "home")
        
        shopIcon.image = shopIcon.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        shopBg.image = shopBg.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        shopTabBarItem = TabBarItem(identifier:.dropList,icon: shopIcon, bg: shopBg, controller: shopVC, title: "droplist")
        
        newsIcon.image = newsIcon.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        newsBg.image = newsBg.image!
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        newsTabBarItem = TabBarItem(identifier:.news,icon: newsIcon, bg: newsBg, controller: newsVC, title: "news")
        
        // Tab Bar Action on Click
        homeBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonClicked)))
        shopBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonClicked)))
        newsBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonClicked)))
        
        deactivateTabBarItem(item: shopTabBarItem)
        deactivateTabBarItem(item: newsTabBarItem)
        activeTabBarItem(item: homeTabBarItem)
        selectedItem = homeTabBarItem

    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedItem.controller.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedItem.controller.viewDidAppear(animated)
//        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    @objc private func onButtonClicked(gesture:UIGestureRecognizer)
    {
        if(gesture.view == homeBg)
        {
            setCurrentTabBarItem(item: homeTabBarItem)
        }
        else if(gesture.view == shopBg)
        {
            setCurrentTabBarItem(item: shopTabBarItem)
        }
        else if(gesture.view == newsBg)
        {
            setCurrentTabBarItem(item: newsTabBarItem)
        }
    }
    
    private func getTabBarItemForIdentifier(identifier:TabBarIdentifier)->TabBarItem
    {
        switch identifier {
        case .home:
            return homeTabBarItem
            
        case .news:
            return newsTabBarItem
            
        case .dropList:
            return shopTabBarItem
        
        }
    }
    
    
    private func setCurrentTabBarItem(item:TabBarItem)
    {
        if(selectedItem != nil)
        {
            deactivateTabBarItem(item: selectedItem)
        }
        
        activeTabBarItem(item: item)
        selectedItem = item
    }
    
    private  func activeTabBarItem(item:TabBarItem)
    {
        item.icon.tintColor = UIColor.white
        item.bg.tintColor = TabBarViewController.SELECTED_BG_COLOR
        self.containerView.addSubview(item.controller.view)
        item.controller.view.frame = CGRect(x:0,y:0,width:containerView.frame.width,height:containerView.frame.height)
        
        titleLabel.text = item.title
        item.controller.didMove(toParentViewController: self)
        
    }
    
     func selectTabBar(with identifier:TabBarIdentifier)
    {
        setCurrentTabBarItem(item: getTabBarItemForIdentifier(identifier: identifier))
    }
    
    func selectTabBar(with tabBarItem:TabBarItem)  {
        setCurrentTabBarItem(item: tabBarItem)
    }
    
    private func deactivateTabBarItem(item:TabBarItem)
    {
        item.icon.tintColor = TabBarViewController.SELECTED_BG_COLOR
        item.bg.tintColor = UIColor.clear
        
        if let _ = item.controller.view.superview
        {
            item.controller.view.removeFromSuperview()
            item.controller.didMove(toParentViewController: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedGroupPageController"
        {
            let vc = segue.destination as! FeedViewController
            vc.feed = sender as? FeedViewController.ViewModel
        }
    }
    
    
    public struct TabBarItem{
        var identifier:TabBarIdentifier
        var icon:UIImageView
        var bg:UIImageView
        var controller:UIViewController
        var title:String
    }
    
    public enum TabBarIdentifier{
        case home
        case dropList
        case news
    }
    
}

 protocol TabBarPage
{
    var tabBarViewController: TabBarViewController!{get set}
}

class TabBarViewControllerPage : UIViewController,TabBarPage {
    var tabBarViewController: TabBarViewController!

}

