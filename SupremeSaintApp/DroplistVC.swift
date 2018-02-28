

import UIKit
import Firebase
import Kingfisher
import UILoadControl

class ShopVC: TabBarViewControllerPage, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var images = [String]()
    var names = [String]()
    var prices = [String]()
    var itemIds = [String]()
    
    var itemId:String!
    var imageUrl:String!
    var itemName:String!
    var price:String!
    
    
    var fullCatalogarray  = [Feed]()
    
    var refresher: UIRefreshControl!
    
    var rowIndex = 0
    var valueIndex = 0
    var value = 0
    var loadingStart = 22
    var databaseRef:DatabaseReference!
    var feedList:[Feed] = []
    var listFiltered:[Feed] = []
    
    
    var storedData = UserDefaults.standard
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("amad")
        fullcatalog()
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(ShopVC.populate), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.red

        
        
        let font = UIFont(name: "Courier-Bold", size: 12)
        segment.setTitleTextAttributes([NSAttributedStringKey.font: font!],
                                       for: .normal)
        
        loader.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.separatorColor = UIColor.clear
        
        databaseRef = Database.database().reference()
        getData(check: "True")
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
    }
    
    //Search delegate method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let stringOfUser = (searchBar.text!)
        listFiltered = fullCatalogarray.filter({ (item) -> Bool in
            let value:NSString = item.name as NSString
            return (value.range(of: stringOfUser, options: .caseInsensitive).location != NSNotFound)
        })
        tableView.reloadData()
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.valueIndex = 0
            value = 0
            getData(check: "True")
            view.endEditing(true)
        }
        if segment.selectedSegmentIndex == 1{
            self.valueIndex = 0
            value = 1
            leftToDrop()
            view.endEditing(true)
        }
        if segment.selectedSegmentIndex == 2{
            value = 2
            self.valueIndex = 0
            catalog()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segment.selectedSegmentIndex == 0
        {
            return feedList.count
        }
        if segment.selectedSegmentIndex == 1
        {
            return feedList.count
        }
        if segment.selectedSegmentIndex == 2
        {
            if searchBar.text != "" {
                //If search is found
                return listFiltered.count
            }
            print("Total cells \(feedList.count)")
            return feedList.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if segment.selectedSegmentIndex == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
            let imageUrl = URL(string: feedList[indexPath.row].photoUrl)
            if imageUrl != nil
            {
                cell.itemImage.kf.setImage(with: imageUrl!, placeholder: #imageLiteral(resourceName: "preview"), options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
            }
            cell.itemName.text = feedList[indexPath.row].name
            cell.itemPrice.text = feedList[indexPath.row].priceUS
            
            return cell
        }
        if segment.selectedSegmentIndex == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
            let imageUrl = URL(string: feedList[indexPath.row].photoUrl)
            if imageUrl != nil
            {
                cell.itemImage.kf.setImage(with: imageUrl!, placeholder: #imageLiteral(resourceName: "preview"), options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
            }
            cell.itemName.text = feedList[indexPath.row].name
            cell.itemPrice.text = feedList[indexPath.row].priceUS
            
            return cell
        }
        if segment.selectedSegmentIndex == 2
        {
            if searchBar.text != "" {
                //If search is found
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
                let imageUrl = URL(string: listFiltered[indexPath.row].photoUrl)
                if imageUrl != nil
                {
                    cell.itemImage.kf.setImage(with: imageUrl!, placeholder: #imageLiteral(resourceName: "preview"), options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
                }
                cell.itemName.text = listFiltered[indexPath.row].name
                cell.itemPrice.text = listFiltered[indexPath.row].description
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
                let imageUrl = URL(string: feedList[indexPath.row].photoUrl)
                if imageUrl != nil
                {
                    
                    cell.itemImage.kf.setImage(with: imageUrl!, placeholder: #imageLiteral(resourceName: "preview"), options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
                }
                cell.itemName.text = feedList[indexPath.row].name
                cell.itemPrice.text = feedList[indexPath.row].description
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segment.selectedSegmentIndex == 0
        {
            self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedViewController.ViewModel(selectedFeed: feedList[indexPath.row]))
        }
        if segment.selectedSegmentIndex == 1
        {
            self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedViewController.ViewModel(selectedFeed: feedList[indexPath.row]))
        }
        if segment.selectedSegmentIndex == 2
        {
            if searchBar.text != "" {
                //HANDLE ROW SELECTION FROM FILTERED DATA
                self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedViewController.ViewModel(selectedFeed: self.listFiltered[indexPath.row]))
                view.endEditing(true)
            }
            else{
                self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedViewController.ViewModel(selectedFeed: feedList[indexPath.row]))
            }
        }
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
        
        let lastItem = feedList.count - 1
        if indexPath.row == lastItem && lastItem > 18{
            if segment.selectedSegmentIndex == 2{
                loadMore(start: self.loadingStart, end: self.loadingStart + 20)
            }
        }
    }
    
    func loadMore(start: Int, end: Int){
        self.loadingStart += 20
        self.storedData.set(2, forKey: "ForVote")
        rowIndex = start
        self.valueIndex = end
        if segment.selectedSegmentIndex == 2{
            databaseRef.child("Catalog").queryOrdered(byChild: "child_count").queryStarting(atValue: start).queryLimited(toFirst: 20).observe(.childAdded, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.valueIndex = self.valueIndex + 1
                let photos = value?["Photos"] as? NSArray
                let image = photos![1] as? String ?? "http://"
                let name = value?["ProductName"] as? String ?? ""
                let priceUS = value?["Price-US"] as? String ?? ""
                let priceEU = value?["Price-EU"] as? String ?? ""
                let description = value?["Description"] as? String ?? ""
                let season = value?["Season"] as? String ?? ""
                let throwback = value?["Throwback"] as? Bool ?? false
                let week = value?["Week"] as? Int ?? 0
                
                let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                self.feedList.append(model)
                DispatchQueue.main.async {
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                }
            }) { (Error) in
                print(Error)
            }
        }
        else{
            databaseRef.child("Catalog").observe(.childAdded, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let Droplist = value?["Droplist"] as? String ?? ""
                if Droplist == "True"{
                    self.valueIndex = self.valueIndex + 1
                    let photos = value?["Photos"] as? NSArray
                    let image = photos![1] as? String ?? "http://"
                    let name = value?["ProductName"] as? String ?? ""
                    let priceUS = value?["Price-US"] as? String ?? ""
                    let priceEU = value?["Price-EU"] as? String ?? ""
                    let description = value?["Description"] as? String ?? ""
                    let season = value?["Season"] as? String ?? ""
                    let throwback = value?["Throwback"] as? Bool ?? false
                    let week = value?["Week"] as? Int ?? 0
//                    let droplist_b = value?["Droplist"] as? Bool ?? false
                    let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                    self.feedList.append(model)
                }
                DispatchQueue.main.async {
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                    
                }
            }) { (Error) in
                print(Error)
            }
        }
    }
    
    @objc func populate(){
        if value == 0{
            rowIndex = 0
            valueIndex = 0
            getData(check: "True")
        }
        else if value == 1{
            rowIndex = 0
            valueIndex = 0
            leftToDrop()
        }
        else{
            rowIndex = 0
            valueIndex = 0
            catalog()
        }
        refresher.endRefreshing()
    }
    
    func getData(check:String){
        self.storedData.set(0, forKey: "ForVote")
        loader.isHidden = false
        loader.startAnimating()
        listFiltered.removeAll()
        feedList.removeAll()
        tableView.reloadData()
        rowIndex = 0
        self.valueIndex = 0
        databaseRef.child("Catalog").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let Droplist = value?["Droplist"] as? String ?? ""
            if Droplist == check{
                self.valueIndex = self.valueIndex + 1
                let photos = value?["Photos"] as? NSArray
                let image = photos![1] as? String ?? "http://"
                let name = value?["ProductName"] as? String ?? ""
                let priceUS = value?["Price-US"] as? String ?? ""
                let priceEU = value?["Price-EU"] as? String ?? ""
                let description = value?["Description"] as? String ?? ""
                let season = value?["Season"] as? String ?? ""
                let throwback = value?["Throwback"] as? Bool ?? false
                let week = value?["Week"] as? Int ?? 0
                //                let droplist_b = value?["Droplist"] as? Bool ?? false
                let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                self.feedList.append(model)
            }
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.loader.stopAnimating()
                let HEIGHT_VIEW = 0
                self.tableView.tableHeaderView?.frame.size = CGSize(width:self.tableView.frame.width, height: CGFloat(HEIGHT_VIEW))
                self.tableView.reloadData()
                
            }
        }) { (Error) in
            print(Error)
        }
    }
    
    func leftToDrop()
    {
        self.storedData.set(1, forKey: "ForVote")
        loader.isHidden = false
        loader.startAnimating()
        self.feedList.removeAll()
        tableView.reloadData()
        rowIndex = 0
        self.valueIndex = 0
        databaseRef.child("Catalog").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let Droplist = value?["Droplist"] as? String ?? ""
            if Droplist == "True"{
                self.valueIndex = self.valueIndex + 1
                let photos = value?["Photos"] as? NSArray
                let image = photos![1] as? String ?? "http://"
                let name = value?["ProductName"] as? String ?? ""
                let priceUS = value?["Price-US"] as? String ?? ""
                let priceEU = value?["Price-EU"] as? String ?? ""
                let description = value?["Description"] as? String ?? ""
                let season = value?["Season"] as? String ?? ""
                let throwback = value?["Throwback"] as? Bool ?? false
                let week = value?["Week"] as? Int ?? 0
                //                let droplist_b = value?["Droplist"] as? Bool ?? false
                let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                self.feedList.append(model)
            }
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.loader.stopAnimating()
                let HEIGHT_VIEW = 0
                self.tableView.tableHeaderView?.frame.size = CGSize(width:self.tableView.frame.width, height: CGFloat(HEIGHT_VIEW))
                self.tableView.reloadData()
                
            }
        }) { (Error) in
            print(Error)
        }
    }
    
    
    func catalog(){
        
        self.storedData.set(2, forKey: "ForVote")
        loader.isHidden = false
        loader.startAnimating()
        self.feedList.removeAll()
        rowIndex = 0
        self.valueIndex = 0
        databaseRef.child("Catalog").queryOrdered(byChild: "child_count").queryStarting(atValue: 0).queryLimited(toFirst: 20).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.valueIndex = self.valueIndex + 1
            let photos = value?["Photos"] as? NSArray
            let image = photos![1] as? String ?? "http://"
            let name = value?["ProductName"] as? String ?? ""
            let priceUS = value?["Price-US"] as? String ?? ""
            let priceEU = value?["Price-EU"] as? String ?? ""
            let description = value?["Description"] as? String ?? ""
            let season = value?["Season"] as? String ?? ""
            let throwback = value?["Throwback"] as? Bool ?? false
            let week = value?["Week"] as? Int ?? 0
            
            let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
            self.feedList.append(model)
            DispatchQueue.main.async {
                self.loader.isHidden = true
                self.loader.stopAnimating()
                let HEIGHT_VIEW = 60
                self.tableView.tableHeaderView?.frame.size = CGSize(width:self.tableView.frame.width, height: CGFloat(HEIGHT_VIEW))
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
    }
    
    
    func fullcatalog()
    {
        // full catalog array searching
    
        Database.database().reference().child("Catalog").observeSingleEvent(of: .value) { (snapshot) in
            
            if let itemSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                var count = 0
                for items in itemSnapshot
                {
                    if let value = items.value as? NSDictionary
                    {
                        let photos = value["Photos"] as? NSArray
                        let image = photos![1] as? String ?? "http://"
                        let name = value["ProductName"] as? String ?? ""
                        let priceUS = value["Price-US"] as? String ?? ""
                        let priceEU = value["Price-EU"] as? String ?? ""
                        let description = value["Description"] as? String ?? ""
                        let season = value["Season"] as? String ?? ""
                        let throwback = value["Throwback"] as? Bool ?? false
                        let week = value["Week"] as? Int ?? 0
                        count += 1
                        let model = Feed(id: items.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                        self.fullCatalogarray.append(model)
                    }
                }
                print("Total Count \(count)")
            }
            
        
            
        }
        
    }
    
    
}

