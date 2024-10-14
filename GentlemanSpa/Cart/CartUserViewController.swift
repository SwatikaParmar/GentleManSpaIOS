//
//  CartUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class CartUserViewController: UIViewController {
    @IBOutlet weak var tableViewMyCart : UITableView!
    @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbePayNow: UILabelX!
    @IBOutlet weak var payNow : UIView!
    @IBOutlet weak var imgViewEm : UIImageView!
    @IBOutlet weak var viewDataBG : UIView!

    @IBOutlet weak var imgViewHome : UIImageView!
    @IBOutlet weak var imgViewVenue : UIImageView!
    @IBOutlet weak var imgViewAddAddress : UIImageView!

    @IBOutlet weak var lbeAddress : UILabel!
    @IBOutlet weak var paymentView_H_Constraint: NSLayoutConstraint!

    @IBOutlet weak var lbeHomeType : UILabel!
    @IBOutlet weak var lbeVenueType : UILabel!
    @IBOutlet weak var lbeAddressTitle : UILabel!

    @IBOutlet weak var btnAdd : UIButton!
    @IBOutlet weak var btnAdd_Top_Constraint: NSLayoutConstraint!

    
    var itemCount = 0
    var isVenueSelected = false
    var arrObject : CartDataModel?
    var arrSortedProduct = [AllCartProducts]()
    var arrObjectServices : cartServicesDataModel?
    var arrSortedService = [AllCartServices]()
    var arrayAddressData = [AddressListModel]()

    
    func topViewLayout(){
        if HomeViewController.hasSafeArea{
            if navigationViewConstraint != nil {
               // navigationViewConstraint.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.paymentView_H_Constraint.constant = 0

        topViewLayout()
        payNow.isHidden = true
        imgViewEm.isHidden = true
        tableViewMyCart.isHidden = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        myCartAPI(true)
      
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PlaceOrder(_ sender: Any) {
        bookingAPI()
    }
    @IBAction func Home(_ sender: Any) {
        
        imgViewHome.image = UIImage(named: "checkic")
        imgViewVenue.image = UIImage(named: "uncheck")
        self.lbeAddress.text = ""
        self.lbeAddressTitle.text = ""
        self.btnAdd.isHidden = false
        self.imgViewAddAddress.isHidden = false
        self.isVenueSelected = false

        GetAddressAPI()
    }
    
    @IBAction func Venue(_ sender: Any) {
        imgViewHome.image = UIImage(named: "uncheck")
        imgViewVenue.image = UIImage(named: "checkic")
        self.lbeAddress.text = ""
        self.lbeAddressTitle.text = ""
        self.btnAdd.isHidden = true
        self.imgViewAddAddress.isHidden = true
        self.paymentView_H_Constraint.constant = 220
        self.btnAdd_Top_Constraint.constant = 60
        self.isVenueSelected = true
    }
    
    @IBAction func AddAddress(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "Address", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "MyLocationVc") as?  MyLocationVc)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func bookingAPI() {

       let Model = [
           "customerAddressId": 0,
           "deliveryType": "AtVenue",
           "paymentType":  "Cash"] as [String : Any]
 
        BookAppointmentRequest.shared.bookingAPI(requestParams: Model) { (user,message,isStatus) in
               if isStatus {
                   let controller:OrderPlaceViewController =  UIStoryboard(storyboard: .User).initVC()
                   controller.providesPresentationContextTransitionStyle = true
                   controller.definesPresentationContext = true
                   controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
                   self.present(controller, animated: true, completion: nil)
                   
               }
           }
       }
    
    
    func productAddCart(_ bool:Bool){
        
         if self.isVenueSelected {
             imgViewHome.image = UIImage(named: "uncheck")
             imgViewVenue.image = UIImage(named: "checkic")
             self.lbeAddress.text = ""
             self.lbeAddressTitle.text = ""
             self.btnAdd.isHidden = true
             self.imgViewAddAddress.isHidden = true
             self.paymentView_H_Constraint.constant = 220
             self.btnAdd_Top_Constraint.constant = 60
             self.isVenueSelected = true
             return
         }
        
        if bool {
            imgViewHome.image = UIImage(named: "checkic")
            self.lbeAddress.text = ""
            self.lbeAddressTitle.text = ""
            self.btnAdd.isHidden = false
            self.imgViewAddAddress.isHidden = false
            self.imgViewHome.isHidden = false
            self.imgViewVenue.isHidden = false
            self.lbeHomeType.isHidden = false
            self.lbeVenueType.isHidden = false

            GetAddressAPI()
        }
        else{
            self.imgViewHome.isHidden = true
            self.imgViewVenue.isHidden = true
            self.lbeAddress.text = ""
            self.lbeAddressTitle.text = ""
            self.btnAdd.isHidden = true
            self.imgViewAddAddress.isHidden = true
            self.lbeHomeType.isHidden = true
            self.lbeVenueType.isHidden = true
            self.paymentView_H_Constraint.constant = 180
            self.btnAdd_Top_Constraint.constant = 20
        }
    }
    
    
    func myCartAPI(_ isLoader:Bool){
        var params = [ "availableService": "Active"
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus,totalAmount) in
            if isStatus {
                if arrayData != nil{
                    
                    lbePayNow.text = String(format: "Pay $%.2f", totalAmount)
                    if arrayData?.allCartServicesArray.count ?? 0 > 0 {
                    
                        if arrayService?.allServicesArray.count ?? 0 > 0 {
                            arrObjectServices = arrayService ?? arrObjectServices
                            payNow.isHidden = false
                            imgViewEm.isHidden = true
                            viewDataBG.isHidden = false

                            
                            tableViewMyCart.isHidden = false
                            arrSortedService = arrayService?.allServicesArray ?? arrSortedService
                            tableViewMyCart.reloadData()
                        }
                        else{
                            arrSortedService.removeAll()
                        }
                        
                        arrObject = arrayData ?? arrObject
                        payNow.isHidden = false
                        imgViewEm.isHidden = true
                        viewDataBG.isHidden = false

                        tableViewMyCart.isHidden = false
                        arrSortedProduct = arrayData?.allCartServicesArray ?? arrSortedProduct
                        tableViewMyCart.reloadData()
                        productAddCart(true)
                    }
                    else{
                        arrSortedProduct.removeAll()
                        productAddCart(false)

                        if arrayService?.allServicesArray.count ?? 0 > 0 {
                            
                            arrObjectServices = arrayService ?? arrObjectServices
                            payNow.isHidden = false
                            imgViewEm.isHidden = true
                            viewDataBG.isHidden = false

                            tableViewMyCart.isHidden = false
                            arrSortedService = arrayService?.allServicesArray ?? arrSortedService
                            tableViewMyCart.reloadData()
                            
                        }
                        else{
                            payNow.isHidden = true
                            imgViewEm.isHidden = false
                            viewDataBG.isHidden = true
                            tableViewMyCart.isHidden = true
                        }
                    }
                }
                    else{
                        payNow.isHidden = true
                        imgViewEm.isHidden = false
                        viewDataBG.isHidden = true
                        tableViewMyCart.isHidden = true
                    }
                }
                else{
                    payNow.isHidden = true
                    imgViewEm.isHidden = false
                    viewDataBG.isHidden = true
                    tableViewMyCart.isHidden = true
                }
            }
        }
    
    func GetAddressAPI(){

        GetAddressListRequest.shared.getLocationList(requestParams:[:], false) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                    self.arrayAddressData.removeAll()
                    self.arrayAddressData = arrayData ?? self.arrayAddressData
                    if self.arrayAddressData.count > 0 {
                       
                         DispatchQueue.main.async {
                             var status = 1000
                             
                             for i in 0..<self.arrayAddressData.count
                             {
                                 if self.arrayAddressData[i].status != 0 {
                                     status = i
                                 }
                             }
                             if self.arrayAddressData.count > status {
                                 
                                 self.lbeAddressTitle.text = "Delivering to " + self.arrayAddressData[status].addressType
                                 
                                 var stringN = ""
                                 if self.arrayAddressData[status].nearbyLandMark != "" {
                                     stringN  = ", " + self.arrayAddressData[status].nearbyLandMark
                                     if self.arrayAddressData[status].city != "" {
                                         stringN  =  stringN + ", " + self.arrayAddressData[status].city
                                     }
                                     if self.arrayAddressData[status].state != "" {
                                         stringN  =  stringN + ", " + self.arrayAddressData[status].state
                                     }
                                 }
                                 else{
                                     if self.arrayAddressData[status].city != "" {
                                         stringN  = ", " + self.arrayAddressData[status].city
                                     }
                                     if self.arrayAddressData[status].state != "" {
                                         stringN  =  stringN + ", " + self.arrayAddressData[status].state
                                     }
                                 }
                                 
                                 self.lbeAddress.text = self.arrayAddressData[status].houseNoOrBuildingName + ", " + self.arrayAddressData[status].streetAddresss + stringN
                                 
                                 
                                 
                                 var sizeFonts = CGFloat()
                                 sizeFonts  = self.lbeAddress.text?.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(13)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 65) ?? 20
                                 self.paymentView_H_Constraint.constant = 220 + sizeFonts
                                 if Utility.shared.DivceTypeString() == "IPad" {
                                     self.paymentView_H_Constraint.constant = 260 + sizeFonts
                                 }
                                 self.btnAdd_Top_Constraint.constant = 130
                             }
                             else{
                                 self.lbeAddressTitle.text = "Add Address"
                                 self.lbeAddress.text = ""
                                 self.paymentView_H_Constraint.constant = 250
                                 self.btnAdd_Top_Constraint.constant = 90

                             }
                        }
                    }
                    else{
                        self.lbeAddressTitle.text = "Add Address"
                        self.lbeAddress.text = ""
                        self.paymentView_H_Constraint.constant = 250
                        self.btnAdd_Top_Constraint.constant = 90
                        self.arrayAddressData.removeAll()
                    }
               
                    }
                }
            }
        }
    }


extension CartUserViewController: UITableViewDataSource,UITableViewDelegate {
   

      func numberOfSections(in tableView: UITableView) -> Int {
          return 4
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
          
          if section == 2 {
              return arrSortedProduct.count
          }
          
          if section == 0 {
              return arrSortedService.count
          }
          
          return 1

      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          
          if indexPath.section == 2 {
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "MyCartTableViewCell") as! MyCartTableViewCell
          
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
          else if indexPath.section == 3{
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "BillDetailsTvCell") as! BillDetailsTvCell
              if arrObject != nil {
                  cell.lbetotalSellingPrice.text = String(format: "$%.2f", self.arrObject?.totalSellingPrice ?? 0.00)
                  
                  cell.lbetotalDiscountAmount.text = String(format: "%.2f", self.arrObject?.totalDiscount ?? 0.00)
                  
                  cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrObject?.totalDiscountAmount ?? 0.00)
                  
                  cell.lbetotalMrp.text = String(format: "$%.2f", self.arrObject?.totalMrp ?? 0.00)
              }
              return cell
          }
          else if indexPath.section == 0{
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "CartServicesTvCell") as! CartServicesTvCell
              
              if arrSortedService[indexPath.row].serviceCountInCart == 0 {
                  cell.addView.isHidden = false

              }
              else{
                  cell.addView.isHidden = true

              }
              
             // cell.addToCart.tag = indexPath.row
            //  cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
              
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
          else{
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "CartServicesBillTvCell") as! CartServicesBillTvCell
              if arrObjectServices != nil {
                  cell.lbetotalSellingPrice.text = String(format: "$%.2f", self.arrObjectServices?.totalSellingPrice ?? 0.00)
                  
                  cell.lbetotalDiscountAmount.text = String(format: "%.2f", self.arrObjectServices?.totalDiscount ?? 0.00)
                  
                  cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrObjectServices?.totalDiscountAmount ?? 0.00)
                  
                  cell.lbetotalMrp.text = String(format: "$%.2f", self.arrObjectServices?.totalMrp ?? 0.00)
                  
                  
              }
              return cell
          }
          
      }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          if indexPath.section == 0 {
              if Utility.shared.DivceTypeString() == "IPad" {
                  return  210
              }
              
              let lineCount = arrSortedService[indexPath.row].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 174)
              
              if lineCount > 1 {
                  if self.arrSortedService[indexPath.row].fromTime == "" {
                      return  190
                  }
                  return  210

              }
              if self.arrSortedService[indexPath.row].fromTime == "" {
                  return  160

              }
              return  180
          }
          else if indexPath.section == 1 {
              if self.arrSortedService.count > 0{
                  return  140
               }
               return  0
          }
          
          if indexPath.section == 2 {
              if Utility.shared.DivceTypeString() == "IPad" {
                  return  210
              }
              return  150
          }
          else if indexPath.section == 3 {
              if self.arrSortedProduct.count > 0{
                  return  140
               }
               return  0
          }
          return  0
      }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if self.arrSortedService.count > 0{
                return 32
                
            }
            return 0.1
        case 2:
            if self.arrSortedProduct.count > 0{
                return 45
                
            }
            return 0.1
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView {
        case tableViewMyCart:
            let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "DashSectionTableViewCell") as! DashSectionTableViewCell
            switch section {
            case 0:
                cell.titleLabel.text = "Severcies"
                
            case 2:
                cell.titleLabel.text = "Products"
            default:
                return nil
            }
            return cell
    
        default:
            return nil
        }
    }



      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
   
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
        
        self.tableViewMyCart.reloadData()
        
        var param = [String : AnyObject]()
        param["productId"] = arrSortedProduct[sender.tag].productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
        arrSortedProduct[sender.tag].productCountInCart = arrSortedProduct[sender.tag].productCountInCart - 1
        itemCount = arrSortedProduct[sender.tag].productCountInCart
        self.tableViewMyCart.reloadData()
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
        AddOrUpdateProductInCartRequest.shared.addProductAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    self.myCartAPI(false)
                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
    }
    
    
    //MARK:- Add Button Tap
    @objc func btnAddTap(sender:UIButton){
        

        arrSortedService[sender.tag].serviceCountInCart = 1
        self.tableViewMyCart.reloadData()
        
        itemCount = 1
        var param = [String : AnyObject]()
        param["spaServiceId"] = arrSortedService[sender.tag].spaServiceId as AnyObject
        param["spaDetailId"] = 21 as AnyObject
        param["serviceCountInCart"] = 1 as AnyObject
        param["slotId"] = 0 as AnyObject

        
        self.addUpdateService(Model: param, index:sender.tag)
        
    }
    
    @objc func btnremoveCartTap(sender:UIButton){
    
        arrSortedService[sender.tag].serviceCountInCart = 0
        self.tableViewMyCart.reloadData()
        
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
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    
    
    
    func addUpdateService(Model: [String : AnyObject], index:Int){
        AddUpdateCartServiceRequest.shared.AddUpdateCartServiceAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
            self.myCartAPI(false)
        }
    }
    
}

