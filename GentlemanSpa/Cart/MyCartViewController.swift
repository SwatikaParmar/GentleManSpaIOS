//
//  MyCartViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/10/24.
//

import UIKit

class MyCartViewController: UIViewController {
    @IBOutlet weak var tableViewMyCart : UITableView!
   

    @IBOutlet weak var viewPayNow : UIView!
    @IBOutlet weak var imgViewEmpty : UIImageView!
    @IBOutlet weak var lbePayNow: UILabel!
    @IBOutlet weak var viewPaymentMode: UIView!
    @IBOutlet weak var effectPaymentMode: UIVisualEffectView!
    
    @IBOutlet weak var imgOnline : UIImageView!
    @IBOutlet weak var imgAtVenue : UIImageView!


    var itemCount = 0
    var isAddressSelected = "Home"
    var strAddress = ""
    var strAddressType = ""
    var isOnlinePaymentSelected = true

    var arrObject : CartDataModel?
    var arrSortedProduct = [AllCartProducts]()
    var arrObjectServices : cartServicesDataModel?
    var arrSortedService = [AllCartServices]()
    var arrayAddressData = [AddressListModel]()
    
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
        
        viewPaymentMode.isHidden = true
        effectPaymentMode.isHidden = true

        
        viewPayNow.isHidden = true
        imgViewEmpty.isHidden = true
        tableViewMyCart.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.Table_Refresh_Data), name: NSNotification.Name(rawValue: "Table_Refresh"), object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        myCartAPI(true)
        GetAddressAPI()
    }
    @objc func Table_Refresh_Data(_ notification: NSNotification) {
        myCartAPI(true)
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PlaceOrder(_ sender: Any) {
        
        if self.isAddressSelected == "Home" {
            if self.strAddress == "" {
                NotificationAlert().NotificationAlert(titles:"Please add your address")
                return
            }
        }
        
        imgOnline.image = UIImage(named: "paymentRadioS")
        imgAtVenue.image = UIImage(named: "paymentRadioUn")
        isOnlinePaymentSelected = true

        viewPaymentMode.isHidden = false
        effectPaymentMode.isHidden = false
    }
    
    @IBAction func OnlinePlaceOrder(_ sender: Any) {
        imgOnline.image = UIImage(named: "paymentRadioS")
        imgAtVenue.image = UIImage(named: "paymentRadioUn")
        isOnlinePaymentSelected = true
        
    }
    
    @IBAction func AtVPlaceOrder(_ sender: Any) {
        imgOnline.image = UIImage(named: "paymentRadioUn")
        imgAtVenue.image = UIImage(named: "paymentRadioS")
        isOnlinePaymentSelected = false
        
    }
    
    @IBAction func PayBy(_ sender: Any) {
        
        viewPaymentMode.isHidden = true
        effectPaymentMode.isHidden = true
        
        if isOnlinePaymentSelected {
            OnlinePayments()
        }
        else{
            CashBookingAPI()
        }
        
    }
    @IBAction func PayByCancel(_ sender: Any) {
        viewPaymentMode.isHidden = true
        effectPaymentMode.isHidden = true
        
    }
    
    
    
    @IBAction func Home(_ sender: Any) {
    
        self.isAddressSelected = "Home"
        GetAddressAPI()
        self.tableViewMyCart.reloadData()
    }
    
    @IBAction func Venue(_ sender: Any) {
 
        self.isAddressSelected = "Venue"
        self.strAddress = ""
        self.tableViewMyCart.reloadData()
    }
    
    @IBAction func AddAddress(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "Address", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "MyLocationVc") as?  MyLocationVc)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func OnlinePayments() {

       let Model = [
        "currentUserId": userId()] as [String : Any]
 
        PayByStripeRequest.shared.PayByStripeAmountAPI(requestParams: Model) { (url,id,message,isStatus) in
               if isStatus {
                   let controller:PaymentViewController =  UIStoryboard(storyboard: .Cart).initVC()
                   controller.paymentUrl = url ?? ""
                   controller.paymentId = id ?? 0
                   self.navigationController?.pushViewController(controller, animated: true)

               }
           }
       }
    
    
    func CashBookingAPI() {

       let Model = [
           "customerAddressId": 0,
           "deliveryType": "AtVenue",
           "paymentId": 0,
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
    

    
    
    func myCartAPI(_ isLoader:Bool){
        var params = [ "availableService": "Active"
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus,totalAmount) in
            if isStatus {
                if arrayData != nil{
                    
                    lbePayNow.text = String(format: "Pay $%.2f", totalAmount)
                    if arrayData?.allCartProductArray.count ?? 0 > 0 {
                    
                        if arrayService?.allServicesArray.count ?? 0 > 0 {
                            arrObjectServices = arrayService ?? arrObjectServices
                            viewPayNow.isHidden = false
                            imgViewEmpty.isHidden = true

            
                            tableViewMyCart.isHidden = false
                            arrSortedService = arrayService?.allServicesArray ?? arrSortedService
                            tableViewMyCart.reloadData()
                        }
                        else{
                            arrSortedService.removeAll()
                        }
                        
                        arrObject = arrayData ?? arrObject
                        
                        viewPayNow.isHidden = false
                        imgViewEmpty.isHidden = true
                        tableViewMyCart.isHidden = false
                        
                        arrSortedProduct = arrayData?.allCartProductArray ?? arrSortedProduct
                        tableViewMyCart.reloadData()
                        
                        if isAddressSelected == "Venue"{
                            isAddressSelected = "Venue"
                        }
                        else{
                            isAddressSelected = "Home"
                        }
                    }
                    else{
                        arrSortedProduct.removeAll()
                        isAddressSelected = "Other"

                        if arrayService?.allServicesArray.count ?? 0 > 0 {
                            
                            arrObjectServices = arrayService ?? arrObjectServices
                            
                            viewPayNow.isHidden = false
                            imgViewEmpty.isHidden = true
                            tableViewMyCart.isHidden = false
                            
                            arrSortedService = arrayService?.allServicesArray ?? arrSortedService
                            tableViewMyCart.reloadData()
                            
                        }
                        else{
                            imgViewEmpty.isHidden = false
                            tableViewMyCart.isHidden = true
                            viewPayNow.isHidden = true

                        }
                    }
                }
                    else{
                        imgViewEmpty.isHidden = false
                        tableViewMyCart.isHidden = true
                        viewPayNow.isHidden = true

                    }
                }
                else{
                    imgViewEmpty.isHidden = false
                    tableViewMyCart.isHidden = true
                    viewPayNow.isHidden = true
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
                                 
                                 self.strAddressType = "Delivering to " + self.arrayAddressData[status].addressType
                                 
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
                                 
                                 self.strAddress = self.arrayAddressData[status].houseNoOrBuildingName + ", " + self.arrayAddressData[status].streetAddresss + stringN
                                 self.tableViewMyCart.reloadData()
                           
                             }
                             else{
                                 self.strAddressType = "Add Address"
                                 self.strAddress = ""
                                 self.tableViewMyCart.reloadData()

                             }
                        }
                    }
                    else{
                        self.strAddressType = "Add Address"
                        self.strAddress = ""
                        self.tableViewMyCart.reloadData()
                        self.arrayAddressData.removeAll()
                    }
               
                    }
                else{
                    self.strAddressType = "Add Address"
                    self.strAddress = ""
                    self.tableViewMyCart.reloadData()
                    self.arrayAddressData.removeAll()
                }
                }
            else{
                self.strAddressType = "Add Address"
                self.strAddress = ""
                self.tableViewMyCart.reloadData()
                self.arrayAddressData.removeAll()
            }
            }
        }
   
}
