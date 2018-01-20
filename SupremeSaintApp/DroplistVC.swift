

import UIKit
import Firebase
import Kingfisher

class ShopVC: TabBarViewControllerPage, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var images = [String]()
    var names = [String]()
    var prices = [String]()
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.separatorColor = UIColor.clear
        databaseRef = Database.database().reference()
        getData()
        
        // Do any additional setup after loading the view.
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
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableCell
        let imageUrl = URL(string: images[indexPath.row])
        cell.itemImage.kf.setImage(with: imageUrl!)
        cell.itemName.text = names[indexPath.row]
        cell.itemPrice.text = prices[indexPath.row]
        return cell
    }
    
    func getData(){
        loader.isHidden = false
        loader.startAnimating()
        
        databaseRef.child("Catalog").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let Droplist = value?["Droplist"] as? String ?? ""
            if Droplist == "True"{
                let image = value?["Photos"] as? String ?? ""
                let name = value?["Name"] as? String ?? ""
                let priceUS = value?["Price-US"] as? String ?? ""
                let priceEU = value?["Price-EU"] as? String ?? ""
                self.images.append(image)
                self.names.append(name)
                self.prices.append("\(priceUS)/\(priceEU)")
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
