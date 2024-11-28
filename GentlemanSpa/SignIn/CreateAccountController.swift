//
//  CreateAccountController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/07/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
class CreateAccountController: UIViewController {
    
    @IBOutlet weak var txt_First : CocoaTextField!
    @IBOutlet weak var txt_Last : CocoaTextField!
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Password : CocoaTextField!
    @IBOutlet weak var txt_ConfirmPass : CocoaTextField!
    @IBOutlet weak var txt_Email : CocoaTextField!
    @IBOutlet weak var txt_Gender : CocoaTextField!
    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var imgUserProfile : UIImageView!

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    @IBOutlet weak var countryPicker: CountryPickerView!

    var trimmedName = ""
    var trimmedlast = ""
    var trimmedEmailName = ""
    var trimmedPassword = ""
    var trimmedPhone = ""
  
    var phoneCode = ""
    var imgProfile : UIImage?

    var stringPhoneNo = ""
    var stringEmail = ""
    let dropGender = DropDown()
    var genderStr = "Male"
    var imgIS = false
    var eyeClick = true
    var eyeClickC = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEye()
        setupDropDowns()

        self.countryPicker.font = UIFont(name: FontName.Inter.Regular, size: 14)!
        self.countryPicker.delegate = self
        self.phoneCode = "+91"
        countryPicker.setCountryByCode("IN")
        countryPicker.showCountryCodeInView = false
        
        applyStyle(to: txt_First)
        txt_First.placeholder = "First Name"
        txt_First.keyboardType = .emailAddress
        
        applyStyle(to: txt_Last)
        txt_Last.placeholder = "Last Name"
        
        applyStyle(to: txt_Gender)
        txt_Gender.placeholder = "Select Gender"
        
        applyStyle(to: txt_Phone)
        txt_Phone.placeholder = "Phone No"
        
        
        applyStyle(to: txt_Email)
        txt_Email.placeholder = "Email"
        
        applyStyle(to: txt_Password)
        txt_Password.placeholder = "Password"
        
        applyStyle(to: txt_ConfirmPass)
        txt_ConfirmPass.placeholder = "Confirm Password"
        
        topViewLayout()
    }
    
    func topViewLayout(){
        if !CreateAccountController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 77
            }
        }
    }
    
    
    
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view .endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupDropDowns() {
        
        let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat(16)) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor =  UIColor.white
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont =  actionTitleFont
        setupGenderDropDown()
    }
    
    
    func setupGenderDropDown() {
        dropGender.anchorView = btn_Gender
        dropGender.bottomOffset = CGPoint(x: 5, y: btn_Gender.bounds.height - 10)
        dropGender.direction = .bottom

        dropGender.dataSource = [
            "Male",
            "Female",
            "Other"
            ]
        
        dropGender.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                self!.genderStr = "Male"
            }
            else if (index == 1){
                 self!.genderStr = "Female"
            }
            else{
                self!.genderStr = "Other"
            }
            self!.txt_Gender.text = item
        }
    }
    
    
    func addEye() {
        txt_Password.isSecureTextEntry = true

        let buttonNew = UIButton(type: .custom)
        buttonNew.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
        buttonNew.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNew.frame = CGRect(x: CGFloat(txt_Password.frame.size.width - 35), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
        buttonNew.addTarget(self, action: #selector(self.eyePassword), for: .touchUpInside)
        txt_Password.rightView = buttonNew
        txt_Password.rightViewMode = .always
        
        txt_ConfirmPass.isSecureTextEntry = true

        let buttonNewC = UIButton(type: .custom)
        buttonNewC.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
        buttonNewC.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNewC.frame = CGRect(x: CGFloat(txt_ConfirmPass.frame.size.width - 35), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
        buttonNewC.addTarget(self, action: #selector(self.eyePassword1), for: .touchUpInside)
        txt_ConfirmPass.rightView = buttonNewC
        txt_ConfirmPass.rightViewMode = .always
    }
    
    @IBAction func eyePassword(_ sender: UIButton) {
        if(eyeClick == true) {
            sender.setImage(UIImage(named: "eyes_ic"), for: .normal)
            txt_Password.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
            txt_Password.isSecureTextEntry = true
        }
        eyeClick = !eyeClick
    }
    
    @IBAction func eyePassword1(_ sender: UIButton) {
        if(eyeClickC == true) {
            sender.setImage(UIImage(named: "eyes_ic"), for: .normal)
            txt_ConfirmPass.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
            txt_ConfirmPass.isSecureTextEntry = true
        }
        eyeClickC = !eyeClickC
    }
    
    
    @IBAction func btnUserProfilePressed(_ sender: Any){
        self.view.endEditing(true)

        addImage(sender as! UIButton)
    }
    
    
    
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
        dropGender.show()
    }
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        self.view.endEditing(true)
        trimmedName = txt_First.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedlast = txt_Last.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedEmailName = txt_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedPassword = txt_Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedPhone = txt_Phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
      let  trimmedCPassword = txt_ConfirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if (trimmedName.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter first name")
            return
        }
        
        if (trimmedlast.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter last name")
            return
        }
        
        if (trimmedEmailName.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter email")
            return
        }
        
        if trimmedEmailName.isValidEmail() {
        }
        else{
            MessageAlert(title:"Alert",message: "Please enter valid email address")
            return
        }
        
        if (trimmedPhone.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter phone no")
            return
        }
        
        if trimmedPhone.count < 9 {
            MessageAlert(title:"Alert",message: "Please Enter valid phone number")
            return
        }
        
        if (trimmedPassword.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter password")
            return
        }
        
        
        if trimmedPassword.count < 6{
            MessageAlert(title:"Alert",message: "Password should be 6 characters or more")
            return
        }
        else if trimmedCPassword.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter confirm password")
            return
        }
        else  if (trimmedPassword.trimmingCharacters(in: .whitespaces)) != (trimmedCPassword.trimmingCharacters(in: .whitespaces)){
           
            NotificationAlert().NotificationAlert(titles: "Password not match")
            return
        }
        
        
        
        stringPhoneNo = trimmedPhone
        stringEmail = trimmedEmailName
        let paramsEmail = ["phoneNumber":self.trimmedPhone
                           , "dialCode": phoneCode] as [String : Any]
        self.callResendPhoneApi(param: paramsEmail)
        
    }
    
    //MARK:-  Resend OTP on Email
    func callResendEmailApi(param : [String : Any]){
        
        ResendEmailAPIRequest.shared.ResendEmail(requestParams: param, accessToken:"") { (message, status,otp) in
            
            if status == true{
                let controller:VerifiyController = UIStoryboard(storyboard: .main).initVC()
                controller.codeStr = String(otp)
                controller.email = self.stringEmail
                controller.trimmedName = self.trimmedName
                controller.trimmedlast = self.trimmedlast
                controller.trimmedPassword = self.trimmedPassword
                controller.stringPhoneNo = self.stringPhoneNo
                controller.stringEmail = self.stringEmail
                controller.phoneCode = self.phoneCode
                controller.stringGender = self.genderStr
                controller.img = self.imgProfile ?? UIImage()
                controller.imgIS = self.imgIS
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
            else
            {
                self.MessageAlert(title: "", message: message!)
            }
        }
    }
    
    
    //MARK:-  Resend OTP on Email
    func callResendPhoneApi(param : [String : Any]){
        
        IsPhoneUniqueAPIRequest.shared.IsPhoneUniqueEmail(requestParams: param, accessToken:"") { (message, status,otp) in
            
            if status == true{
                let paramsEmail = ["email":self.stringEmail
                                   , "isVerify": true] as [String : Any]
                self.callResendEmailApi(param: paramsEmail)
                
            }
            else
            {
                self.MessageAlert(title: "", message: message!)
            }
        }
    }
    
    
}
extension CreateAccountController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        phoneCode = country.phoneCode
        print(message)
    }
}
extension CreateAccountController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func addImage(_ sender: UIButton){
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let takePic = UIAlertAction(title: "Take Photo", style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraAccess()
        })
        let choseAction = UIAlertAction(title: "Choose from Library",style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPickerController.modalPresentationStyle = .fullScreen
            self.present(myPickerController, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePic)
        optionMenu.addAction(choseAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            print("Authorized, proceed")
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerController.SourceType.camera
                myPickerController.modalPresentationStyle = .fullScreen
                myPickerController.showsCameraControls = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = UIImagePickerController.SourceType.camera
                        myPickerController.modalPresentationStyle = .fullScreen
                        myPickerController.showsCameraControls = true
                        self.present(myPickerController, animated: true, completion: nil)
                    }
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            }
        default:
            self.alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        
        let alert = UIAlertController(
            title: "Alert",
            message: "App requires to access your camera to capture image on your business profile and service.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage else { return }
        
        self.imgProfile = originalImage
        imgUserProfile.image = originalImage
        imgUserProfile.layer.borderWidth = 1
        imgUserProfile.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.clipsToBounds = true
        imgIS = true
        
       // self.uploadProfileImageApi()

        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
extension CreateAccountController: UITextFieldDelegate {
    
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
      
        if textField.text?.count ?? 0 > 100{
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
}
