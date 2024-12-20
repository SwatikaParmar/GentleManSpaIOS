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
    var arrOrder = [OrderItem]()

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
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
        MyOrderAPI(true)

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
        MyOrderAPI(true)

        self.table_Order.reloadData()
    }
    
    @IBAction func btn_Co(_ sender: Any) {
        
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = AppColor.BrownColor
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Completed"
        MyOrderAPI(true)

        self.table_Order.reloadData()
    }
    
    @IBAction func btn_Past(_ sender: Any) {
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = AppColor.BrownColor
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Cancelled"
        MyOrderAPI(true)
        self.table_Order.reloadData()

    }
    
    func MyOrderAPI(_ isLoader:Bool){
        arrOrder.removeAll()
        let params = [ "Type": pageName
        ] as [String : Any]
        GetOrderedProductsListRequest.shared.GetOrderedProductsRequest(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                arrOrder = arrayData ?? arrOrder
                self.table_Order.reloadData()
            }
        }
    }
    
    
   
}
extension MyOrderVc: UITableViewDataSource,UITableViewDelegate {

    
  
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
            
        if let imgUrl = arrOrder[indexPath.row].productImage,!imgUrl.isEmpty {
            let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imageV?.sd_setImage(with: URL.init(string:(urlString)),
                                         placeholderImage: UIImage(named: "shopPlace"),
                                         options: .refreshCached,
                                         completed: nil)
        }
        else{
            cell.imageV?.image = UIImage(named: "shopPlace")
        }
        
        
        var dateStr = ""
        dateStr =  String(format: "ORDER DATE: %@", "".convertToDDMMYYYY("".dateFromString(self.arrOrder[indexPath.row].orderDate)))
        
        cell.lbeBookingID.text = String(format: "ORDER ID: %d", self.arrOrder[indexPath.row].orderId )

        cell.lbeDate.text = dateStr
        cell.lbeName.text = arrOrder[indexPath.row].productName
        
        var mrp = ""
        var price = 0.00
        price = arrOrder[indexPath.row].price
        
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            mrp = String(format: "$%.2f", price)
        }
        else{
            mrp = String(format: "$%.2f", price)
        }
        cell.lbeQML.text = mrp
        
      
        cell.lbeDelivery.text =  "Delivery"
        
        if pageName == "Upcoming"{
            cell.lbeOrder.text =  "Pending"

        }
        if pageName == "Completed"{
            cell.lbeOrder.text =  "Completed"

        }
        if pageName == "Cancelled"{
            cell.lbeOrder.text =  "Cancel"

        }
        
        cell.lbePayment.text =  "Paid"

     
    return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return 231
     
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let controller:OrderDetailsViewController =  UIStoryboard(storyboard: .Cart).initVC()
        controller.orderId = self.arrOrder[indexPath.row].orderId
        self.navigationController?.pushViewController(controller, animated: true)
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
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!

}
