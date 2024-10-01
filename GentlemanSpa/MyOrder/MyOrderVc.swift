//
//  MyOrderVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 23/09/24.
//

import UIKit

class MyOrderVc: UIViewController {
    @IBOutlet weak var table_Order : UITableView!

    @IBOutlet weak var lbeUPCOMING: UILabel!
    @IBOutlet weak var lbeCONFIRMED: UILabel!
    @IBOutlet weak var lbePAST: UILabel!
    var pageName = "Upcoming"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbeUPCOMING.textColor = AppColor.BlackColor
        lbePAST.textColor = AppColor.BlackColor
        lbeCONFIRMED.textColor = AppColor.BlackColor
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true)
    }
    
    @IBAction func btn_Up(_ sender: Any) {
      
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
        pageName = "Upcoming"
        self.table_Order.reloadData()
    }
    
    @IBAction func btn_Co(_ sender: Any) {
        
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = AppColor.BrownColor
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Confirmed"
        self.table_Order.reloadData()
    }
    
    @IBAction func btn_Past(_ sender: Any) {
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = AppColor.BrownColor
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Past"
        self.table_Order.reloadData()

    }
   
}
extension MyOrderVc: UITableViewDataSource,UITableViewDelegate {
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
            
            Utility.shared.makeShadowsOfView_roundCorner(view: cell.cellViewRound, shadowRadius: 3.0, cornerRadius: 10.0, borderColor: UIColor.lightGray.withAlphaComponent(0.10))
            Utility.shared.makeShadowsOfView_roundCorner(view: cell.imgViewRound, shadowRadius: 3.0, cornerRadius: 8.0, borderColor: UIColor.lightGray.withAlphaComponent(0.10))
        
        
        cell.lbeName.text = "Hydrating Milk Cleanser"
        
        var mrp = "111"
        var price = 0.00
        price = 100
        
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            mrp = String(format: "$%.0f", price)
        }
        else{
            mrp = String(format: "$%.2f", price)
        }
        
        cell.lbeQML.text = mrp
        cell.lbeAmount.text = "Order date " + "23-9-2024"
        cell.lbeDelivery.text =  "Delivery"
        
        if pageName == "Upcoming"{
            cell.lbeOrder.text =  "Pending"

        }
        if pageName == "Confirmed"{
            cell.lbeOrder.text =  "Completed"

        }
        if pageName == "Past"{
            cell.lbeOrder.text =  "Cancel"

        }
        
        cell.lbePayment.text =  "Paid"
        cell.imageV?.image = UIImage(named: "imagesProduct")

     
    return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return 190
     
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return false
    }
    

}


class MyOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var imgViewRound: UIView!
    @IBOutlet weak var cellViewRound: UIView!
    
    @IBOutlet weak var lbeQML: UILabel!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeDelivery: UILabel!
    @IBOutlet weak var lbeOrder: UILabel!
    @IBOutlet weak var lbePayment: UILabel!

}
