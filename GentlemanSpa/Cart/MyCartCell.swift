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
    @IBOutlet weak var lbeDate: UILabelX!
    
    @IBOutlet weak var addDate: UIButton!

    @IBOutlet weak var lbeAddDate: UILabelX!
    @IBOutlet weak var viewAddDate: UIViewX!
    
    
    @IBOutlet weak var lbeOrderStatus: UILabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    
    
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

class ServicesListTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewServices : UITableView!
    
    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalDiscountAmount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
    
    
    var arrSortedService = [AllCartServices]()
    var lastClass = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func btnremoveCartTap(sender:UIButton){
    
        arrSortedService[sender.tag].serviceCountInCart = 0
        self.tableViewServices.reloadData()
        
        var param = [String : AnyObject]()
        param["spaServiceId"] = arrSortedService[sender.tag].spaServiceId as AnyObject
        param["spaDetailId"] = 21 as AnyObject
        param["serviceCountInCart"] = 0 as AnyObject
        param["slotId"] = 0 as AnyObject

        self.addUpdateService(Model: param, index:sender.tag)
        
    }
    
    @objc func addDateTap(sender:UIButton){
        
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        controller.spaServiceId = arrSortedService[sender.tag].spaServiceId
        controller.serviceName = arrSortedService[sender.tag].serviceName
        
        if arrSortedService[sender.tag].professionalName != ""{
            controller.isReschedule = true
            controller.isMyCart = true
        }
        else{
            controller.isMyCart = true
        }

        
        self.lastClass.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    func addUpdateService(Model: [String : AnyObject], index:Int){
        AddUpdateCartServiceRequest.shared.AddUpdateCartServiceAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                    NotificationCenter.default.post(name: Notification.Name("Table_Refresh"), object: nil, userInfo: nil)

                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
           
        }
    }
}

extension ServicesListTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrSortedService.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableViewServices.dequeueReusableCell(withIdentifier: "CartServicesTvCell") as! CartServicesTvCell
        
        if arrSortedService[indexPath.row].serviceCountInCart == 0 {
            cell.addView.isHidden = false

        }
        else{
            cell.addView.isHidden = true

        }
        
      
        
        cell.removeCart.tag = indexPath.row
        cell.removeCart.addTarget(self, action: #selector(btnremoveCartTap(sender:)), for: .touchUpInside)
        
        cell.addDate.tag = indexPath.row
        cell.addDate.addTarget(self, action: #selector(addDateTap(sender:)), for: .touchUpInside)
        
        if let imgUrl = arrSortedService[indexPath.row].serviceImage,!imgUrl.isEmpty {
            let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                         placeholderImage: UIImage(named: "shopPlace"),
                                         options: .refreshCached,
                                         completed: nil)
        }
        else{
            cell.imgService?.image = UIImage(named: "shopPlace")
        }
        cell.lbeName.text = arrSortedService[indexPath.row].serviceName
        
        
        var listingPrice = ""
        if arrSortedService[indexPath.row].listingPrice.truncatingRemainder(dividingBy: 1) == 0 {
            listingPrice = String(format: "%.0f", arrSortedService[indexPath.row].listingPrice )
        }
        else{
            listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].listingPrice )
        }
        cell.lbeAmount.text = "$" + listingPrice
        
        
        var basePrice = ""
        if arrSortedService[indexPath.row].basePrice.truncatingRemainder(dividingBy: 1) == 0 {
            basePrice = String(format: "%.0f", arrSortedService[indexPath.row].basePrice )
        }
        else{
            basePrice = String(format: "%.2f", arrSortedService[indexPath.row].basePrice )
        }
        cell.lbeBasePrice.text = "$" + basePrice
        if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
            cell.lbeTime.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes )
        }
        else{
            cell.lbeTime.text = "30 mins"
        }
        
        if self.arrSortedService[indexPath.row].fromTime == "" {
            cell.lbeDate.text = ""
            cell.lbeAddDate.text = "Select date and time"
        }
        else{
            var dateStr = ""
            dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
            
            cell.lbeDate.text = dateStr
            
            cell.lbeAddDate.text = "Reschedule"

        }
        
       
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lineCount = arrSortedService[indexPath.row].serviceName.heightForView(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 150)
        
        print(lineCount)
        print(arrSortedService[indexPath.row].serviceName)

        if lineCount > 47 {
            if self.arrSortedService[indexPath.row].fromTime == "" {
                return  180
            }
            return  196

        }
        if self.arrSortedService[indexPath.row].fromTime == "" {
            return  160

        }
        return  177
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
}


class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewProduct : UITableView!
    
    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
   
    
    
    @IBOutlet weak var imgViewHome : UIImageView!
    @IBOutlet weak var imgViewVenue : UIImageView!
    @IBOutlet weak var imgViewAddAddress : UIImageView!

    @IBOutlet weak var lbeAddress : UILabel!

    @IBOutlet weak var lbeHomeType : UILabel!
    @IBOutlet weak var lbeVenueType : UILabel!
    @IBOutlet weak var lbeAddressTitle : UILabel!

    @IBOutlet weak var btnAdd : UIButton!
    
    @IBOutlet weak var addressView_H_Constraint: NSLayoutConstraint!
    @IBOutlet weak var addressView: UIView!

    
    

    var arrSortedProduct = [AllCartProducts]()
    var itemCount = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:- Add Button Tap
    @objc func btnIncreaseButtonTap(sender:UIButton){
        
        itemCount = arrSortedProduct[sender.tag].productCountInCart
        
        if self.arrSortedProduct[sender.tag].inStock == itemCount {
            var stringCount = ""
            stringCount = String(format:"Can't add more than %d items.", self.arrSortedProduct[sender.tag].inStock)
            NotificationAlert().NotificationAlert(titles:stringCount)
            return
        }
        
        arrSortedProduct[sender.tag].productCountInCart = arrSortedProduct[sender.tag].productCountInCart + 1
        itemCount = arrSortedProduct[sender.tag].productCountInCart
    
        self.tableViewProduct.reloadData()
        
        var param = [String : AnyObject]()
        param["productId"] = arrSortedProduct[sender.tag].productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
        arrSortedProduct[sender.tag].productCountInCart = arrSortedProduct[sender.tag].productCountInCart - 1
        itemCount = arrSortedProduct[sender.tag].productCountInCart
        self.tableViewProduct.reloadData()
        var param = [String : AnyObject]()
        param["productId"] = arrSortedProduct[sender.tag].productId as AnyObject

        if  itemCount == 0 {
            param["countInCart"] = Int(0) as AnyObject
        }
        else if itemCount < 0 {
            param["countInCart"] = Int(0) as AnyObject
        }
        else{
            param["countInCart"] = Int(itemCount) as AnyObject
        }
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    func addNewProduct(Model: [String : AnyObject], index:Int){
        AddOrUpdateProductInCartRequest.shared.addProductAPI(requestParams: Model, false) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationCenter.default.post(name: Notification.Name("Table_Refresh"), object: nil, userInfo: nil)

                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
    }
}

extension ProductListTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
            return arrSortedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
            let cell = tableViewProduct.dequeueReusableCell(withIdentifier: "MyCartTableViewCell") as! MyCartTableViewCell
            
            if arrSortedProduct[indexPath.row].productCountInCart > 0{
                
                cell.addToCart.isHidden = true
                cell.addView.isHidden = false
                cell.lbeCount.isHidden = false
                cell.lbeCount.text =   String(arrSortedProduct[indexPath.row].productCountInCart)
            }
            else{
                cell.addView.isHidden = true
                cell.addToCart.isHidden = false
                cell.lbeCount.text =   String(arrSortedProduct[indexPath.row].productCountInCart)
                cell.lbeCount.isHidden = false
                
            }
            
            cell.increaseButton.tag = indexPath.row
            cell.increaseButton.addTarget(self, action: #selector(btnIncreaseButtonTap(sender:)), for: .touchUpInside)
            
            cell.decreaseButton.tag = indexPath.row
            cell.decreaseButton.addTarget(self, action: #selector(btnDecreaseButtonTap(sender:)), for: .touchUpInside)
            
            
            if let imgUrl = arrSortedProduct[indexPath.row].serviceImage,!imgUrl.isEmpty {
                let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                             placeholderImage: UIImage(named: "productNo"),
                                             options: .refreshCached,
                                             completed: nil)
            }
            else{
                cell.imgService?.image = UIImage(named: "productNo")
            }
            cell.lbeName.text = arrSortedProduct[indexPath.row].serviceName
            
            
            var listingPrice = ""
            if arrSortedProduct[indexPath.row].listingPrice.truncatingRemainder(dividingBy: 1) == 0 {
                listingPrice = String(format: "%.0f", arrSortedProduct[indexPath.row].listingPrice )
            }
            else{
                listingPrice = String(format: "%.2f", arrSortedProduct[indexPath.row].listingPrice )
            }
            cell.lbeAmount.text = "$" + listingPrice
            
            
            var basePrice = ""
            if arrSortedProduct[indexPath.row].basePrice.truncatingRemainder(dividingBy: 1) == 0 {
                basePrice = String(format: "%.0f", arrSortedProduct[indexPath.row].basePrice )
            }
            else{       
                basePrice = String(format: "%.2f", arrSortedProduct[indexPath.row].basePrice )
            }
            cell.lbeBasePrice.text = "$" + basePrice
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lineCount = arrSortedProduct[indexPath.row].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 174)
        
        if lineCount > 1 {
            return  165

        }
        return  150

        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    }

