//
//  ItemTableCell.swift
//  SupremeSaintApp
//
//  Created by Sanan on 1/19/18.
//  Copyright © 2018 Sladerade. All rights reserved.
//

import UIKit

class ItemTableCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
