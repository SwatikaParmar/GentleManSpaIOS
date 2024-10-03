//
//  SelectProTableViewCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/10/24.
//

import Foundation
import UIKit

class SelectProTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeProName: UILabel!
    @IBOutlet weak var imgPro: UIImageView!

    @IBOutlet weak var lbeTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
