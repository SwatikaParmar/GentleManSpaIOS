//
//  EditAddressVc.swift
//  SalonApp
//
//  Created by mac on 31/08/23.
//

import UIKit
import CocoaTextField

class EditAddressVc: UIViewController {
    
    
    @IBOutlet weak var reciverNameTF: CocoaTextField!
    @IBOutlet weak var phoneNoTF: CocoaTextField!
    @IBOutlet weak var pincodeTF: CocoaTextField!
    @IBOutlet weak var houseNoTF: CocoaTextField!
    @IBOutlet weak var streetAddressTF: CocoaTextField!
    @IBOutlet weak var nearbyTF: CocoaTextField!
    @IBOutlet weak var alternatTF: CocoaTextField!
    
    @IBOutlet weak var lbeAddress: UILabel!
    @IBOutlet weak var lbeAddress1: UILabel!
    
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewWork: UIView!
    @IBOutlet weak var viewOther: UIView!
    
    @IBOutlet weak var lbeHome: UILabel!
    @IBOutlet weak var lbeWork: UILabel!
    @IBOutlet weak var lbeOther: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lbeTitle: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var l_TConstraints: NSLayoutConstraint!
    @IBOutlet weak var t_TConstraints: NSLayoutConstraint!
    
    var arrayAddressData = [AddressListModel]()
    
    var  lines = ""
    var  thoroughfare = ""
    var  subLocality = ""
    var  locality = ""
    var  administrativeArea = ""
    var  postalCode = ""
    var  latitude = ""
    var  longitude = ""
    
    var addressType = "Home"
    
    var idType1 = 0
    var idType2 = 0
    var idType3 = 0
    
    var apiUpdate = ""
    var apiUpdateID = 0
    var setPrimary = false
    var customerAddressId_Primary = 0
    
    
    @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
    func topViewLayout(){
        if !CreateAccountController.hasSafeArea{
            if navigationViewConstraint != nil {
                navigationViewConstraint.constant = 77
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utility.shared.DivceTypeString() == "IPad" {
            l_TConstraints.constant = 100
            t_TConstraints.constant = 100
        }
        btnAdd.backgroundColor = AppColor.BrownColor
        
        topViewLayout()
        OnKeyboard()
        setDataForType()
        GetAddressAPI(true)
        setUI()
    }
    
    
    func OnKeyboard()
    {
        phoneNoTF.keyboardType = .numberPad
        alternatTF.keyboardType = .numberPad
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneNoTF.inputAccessoryView = doneToolbar
        alternatTF.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        phoneNoTF.resignFirstResponder()
        alternatTF.resignFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    func setDataForType(){
        if addressType == "Home"{
            viewHome.layer.borderColor = AppColor.AppThemeColorCG
            viewHome.layer.borderWidth = 2
            lbeHome.textColor = AppColor.BrownColor
            
            viewWork.layer.borderColor = UIColor.black.cgColor
            lbeWork.textColor = UIColor.black
            
            viewOther.layer.borderColor = UIColor.black.cgColor
            lbeOther.textColor = UIColor.black
            
            viewWork.layer.borderWidth = 1
            viewOther.layer.borderWidth = 1
            
            
        }else if addressType == "Work"{
            viewWork.layer.borderColor = AppColor.AppThemeColorCG
            viewWork.layer.borderWidth = 2
            lbeWork.textColor = AppColor.BrownColor
            
            viewHome.layer.borderColor = UIColor.black.cgColor
            lbeHome.textColor = UIColor.black
            
            viewOther.layer.borderColor = UIColor.black.cgColor
            lbeOther.textColor = UIColor.black
            
            viewHome.layer.borderWidth = 1
            viewOther.layer.borderWidth = 1
        }
        else{
            viewOther.layer.borderColor = AppColor.AppThemeColorCG
            viewOther.layer.borderWidth = 2
            lbeOther.textColor = AppColor.BrownColor
            
            viewHome.layer.borderColor = UIColor.black.cgColor
            lbeHome.textColor = UIColor.black
            
            viewWork.layer.borderColor = UIColor.black.cgColor
            lbeWork.textColor = UIColor.black
            
            viewWork.layer.borderWidth = 1
            viewHome.layer.borderWidth = 1
        }
        
        
        if apiUpdate == "" {
            
            self.btnAdd.setTitle("Add", for: .normal)
            self.lbeTitle.text = "Add Address"
            
        }
        else{
            self.btnAdd.setTitle("Update", for: .normal)
            self.lbeTitle.text = "Update Address"
            
        }
    }
    
    
    func setUI(){
        
       
        
        
        reciverNameTF.placeholder = "Receiver's Name*"
        phoneNoTF.placeholder = "Receiver's Phone No*"
        houseNoTF.placeholder = "House/Flat/Block No.*"
        pincodeTF.placeholder = "Pin Code"
        streetAddressTF.placeholder = "Street Address*"
        nearbyTF.placeholder = "Nearby Landmark"
        alternatTF.placeholder = "Alternate Phone No"
        
        applyStyle(to: reciverNameTF)
        applyStyle(to: pincodeTF)
        applyStyle(to: phoneNoTF)
        applyStyle(to: houseNoTF)
        applyStyle(to: streetAddressTF)
        applyStyle(to: nearbyTF)
        applyStyle(to: alternatTF)
        
        lbeAddress.text =  lines
        
        houseNoTF.text =  thoroughfare
        streetAddressTF.text = subLocality
        pincodeTF.text =  postalCode
        
        
    }
    
//    func applyStyle(to v: CocoaTextField) {
//        
//        v.tintColor = .gray
//        v.textColor = UIColor.black
//        v.inactiveHintColor = .gray
//        v.activeHintColor = .gray
//        v.focusedBackgroundColor = UIColor.white
//        v.defaultBackgroundColor = UIColor.white
//        v.borderColor = UIColor.clear
//        v.errorColor = .gray
//        v.font = UIFont(name:FontName.Inter.Regular, size:  "".dynamicFontSize(16))
//    }
    
    func setDataPrimary() {
        if setPrimary  {
            if customerAddressId_Primary > 0 {
                
                var param = [String : AnyObject]()
                param["customerAddressId"] =  customerAddressId_Primary  as AnyObject
                param["status"] = true as AnyObject
                
                SetCustomerAddressRequest.shared.SetCustomerAddressAPI(requestParams: param) { (user,message,isStatus) in
                    if isStatus {
                        self.setPrimary = false
                        self.goToScreen()
                    }
                }
            }
        }
    }
    
    func goToScreen() {
        if let viewControllers = self.navigationController?.viewControllers {
            
            var isPop = false
            
            for viewController in viewControllers {
                //                if viewController.isKind(of: CheckoutController.self) {
                //                    self.navigationController?.popToViewController(viewController, animated: true)
                //                    isPop = true
                //                    break
                //
                //                }
            }
            
            if !isPop {
                //                for viewController in viewControllers {
                //                    if viewController.isKind(of: MyAddressesVc.self) {
                //                        self.navigationController?.popToViewController(viewController, animated: true)
                //                        isPop = true
                //                        break
                //                    }
                //                }
            }
            
            if !isPop {
                for viewController in viewControllers {
                    if viewController.isKind(of: HomeViewController.self) {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        break
                    }
                }
                
            }
        }
    }
    
    func goToScreenList() {
        if let viewControllers = self.navigationController?.viewControllers {
            var isPop = false
            for viewController in viewControllers {
                //                if viewController.isKind(of: MyAddressesVc.self) {
                //                    self.navigationController?.popToViewController(viewController, animated: true)
                //                    isPop = true
                //                    break
                //                }
            }
            
            if !isPop {
                for viewController in viewControllers {
                    //                    if viewController.isKind(of: CustomTabBarVC.self) {
                    //                        self.navigationController?.popToViewController(viewController, animated: true)
                    //                        isPop = true
                    //
                    //                        break
                    //                    }
                }
                
            }
            
            if !isPop {
                for viewController in viewControllers {
                    if viewController.isKind(of: HomeViewController.self) {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        break
                    }
                }
                
            }
        }
    }
 
    @IBAction func Back(_ sender: Any) {
        
        if setPrimary  {
            if customerAddressId_Primary > 0 {
                var param = [String : AnyObject]()
                param["customerAddressId"] =  customerAddressId_Primary  as AnyObject
                param["status"] = true as AnyObject
                
                SetCustomerAddressRequest.shared.SetCustomerAddressAPI(requestParams: param) { (user,message,isStatus) in
                    if isStatus {
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
            else{
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func Home(_ sender: Any) {
        
        viewHome.layer.borderColor = AppColor.AppThemeColorCG
        viewHome.layer.borderWidth = 2
        lbeHome.textColor = AppColor.BrownColor
        
        viewWork.layer.borderColor = UIColor.black.cgColor
        lbeWork.textColor = UIColor.black
        
        viewOther.layer.borderColor = UIColor.black.cgColor
        lbeOther.textColor = UIColor.black
        
        viewWork.layer.borderWidth = 1
        viewOther.layer.borderWidth = 1
        addressType = "Home"
        
        if self.idType1 != 0 {
            apiUpdate = "Home"
            apiUpdateID = self.idType1
            self.btnAdd.setTitle("Update", for: .normal)
            self.lbeTitle.text = "Update Address"
            
            
            
        }
        else{
            apiUpdate = ""
            self.btnAdd.setTitle("Add", for: .normal)
            self.lbeTitle.text = "Add Address"
            
            
        }
    }
    
    @IBAction func Work(_ sender: Any) {
        viewWork.layer.borderColor = AppColor.AppThemeColorCG
        viewWork.layer.borderWidth = 2
        lbeWork.textColor = AppColor.BrownColor
        
        viewHome.layer.borderColor = UIColor.black.cgColor
        lbeHome.textColor = UIColor.black
        
        viewOther.layer.borderColor = UIColor.black.cgColor
        lbeOther.textColor = UIColor.black
        
        viewHome.layer.borderWidth = 1
        viewOther.layer.borderWidth = 1
        
        addressType = "Work"
        if self.idType2 != 0 {
            apiUpdate = "Work"
            apiUpdateID = self.idType2
            self.btnAdd.setTitle("Update", for: .normal)
            self.lbeTitle.text = "Update Address"
        }
        else{
            apiUpdate = ""
            self.btnAdd.setTitle("Add", for: .normal)
            self.lbeTitle.text = "Add Address"
        }
    }
    
    @IBAction func Other(_ sender: Any) {
        
        viewOther.layer.borderColor = AppColor.AppThemeColorCG
        viewOther.layer.borderWidth = 2
        lbeOther.textColor = AppColor.BrownColor
        
        viewHome.layer.borderColor = UIColor.black.cgColor
        lbeHome.textColor = UIColor.black
        
        viewWork.layer.borderColor = UIColor.black.cgColor
        lbeWork.textColor = UIColor.black
        
        viewWork.layer.borderWidth = 1
        viewHome.layer.borderWidth = 1
        addressType = "Other"
        
        if self.idType3 != 0 {
            apiUpdate = "Other"
            apiUpdateID = self.idType3
            self.btnAdd.setTitle("Update", for: .normal)
            self.lbeTitle.text = "Update Address"
            
            
            
        }
        else{
            apiUpdate = ""
            self.btnAdd.setTitle("Add", for: .normal)
            self.lbeTitle.text = "Add Address"
        }
    }
    
    @IBAction func Update(_ sender: Any) {
        
        self.view.endEditing(true)
        
        var strPhone = ""
        strPhone = phoneNoTF.text ?? ""
        
        if reciverNameTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter Receiver's name")
            return
        }
        if phoneNoTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter Receiver's phone number")
            return
        }
        else if !strPhone.isValidPhoneNumber(){
            NotificationAlert().NotificationAlert(titles: "Please enter valid Receiver's phone number")
            return
        }
        else if phoneNoTF.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 10 {
            NotificationAlert().NotificationAlert(titles: "Please enter valid Receiver's phone number")
            return
        }
        else if phoneNoTF.text?.trimmingCharacters(in: .whitespaces).count ?? 0 > 10 {
            NotificationAlert().NotificationAlert(titles: "Please enter valid Receiver's phone number")
            return
        }
        
        if houseNoTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter House/Flat/Block number")
            return
        }
        
        if streetAddressTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter street addresss")
            return
        }
        
        if alternatTF.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            
            
        }
        else{
            
            var strPhone = ""
            strPhone = alternatTF.text ?? ""
            
            if !strPhone.isValidPhoneNumber(){
                NotificationAlert().NotificationAlert(titles: "Please enter valid alternate phone number")
                return
            }
            
            if alternatTF.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 10 {
                NotificationAlert().NotificationAlert(titles: "Please enter valid alternate phone number")
                return
            }
            else if alternatTF.text?.trimmingCharacters(in: .whitespaces).count ?? 0 > 10 {
                NotificationAlert().NotificationAlert(titles: "Please enter valid alternate phone number")
                return
            }
            
        }
        
        var param = [String : AnyObject]()
        param["fullName"] =  reciverNameTF.text as AnyObject
        param["phoneNumber"] =  phoneNoTF.text as AnyObject
        param["alternatePhoneNumber"] = alternatTF.text as AnyObject
        param["pincode"] = pincodeTF.text as AnyObject
        param["state"] = administrativeArea as AnyObject
        param["city"] =  self.locality as AnyObject
        param["houseNoOrBuildingName"] = houseNoTF.text as AnyObject
        param["streetAddresss"] = streetAddressTF.text as AnyObject
        param["nearbyLandMark"] = nearbyTF.text as AnyObject
        param["addressType"] =  addressType as  AnyObject
        param["addressLatitude"] =  latitude as AnyObject
        param["addressLongitude"] = longitude  as AnyObject
        
        if apiUpdate == "" {
            AddCustomerAddressRequest.shared.addAddressAPI(requestParams: param) { (user,message,isStatus) in
                if isStatus {
                    if user?.customerAddressId ?? 0 > 0 {
                        self.customerAddressId_Primary = user?.customerAddressId ?? 0
                        NotificationAlert().NotificationAlert(titles: "Address added successfully.")
                        
                        self.setDataPrimary()
                        
                    }
                }
            }
        }
        else{
            param["customerAddressId"] = apiUpdateID  as AnyObject
            
            UpdateCustomerAddressRequest.shared.updateAddressAPI(requestParams: param) { (user,message,isStatus) in
                if isStatus {
                    
                    self.goToScreenList()
                    
                    
                }
            }
        }
    }
    
    
    func GetAddressAPI(_ isLoader : Bool){
        GetAddressListRequest.shared.getLocationList(requestParams:[:], isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    if arrayData?.count ?? 0 > 0 {
                        self.setPrimary = false
                        self.arrayAddressData.removeAll()
                        self.arrayAddressData = arrayData!
                        DispatchQueue.main.async {
                            
                            for i in 0..<self.arrayAddressData.count
                            {
                                
                                if self.arrayAddressData[i].addressType == "Home" {
                                    
                                    self.idType1 =  self.arrayAddressData[i].customerAddressId
                                    
                                }
                                
                                if self.arrayAddressData[i].addressType == "Work" {
                                    
                                    self.idType2 =  self.arrayAddressData[i].customerAddressId
                                    
                                }
                                
                                if self.arrayAddressData[i].addressType == "Other" {
                                    
                                    self.idType3 =  self.arrayAddressData[i].customerAddressId
                                    
                                }
                            }
                        }
                    }
                    else{
                        self.setPrimary = true
                    }
                    
                }
            }
        }
    }
}

extension EditAddressVc: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " "  {
               return false
           }
        if string == ""{
            return true
        }
        if textField.text == "" && string == " "{
            return false
        }
        if textField == phoneNoTF {
           if textField.text?.count ?? 0 > 9{
               return false
           }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
}
