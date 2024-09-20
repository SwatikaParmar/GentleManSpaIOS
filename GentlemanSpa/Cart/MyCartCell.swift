//
//  MyCartCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 20/09/24.
//

import Foundation
import UIKit


class CartServicesTvCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var removeCart: UIButton!

    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeBasePrice: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}


class CartServicesBillTvCell: UITableViewCell {

    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalDiscountAmount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
    @IBOutlet var viewCancelAmount: UIView!
    @IBOutlet weak var lbeCancel: UILabel!
    @IBOutlet weak var lbeCancelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}


class MyCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeBasePrice: UILabel!
    @IBOutlet weak var lbeCount: UILabel!
    
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}





class BillDetailsTvCell: UITableViewCell {

    @IBOutlet var vwRound: UIView!
    
    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalDiscountAmount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
    @IBOutlet var viewCancelAmount: UIView!
    @IBOutlet weak var lbeCancel: UILabel!
    @IBOutlet weak var lbeCancelAmount: UILabel!
    @IBOutlet weak var cancelVieewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}


class DashSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var titleLabelMore: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
