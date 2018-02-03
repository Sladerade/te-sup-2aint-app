

import UIKit
import Firebase
import Kingfisher

class ShopVC: TabBarViewControllerPage, UITableViewDataSource, UITableViewDelegate  {
    
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
    
    var value = 0
    var refresher: UIRefreshControl!
    
    var rowIndex = 0
    var valueIndex = 0
    
    var databaseRef:DatabaseReference!
    var feedList:[Feed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(ShopVC.populate), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        //        UIFont(name: "Courier New", size: 12)
        let font = UIFont(name: "Courier-Bold", size: 12)
        let fontStyle = UIFont.Weight.bold
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
        return valueIndex + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
        rowIndex = indexPath.row
        if rowIndex != valueIndex{
            let imageUrl = URL(string: feedList[rowIndex].photoUrl)
            cell.itemImage.kf.setImage(with: imageUrl!)
            cell.itemName.text = feedList[rowIndex].name
            cell.itemPrice.text = feedList[rowIndex].priceUS
        }
        else{
            let imageUrl = URL(string: "http://")
            cell.itemImage.kf.setImage(with: imageUrl!)
            cell.itemName.text = ""
            cell.itemPrice.text = ""
            cell.btnNext.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarViewController.performSegue(withIdentifier: "FeedGroupPageController", sender: FeedGroupPageController.ViewModel(feeds: feedList, selectedFeed: feedList[indexPath.row]))
    }
    
    @objc func populate(){
        if value == 0{
            getData(check: "True")
        }
        else{
            catalog()
        }
        refresher.endRefreshing()
    }
    
    func getData(check:String){
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
                
                let image = value?["Photos"] as? String ?? "http://"
                let name = value?["Name"] as? String ?? ""
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
                self.tableView.reloadData()
                
            }
        }) { (Error) in
            print(Error)
        }
    }
    
    func catalog(){
        loader.isHidden = false
        loader.startAnimating()
        self.feedList.removeAll()
        rowIndex = 0
        self.valueIndex = 0
        
        databaseRef.child("Old Catalog").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.valueIndex = self.valueIndex + 1
            let photos = value?["photos"] as? NSArray
            let image = photos![0] as? String ?? "http://"
            let name = value?["name"] as? String ?? ""
            let priceUS = value?["price-US"] as? String ?? ""
            let priceEU = value?["price-EU"] as? String ?? ""
            let description = value?["description"] as? String ?? ""
            let season = value?["season"] as? String ?? ""
            let throwback = value?["throwback"] as? Bool ?? false
            let week = value?["week"] as? Int ?? 0
            
            let model = Feed(id: snapshot.key, description: description, droplist: true, name: name, photoUrl: "http:\(image)", priceEU: priceEU, priceUS: priceUS, season: season, throwBack: throwback, week: week)
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
}

