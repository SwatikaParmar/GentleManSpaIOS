//
//  OrderDetailsTableViewCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/10/24.
//

import UIKit


class DataOrderDetailTVCell: UITableViewCell {
    
    
    @IBOutlet weak var lbeOrderDate: UILabel!
    @IBOutlet weak var lbeTotalAmount: UILabel!
    @IBOutlet weak var lbeOrderStatus: UILabel!

    
    
    
}

class ServicesOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewServices : UITableView!
    
    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalDiscountAmount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
    
    
    var arrSortedService = [OrderService]()
    var lastClass = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func btnremoveCartTap(sender:UIButton){
    
        
    }
    
    @objc func addDateTap(sender:UIButton){
        
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        controller.spaServiceId = arrSortedService[sender.tag].spaServiceId
        controller.serviceName = arrSortedService[sender.tag].serviceName
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

extension ServicesOrderDetailsTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrSortedService.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableViewServices.dequeueReusableCell(withIdentifier: "CartServicesTvCell") as! CartServicesTvCell
        
        cell.addView.isHidden = false

        
      
        
//        cell.removeCart.tag = indexPath.row
//        cell.removeCart.addTarget(self, action: #selector(btnremoveCartTap(sender:)), for: .touchUpInside)
//        
//        cell.addDate.tag = indexPath.row
//        cell.addDate.addTarget(self, action: #selector(addDateTap(sender:)), for: .touchUpInside)
//        
        if let imgUrl = arrSortedService[indexPath.row].image,!imgUrl.isEmpty {
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
        if arrSortedService[indexPath.row].price.truncatingRemainder(dividingBy: 1) == 0 {
            listingPrice = String(format: "%.0f", arrSortedService[indexPath.row].price )
        }
        else{
            listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
        }
        cell.lbeAmount.text = "$" + listingPrice
        
        
//        var basePrice = ""
//        if arrSortedService[indexPath.row].basePrice.truncatingRemainder(dividingBy: 1) == 0 {
//            basePrice = String(format: "%.0f", arrSortedService[indexPath.row].basePrice )
//        }
//        else{
//            basePrice = String(format: "%.2f", arrSortedService[indexPath.row].basePrice )
//        }
        cell.lbeBasePrice.text = ""
        cell.lbeTime.text = ""
        

        var dateStr = ""
            dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
            
        cell.lbeDate.text = dateStr
        
        
        if arrSortedService[indexPath.row].orderStatus == "Pending" {
            cell.lbeOrderStatus.text = "Pending"
            cell.lbeOrderStatus.textColor = .blue
            cell.viewOrderStatus.layer.borderColor = UIColor(.blue).cgColor
            cell.addView.isHidden = false

        }
        else if arrSortedService[indexPath.row].orderStatus == "Cancelled" {
            cell.lbeOrderStatus.text = "Cancelled"
            cell.lbeOrderStatus.textColor = .red
            cell.viewOrderStatus.layer.borderColor = UIColor(.red).cgColor
            cell.addView.isHidden = true
        }
        else{
            cell.lbeOrderStatus.text = "Completed"
            cell.lbeOrderStatus.textColor = .green
            cell.viewOrderStatus.layer.borderColor = UIColor(.green).cgColor
            cell.addView.isHidden = true

        }
            

        
        
       
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lineCount = arrSortedService[indexPath.row].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 174)
        
        if lineCount > 1 {
            if self.arrSortedService[indexPath.row].fromTime == "" {
                return  190
            }
            return  195
        }
      
        return  145
        
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


class ProductOrderDetailsTableViewCell: UITableViewCell {

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

    
    

    var arrSortedProduct = [OrderProduct]()
    var itemCount = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:- Add Button Tap
    @objc func btnIncreaseButtonTap(sender:UIButton){
        
  

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
     

    }
    
    func addNewProduct(Model: [String : AnyObject], index:Int){
        AddOrUpdateProductInCartRequest.shared.addProductAPI(requestParams: Model) { (user,message,isStatus) in
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

extension ProductOrderDetailsTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
            return arrSortedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
            let cell = tableViewProduct.dequeueReusableCell(withIdentifier: "MyCartTableViewCell") as! MyCartTableViewCell
            
                
                cell.addToCart.isHidden = true
                cell.addView.isHidden = false
                cell.lbeCount.isHidden = false
                cell.lbeCount.text =   String(arrSortedProduct[indexPath.row].quantity)
           
            
//            cell.increaseButton.tag = indexPath.row
//            cell.increaseButton.addTarget(self, action: #selector(btnIncreaseButtonTap(sender:)), for: .touchUpInside)
//            
//            cell.decreaseButton.tag = indexPath.row
//            cell.decreaseButton.addTarget(self, action: #selector(btnDecreaseButtonTap(sender:)), for: .touchUpInside)
            
            
            if let imgUrl = arrSortedProduct[indexPath.row].productImage,!imgUrl.isEmpty {
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
            cell.lbeName.text = arrSortedProduct[indexPath.row].productName
            
            
            var listingPrice = ""
            if arrSortedProduct[indexPath.row].price.truncatingRemainder(dividingBy: 1) == 0 {
                listingPrice = String(format: "%.0f", arrSortedProduct[indexPath.row].price )
            }
            else{
                listingPrice = String(format: "%.2f", arrSortedProduct[indexPath.row].price )
            }
            cell.lbeAmount.text = "$" + listingPrice
            
            
//            var basePrice = ""
//            if arrSortedProduct[indexPath.row].basePrice.truncatingRemainder(dividingBy: 1) == 0 {
//                basePrice = String(format: "%.0f", arrSortedProduct[indexPath.row].basePrice )
//            }
//            else{
//                basePrice = String(format: "%.2f", arrSortedProduct[indexPath.row].basePrice )
//            }
            cell.lbeBasePrice.text = ""
//            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lineCount = arrSortedProduct[indexPath.row].productName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 174)
        
        if lineCount > 1 {
            return  145

        }
        return  130

        
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

