//
//  ChatLeftTextTableCell.swift
//  Yellow Cap
//
//  Created by DeftDeskSol on 16/04/18.
//  Copyright © 2018 Hassan Khan. All rights reserved.
//

import UIKit

class ChatLeftTextTableCell: UITableViewCell {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageViewBubble: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var viewCenterMConst: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         viewLeft.layer.cornerRadius = 7.0
        if Utility.ScreenSize.SCREEN_WIDTH == 320.0 {
            viewCenterMConst.constant = 285.0
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
