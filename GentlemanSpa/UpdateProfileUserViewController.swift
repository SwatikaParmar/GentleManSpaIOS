//
//  UpdateProfileUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
class UpdateProfileUserViewController: UIViewController {
    @IBOutlet weak var txt_First : CocoaTextField!
    @IBOutlet weak var txt_Last : CocoaTextField!
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Email : CocoaTextField!
    @IBOutlet weak var txt_Gender : CocoaTextField!
    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var txt_Client : CocoaTextField!

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var lbeSpe : UILabel!
    @IBOutlet weak var imgUserProfile : UIImageView!

    

    @IBOutlet weak var specialityConst: NSLayoutConstraint!

    let dropGender = DropDown()
    var genderStr = "Male"
    var trimmedName = ""
    var trimmedlast = ""
    var trimmedEmailName = ""
    var trimmedPassword = ""
    var trimmedPhone = ""
    var eyeClick = true
    var phoneCode = ""
    var imgProfile : UIImage?

    var stringPhoneNo = ""
    var stringEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        applyStyle(to: txt_Client)
        txt_Client.placeholder = "Membership Level"
        
        txt_Client.text = "VIP Clients"
        getProfileAPI()
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.Category_Push_Action(_:)), name: NSNotification.Name(rawValue: "Category_Push_Action"), object: nil)

    }
    @objc func Category_Push_Action(_ notification: NSNotification) {
        var string = ""
        lbeSpe.text = ""
        if let array = notification.userInfo?["name"] as? NSArray {
            
            for i in 0 ..< array.count {
                if i == 0 {
                    lbeSpe.text = String(format:"%@",array[i] as! CVarArg)

                }
                else{
                    lbeSpe.text = String(format:"%@, %@", lbeSpe.text ?? "", array[i] as! CVarArg)

                }
                lbeSpe.textColor = UIColor.black
            }
            specialityConst.constant = 68
        }
        
    }
    @IBAction func subCate(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SpecialitiesViewController") as?  SpecialitiesViewController
        controller!.modalPresentationStyle = .overFullScreen
        controller!.selectArray = ["4","6"]
        self.present(controller!, animated: true, completion: nil)
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
    
    
    
    
    
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
        dropGender.show()
    }
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUserProfilePressed(_ sender: Any){
        self.view.endEditing(true)

        addImage(sender as! UIButton)
    }
    
    
    // MARK: - get Profile API
    func getProfileAPI(){
    
        GetProfileRequest.shared.getProfileAPI(requestParams:[:], true) { (user,message,isStatus) in
                if isStatus {
                    if user != nil{
                                UserDefaults.standard.set(user?.firstName, forKey: Constants.firstName)
                                UserDefaults.standard.set(user?.lastName, forKey: Constants.lastName)
                                UserDefaults.standard.set(user?.gender, forKey: Constants.gender)
                                UserDefaults.standard.set(user?.email, forKey: Constants.email)
                                UserDefaults.standard.set(user?.profilePic, forKey: Constants.userImg)
                                UserDefaults.standard.set(user?.phone, forKey: Constants.phone)

                        
                                UserDefaults.standard.synchronize()
                        
                                self.showDataOnProfile()
                        
                                self.genderStr = user?.gender ?? "Male"
                               // self.countryId = user?.countryId ?? 101
                             //   self.stateId = user?.stateId ?? 1630
                              
                              
                           
                                
                      

                    }
                }
            }
    }
    
    func showDataOnProfile(){
        let uName = UserDefaults.standard.string(forKey: Constants.firstName)
        self.txt_First.text = uName
        
        let lastName = UserDefaults.standard.string(forKey: Constants.lastName)
        self.txt_Last.text = lastName
        
        let genderName = UserDefaults.standard.string(forKey: Constants.gender)
        self.txt_Gender.text = genderName
        if genderName == " " {
            self.txt_Gender.text = ""
        }
        else{
            self.txt_Gender.text = genderName
        }
        
        let phoneNo = UserDefaults.standard.string(forKey: Constants.phone)
        self.txt_Phone.text = phoneNo
       
        
        let emailS = UserDefaults.standard.string(forKey: Constants.email)
        self.txt_Email.text = emailS
        
        var stringURL = ""
        let imgUser = UserDefaults.standard.string(forKey: Constants.userImg) ?? ""
        if imgUser.contains("http:") {
            stringURL = imgUser
        }
        else{
            stringURL =  GlobalConstants.BASE_IMAGE_URL + imgUser
        }
        
        let urlString = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        imgUserProfile?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "placeholder_Male"),
                               options: .refreshCached,
                               completed: nil)
        
        imgUserProfile.layer.borderWidth = 1
        imgUserProfile.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.clipsToBounds = true
    }
    
    
    @IBAction func UpdateProfilePressed(_ sender: Any){
        
        self.view.endEditing(true)
               
        trimmedName = txt_First.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedlast = txt_Last.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedEmailName = txt_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedPhone = txt_Phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        

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
        
        
       

                      
        
        let params = ["email": trimmedEmailName,
                      "firstName":trimmedName ,
                      "lastName": trimmedlast,
                      "dialCode": self.phoneCode,
                      "phoneNumber":trimmedPhone,
                      "gender":genderStr,
                      "id" : userId(),
        ] as [String : Any]


        UpdateProfile.shared.Update(requestParams: params) { (obj, msg, success,Verification) in
            
            if success == true {
                
                self.popMessageAlert(title: "Alert", message: msg!)
                
            }
            else
            {
                self.MessageAlert(title: "Alert", message: msg!)

            }
            
        }
        
        
    }
    
    
    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        var apiURL = String("\("Base".uploadProfilePic)")


        AlamofireRequest().uploadImageRemote(urlString: apiURL, image:  self.imgProfile ?? UIImage(), name: fileName , userID:  UserDefaults.standard.string(forKey: Constants.userId) ?? ""){ data, error -> Void in
            
            
            if !data!.isEmpty{
                if data == "failure"{
                    NotificationAlert().NotificationAlert(titles: "Uploaded successfully.")

                }
                else{
                    UserDefaults.standard.set(data ?? "iOS", forKey: Constants.userImg)
                    UserDefaults.standard.synchronize()
                    
                    NotificationAlert().NotificationAlert(titles: "Uploaded successfully.")
                }
               
            }
            
        }
        
    }
}
extension UpdateProfileUserViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        phoneCode = country.phoneCode
        print(message)
    }
}

class GetProfileRequest: NSObject {

    static let shared = GetProfileRequest()
    
    func getProfileAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: ProfileUpdateData?,_ message : String?, _ isStatus : Bool) -> Void) {

        
        let apiURL = String(format: "%@?id=%@","BaseURL".GetProfileDetail, userId())
         

        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                               
                                 if let dataList = data?["data"] as? [String:Any]{
                                       
                                     let dict : ProfileUpdateData = ProfileUpdateData.init(fromDictionary: dataList )
                                    completion(dict,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }
                         else
                         {
                             completion(nil,"",false)
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,"",false)
                    }
                }
            }
        }
class ProfileUpdateData: NSObject {
    var countryId = 0
    var stateId = 0
    var email = "";
    var firstName = "";
    var gender  = ""
    var lastName = ""
    var stateName = ""
    var countryName = ""
    var profilePic = ""
    var phone = ""
    var distributorCode = ""

    init(fromDictionary dictionary: [String:Any]){
        countryId = dictionary["countryId"] as? Int  ?? 0
        stateId = dictionary["stateId"] as? Int  ?? 0
        email = dictionary["email"] as? String ?? ""
        firstName = dictionary["firstName"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        stateName = dictionary["stateName"] as? String ?? ""
        countryName = dictionary["countryName"] as? String ?? ""
        profilePic = dictionary["profilepic"] as? String ?? ""
        phone = dictionary["phoneNumber"] as? String ?? ""
        distributorCode = dictionary["distributorCode"] as? String ?? ""
        
      

    }
    


}


class UpdateProfile: NSObject {
    
    static let shared = UpdateProfile()
    func Update(requestParams : [String:Any], completion: @escaping (_ object: String?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".UpdateProfile)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".UpdateProfile, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = ""
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                            
                            completion("", messageString, status, "")
                        
                    }
                    else
                    {
                        completion(nil, messageString, status,"")
                    }
                }
                else
                {
                    completion(nil, "There was an error connecting to server.", false,"")
                }
            }
            else{
                completion(nil,"There was an error connecting to server.try again", false,"")
            }
        }
    }
}
extension UpdateProfileUserViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        
        
        self.uploadProfileImageApi()

        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
extension UpdateProfileUserViewController: UITextFieldDelegate {
    
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
