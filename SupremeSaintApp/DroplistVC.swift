

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
    var loadingStart = 20
    var databaseRef:DatabaseReference!
    var feedList:[Feed] = []
    var listFiltered:[Feed] = []
    
    //let searchController = UISearchController(searchResultsController: nil)
    
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
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
//        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.definesPresentationContext = true
        //Add search view to table view
        
        
        //        UIFont(name: "Courier New", size: 12)
        let font = UIFont(name: "Courier-Bold", size: 12)
//        let fontStyle = UIFont.Weight.bold
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
    
    
    
    
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
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
        }
        else{
            value = 1
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
        if searchBar.text != "" {
            //If search is found
            return listFiltered.count
        }
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchBar.text != "" {
            //If search is found
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
            let imageUrl = URL(string: listFiltered[indexPath.row].photoUrl)
            cell.itemImage.kf.setImage(with: imageUrl!)
            cell.itemName.text = listFiltered[indexPath.row].name
            cell.itemPrice.text = listFiltered[indexPath.row].priceUS
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
            let imageUrl = URL(string: feedList[indexPath.row].photoUrl)
            cell.itemImage.kf.setImage(with: imageUrl!)
            cell.itemName.text = feedList[indexPath.row].name
            cell.itemPrice.text = feedList[indexPath.row].priceUS
            //        rowIndex = indexPath.row
            //        if valueIndex == 0{
            //            let imageUrl = URL(string: "http://")
            //            cell.itemImage.kf.setImage(with: imageUrl!)
            //            cell.itemName.text = ""
            //            cell.itemPrice.text = ""
            //            cell.btnNext.isHidden = true
            //        }
            //        else if rowIndex != valueIndex{
            //            //All data gets sets here
            //            let imageUrl = URL(string: feedList[rowIndex].photoUrl)
            //            cell.itemImage.kf.setImage(with: imageUrl!)
            //            cell.itemName.text = feedList[rowIndex].name
            //            cell.itemPrice.text = feedList[rowIndex].priceUS
            //        }
            //        else{
            //            let imageUrl = URL(string: "http://")
            //            cell.itemImage.kf.setImage(with: imageUrl!)
            //            cell.itemName.text = ""
            //            cell.itemPrice.text = ""
            //            cell.btnNext.isHidden = true
            //        }
            //        rowIndex = rowIndex + 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text != "" {
            //HANDLE ROW SELECTION FROM FILTERED DATA
            self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedGroupPageController.ViewModel(feeds: self.fullCatalogarray, selectedFeed: self.listFiltered[indexPath.row]))
            view.endEditing(true)
        }
        else{
            self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedGroupPageController.ViewModel(feeds: feedList, selectedFeed: feedList[indexPath.row]))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = feedList.count - 1
        if indexPath.row == lastItem && lastItem > 18{
            loadMore(start: self.loadingStart, end: self.loadingStart + 20)
        }
    }
    
    func loadMore(start: Int, end: Int){
        self.loadingStart = self.loadingStart + end
        self.storedData.set(1, forKey: "ForVote")
        rowIndex = start
        self.valueIndex = end
        if segment.selectedSegmentIndex == 1{
            databaseRef.child("Catalog").queryOrdered(byChild: "child_count").queryStarting(atValue: start).queryEnding(atValue: end).observe(.childAdded, with: { (snapshot) in
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
        self.feedList.removeAll()
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
    
    func catalog(){
        
        self.storedData.set(1, forKey: "ForVote")
        loader.isHidden = false
        loader.startAnimating()
        self.feedList.removeAll()
        rowIndex = 0
        self.valueIndex = 0
        databaseRef.child("Catalog").queryOrdered(byChild: "child_count").queryStarting(atValue: 0).queryEnding(atValue: 19).observe(.childAdded, with: { (snapshot) in
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
                        
                        let model = Feed(id: items.key, description: description, droplist: true, name: name, photoUrl: image, priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
                        self.fullCatalogarray.append(model)
                    }
                }
            }
            
        
            
        }
        
    }
    
    
}

