import UIKit

class HomeVC: TabBarViewControllerPage, UIScrollViewDelegate {
    
    private let DROPLIST_COLOM_COUNT = 4
    private let THROWBACL_COLOM_COUNT = 4
    
    @IBOutlet weak var throwBacksCollectionView: UICollectionView!
    @IBOutlet weak var throwBacksCollectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dropListCollectionView: UICollectionView!
    
    @IBOutlet weak var homeBanner: HomeBanner!
    @IBOutlet weak var bannerTopAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderContainer: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var throwbacksMessageLabel: UILabel!
    @IBOutlet weak var dropListMessageLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    lazy var throwBackDataSource = ThrowBackTableController(parentVC: self)
    lazy var dropListDataSource = DropListCollectionController(parentVC: self)
    
    private var isBannerShowed = false
    private var slidePageViewController:SlidePageViewController? {
        return isViewLoaded ? sliderContainer.subviews[0].next as? SlidePageViewController : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.isHidden = true
        
        throwBacksCollectionView.register(UINib(nibName:"FeedCollectionVCell",bundle:nil), forCellWithReuseIdentifier: "FeedCollectionVCell")
        
        dropListCollectionView.register(UINib(nibName:"FeedCollectionVCell",bundle:nil), forCellWithReuseIdentifier: "FeedCollectionVCell")
        scrollView.delegate = self
        throwBacksCollectionView.dataSource = throwBackDataSource
        throwBacksCollectionView.delegate = throwBackDataSource
        dropListCollectionView.dataSource = dropListDataSource
        dropListCollectionView.delegate = dropListDataSource
        
        //        let cell = throwBacksCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionVCell", for: IndexPath())
        print("thriw Backs Collectuon View Width:\(throwBacksCollectionView.frame.width)")
        
        
        FirebaseService.instance.loadFeeds(callback: {(feeds) in
            print(feeds)
            self.throwBackDataSource.feedList = feeds.filter({ $0.throwBack })
            self.dropListDataSource.feedList = feeds.filter({$0.droplist})
            self.throwBacksCollectionView.reloadData()
            self.dropListCollectionView.reloadData()
            self.refereshThrowBackCollectionSize()
        })
        
        FirebaseService.instance.loadSlides(callback: {
            (slides) in
            self.slidePageViewController?.slides = slides
        })
        
        FirebaseService.instance.loadHomeMessage { (messages) in
            if let messages = messages
            {
                self.showBanner(message: messages.bannerMessage)
                self.dropListMessageLabel.text = messages.droplistMessage
                self.throwbacksMessageLabel.text = messages.throwBackMessage
            }
            
        }
        
        FirebaseService.instance.loadVersion { (version) in
            if let version = version{
                self.versionLabel.text = version
            }
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        loader.isHidden = false
        loader.startAnimating()
        if targetContentOffset.pointee.y == 0.0 {
            FirebaseService.instance.loadFeeds(callback: {(feeds) in
                self.throwBackDataSource.feedList = feeds.filter({ $0.throwBack })
                self.dropListDataSource.feedList = feeds.filter({$0.droplist})
                self.throwBacksCollectionView.reloadData()
                self.dropListCollectionView.reloadData()
                self.refereshThrowBackCollectionSize()
                
            })

            FirebaseService.instance.loadSlides(callback: {
                (slides) in
                self.slidePageViewController?.slides = slides
            })

            FirebaseService.instance.loadHomeMessage { (messages) in
                if let messages = messages
                {
                    self.showBanner(message: messages.bannerMessage)
                    self.dropListMessageLabel.text = messages.droplistMessage
                    self.throwbacksMessageLabel.text = messages.throwBackMessage
                }

            }

            FirebaseService.instance.loadVersion { (version) in
                if let version = version{
                    self.versionLabel.text = version
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let cell = Bundle.main.loadNibNamed("FeedCollectionVCell", owner: nil, options: nil)!.first as! UICollectionViewCell
        print("cell width:\(cell.frame.width) height:\(cell.frame.height)")
        
        let throwBackCellWidth = (throwBacksCollectionView.frame.width/CGFloat(THROWBACL_COLOM_COUNT)) - 10
        
        let throwLayout = (throwBacksCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        throwLayout.itemSize = CGSize(width:throwBackCellWidth    ,height:throwBackCellWidth * cell.frame.height/cell.frame.width)
        
        
        throwLayout.minimumLineSpacing = CGFloat(40)/CGFloat(THROWBACL_COLOM_COUNT)
        throwLayout.minimumInteritemSpacing = CGFloat(40)/CGFloat(THROWBACL_COLOM_COUNT) - 1
        
        
        
        dropListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let dropListLayout = (dropListCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        let dropCellWidth = dropListCollectionView.frame.width/CGFloat(DROPLIST_COLOM_COUNT) - 10
        dropListLayout.itemSize = CGSize(width:dropCellWidth,height:dropCellWidth*cell.frame.height/cell.frame.width)
        dropListLayout.minimumLineSpacing = CGFloat(30)/CGFloat(DROPLIST_COLOM_COUNT-1)
        dropListLayout.minimumInteritemSpacing = CGFloat(30)/CGFloat(DROPLIST_COLOM_COUNT-1) - 1
        
        refereshThrowBackCollectionSize()
        
        
    }
    
    @IBAction func onClickPreviousInDropList(_ sender: Any) {
        
        let currentPageIndex = getDropListCurrentBasePage()
        
        let targetIndex = currentPageIndex > 0 ? (currentPageIndex - 1)*DROPLIST_COLOM_COUNT : 0
        
        dropListCollectionView.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0), at: .left, animated: true)
    }
    
    
    @IBAction func onClickNextInDropList(_ sender: Any) {
        
        let currentPageIndex = getDropListCurrentBasePage()
        let rowCount = dropListCollectionView.dataSource!.collectionView(dropListCollectionView, numberOfItemsInSection: 0)
        
        if rowCount == 0
        {
            return
        }
        
        let targetPageIndex = currentPageIndex < rowCount/DROPLIST_COLOM_COUNT - 1 ? DROPLIST_COLOM_COUNT * (currentPageIndex + 1) : rowCount - 1
        
        dropListCollectionView.scrollToItem(at: IndexPath.init(row: targetPageIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    private func getDropListCurrentBasePage()->Int
    {
        return Int(round(dropListCollectionView.contentOffset.x/dropListCollectionView.frame.width))
    }
    
    private func showBanner(message:String)
    {
        homeBanner.viewModel = HomeBanner.ViewModel(message:message, onClick: { place in
            if place == HomeBanner.Place.item
            {
                self.tabBarViewController.selectTabBar(with: .dropList)
            }
            
            self.hideBanner()
        })
        self.scrollViewTopConstraint.constant = self.homeBanner.frame.height
        self.bannerTopAnchorConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
    }
    private func hideBanner()
    {
        self.scrollViewTopConstraint.constant = 0
        self.bannerTopAnchorConstraint.constant = -self.homeBanner.frame.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        }
    }
    
    private func refereshThrowBackCollectionSize()
    {
        throwBacksCollectionHeightConstraint.constant = max((throwBacksCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height, throwBacksCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
    
}


extension HomeVC
{
    public class ThrowBackTableController:NSObject,UICollectionViewDataSource,UICollectionViewDelegate
    {
        var feedList:[Feed] = []
        
        let parentVC:HomeVC
        
        init(parentVC:HomeVC)
        {
            self.parentVC = parentVC
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionVCell", for: indexPath) as! FeedCollectionVCell
            cell.feed = feedList[indexPath.row]
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return feedList.count
        }
        
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            parentVC.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedGroupPageController.ViewModel(feeds: feedList, selectedFeed: feedList[indexPath.row]))
        }
        
    }
}

extension HomeVC
{
    public class DropListCollectionController:NSObject,UICollectionViewDataSource,UICollectionViewDelegate
    {
        var feedList:[Feed] = []
        
        let parentVC:HomeVC
        
        init(parentVC:HomeVC)
        {
            self.parentVC = parentVC
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionVCell", for: indexPath) as! FeedCollectionVCell
            cell.feed = feedList[indexPath.row]
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return feedList.count
        }
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            parentVC.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedGroupPageController.ViewModel(feeds: feedList, selectedFeed: feedList[indexPath.row]))
        }
    }
}
