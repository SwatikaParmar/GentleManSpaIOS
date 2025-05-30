//
//  UpdateProfileProViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 04/08/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
class UpdateProfileProViewController: UIViewController {
    @IBOutlet weak var txt_First : CocoaTextField!
    @IBOutlet weak var txt_Last : CocoaTextField!
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Email : CocoaTextField!
    @IBOutlet weak var txt_Gender : CocoaTextField!
    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var txt_Client : CocoaTextField!

    @IBOutlet weak var countryPicker: UIView!
    @IBOutlet weak var lbeDialCode: UILabel!

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
    var specialityIds = ""

    var stringPhoneNo = ""
    var stringEmail = ""
    var professionalDetailId = 0
    var selectArray = NSMutableArray()

    
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
        
        setupDropDowns()
        self.lbeDialCode.font = UIFont(name: FontName.Inter.Regular, size: 16)!
       // self.countryPicker.delegate = self
       // self.phoneCode = "+91"
      //  countryPicker.setCountryByCode("IN")
      //  countryPicker.showCountryCodeInView = false
        
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
        txt_Client.placeholder = "Address"
        
        txt_Client.text = ""
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
            
        }
        
        specialityIds = ""
        if let array = notification.userInfo?["array"] as? NSArray {
            
            for i in 0 ..< array.count {
                if i == 0 {
                    specialityIds = String(format:"%@",array[i] as! CVarArg)

                }
                else{
                    specialityIds = String(format:"%@, %@", specialityIds, array[i] as! CVarArg)

                }
              
            }
            self.selectArray.removeAllObjects()
            self.selectArray.addObjects(from: array as! [Any])
        }
        
        
        let heightSizeLine = self.lbeSpe.text?.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 100)
        self.specialityConst.constant = CGFloat((heightSizeLine ?? 40) + 6)
        
    }
    @IBAction func subCate(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SpecialitiesViewController") as?  SpecialitiesViewController
        controller!.modalPresentationStyle = .overFullScreen
        controller!.selectArray.addObjects(from: self.selectArray as! [Any])
        self.present(controller!, animated: true, completion: nil)
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
    
        GetProfileProRequest.shared.proProfileAPI(requestParams:[:], true) { (user,message,isStatus) in
                if isStatus {
                    if user != nil{
                                UserDefaults.standard.set(user?.firstName, forKey: Constants.firstName)
                                UserDefaults.standard.set(user?.lastName, forKey: Constants.lastName)
                                UserDefaults.standard.set(user?.gender, forKey: Constants.gender)
                                UserDefaults.standard.set(user?.email, forKey: Constants.email)
                                UserDefaults.standard.set(user?.profilePic, forKey: Constants.userImg)
                                UserDefaults.standard.set(user?.phone, forKey: Constants.phone)
                                UserDefaults.standard.synchronize()
                        
                        self.lbeDialCode.text = user?.dialCode
                        self.phoneCode = user?.dialCode ?? "+1"
                        if user?.dialCode == "" {
                            self.phoneCode = "+1"
                        }
                        self.showDataOnProfile()
                        
                        self.genderStr = user?.gender ?? "Male"
                        self.lbeSpe.text = ""
                        if let array = user?.objectPro?.speciality as? NSMutableArray {
                            
                            for i in 0 ..< array.count {
                                if i == 0 {
                                    self.lbeSpe.text = String(format:"%@",array[i] as! CVarArg)
                                }
                                else{
                                    self.lbeSpe.text = String(format:"%@, %@", self.lbeSpe.text ?? "", array[i] as! CVarArg)

                                }
                                self.lbeSpe.textColor = UIColor.black
                            }
                            
                            
                        }
                        
                        self.specialityIds = user?.objectPro?.specialityIds ?? ""
                        if self.specialityIds != "" {
                            let fullNameArr = self.specialityIds.components(separatedBy: ",")

                            for i in 0 ..< fullNameArr.count {
                                self.selectArray.add(fullNameArr[i])

                                
                            }
                        }
                        else{
                            self.lbeSpe.textColor = UIColor.darkGray
                            self.lbeSpe.text = "Select Specialities"

                        }
                     
                        let heightSizeLine = self.lbeSpe.text?.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 100)
                        self.specialityConst.constant = CGFloat((heightSizeLine ?? 32) + 6)
                      
                        
                        
                        self.professionalDetailId = user?.objectPro?.professionalDetailId ?? 0
                        self.txt_Client.text = "1234 Chandigarh"
                           
                                
                      

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
        
        if specialityIds == "" {
            MessageAlert(title:"Alert",message: "Please select speciality")
            return
        }
        
    
        let paramsNew = ["specialityIds": String(specialityIds),
                         "professionalDetailId" :  professionalDetailId,
                         "spaDetailId" : 21,] as [String : Any]

        let params = ["email": trimmedEmailName,
                      "firstName":trimmedName,
                      "lastName": trimmedlast,
                      "dialCode": self.phoneCode,
                      "phoneNumber":trimmedPhone,
                      "gender":genderStr,
                      "id" : userId(),
                      "professionalDetail": paramsNew
        ] as [String : Any]


        UpdateProfessionalProfile.shared.Update(requestParams: params) { (obj, msg, success,Verification) in
            
            if success == false {
                self.MessageAlert(title: "Alert", message: msg!)
            }
            else
            {
                self.OnlyMessageAlert(title: "Alert", message: msg!)
            }
        }
    }
    
    
    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        let apiURL = String("\("Base".uploadProfilePic)")


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
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account?",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteAccount()
        }))
        present(alertController, animated: true, completion: nil)
    }
        
    func deleteAccount(){
        DeleteUserRequest.shared.accountDelete(id:0) { (obj, msg, success) in
            NotificationCenter.default.post(name: Notification.Name("Menu_Push_Pro"), object: nil, userInfo: ["count":"DeleteAccount"])
        }
    }
    
    
}
extension UpdateProfileProViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
     //   phoneCode = country.phoneCode
        print(message)
    }
}

class GetProfileProRequest: NSObject {

    static let shared = GetProfileProRequest()
    
    func proProfileAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: ProfileProUpdateData?,_ message : String?, _ isStatus : Bool) -> Void) {

        
        let apiURL = String(format: "%@?id=%@","BaseURL".GetProfessionalProfileDetail, userId())
         

        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError 
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                               
                                 if let dataList = data?["data"] as? [String:Any]{
                                       
                                     let dict : ProfileProUpdateData = ProfileProUpdateData.init(fromDictionary: dataList )
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

class ProfileProUpdateData: NSObject {
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
    var dialCode = ""
    var distributorCode = ""
    var objectPro:ProfessionalDetail?

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
        dialCode = dictionary["dialCode"] as? String ?? ""

        let dict : ProfessionalDetail = ProfessionalDetail.init(fromDictionary: dictionary["professionalDetail"] as! [String : Any] )
        objectPro = dict
    }
    
    
    class ProfessionalDetail: NSObject {
        var countryId = 0
        var stateId = 0
        var houseNoOrBuildingName = "";
        var speciality = NSMutableArray()
        var specialityIds = ""
        var professionalDetailId = 0

        init(fromDictionary dictionary: [String:Any]){
            countryId = dictionary["countryId"] as? Int  ?? 0
            stateId = dictionary["stateId"] as? Int  ?? 0
            houseNoOrBuildingName = dictionary["houseNoOrBuildingName"] as? String ?? ""
            professionalDetailId = dictionary["professionalDetailId"] as? Int  ?? 0

            specialityIds = dictionary["specialityIds"] as? String ?? ""
            if let dataList = dictionary["speciality"] as? NSArray{
                   for list in dataList{
                       speciality.add(list)
                }
            }
        }
    }
}
extension UpdateProfileProViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        ImageCompressor.compress(image: originalImage, maxByte: 1000000) { image in
            if let compressedImage = image {
                self.imgProfile = compressedImage
                DispatchQueue.main.async {self.uploadProfileImageApi()}


            } else {
                print("error")
                DispatchQueue.main.async {self.uploadProfileImageApi()}


            }
        }
        


        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
extension UpdateProfileProViewController: UITextFieldDelegate {
    
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
