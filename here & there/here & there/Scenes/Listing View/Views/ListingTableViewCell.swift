//
//  ListingTableViewCell.swift
//  here & there
//
//  Created by Milind Sharma on 30/09/21.
//

import UIKit
import MapKit

class ListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblDistance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: Location) {
        self.lblName.text = item.mapItem.name
        let address = (item.mapItem.placemark.name ?? "") + ", " + (item.mapItem.placemark.title ?? "")
        self.lblAddress.text = address
        self.lblPhone.text = item.mapItem.phoneNumber
        
        self.lblDistance.text = "\( String(format: "%.02f", item.distance * 0.000621371))" + " Miles"

    } 
}
