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

    var itemCount = 0
    var isAddressSelected = "Home"
    var strAddress = ""
    var strAddressType = ""

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
        bookingAPI()
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
                }
            }
        }
   
}
