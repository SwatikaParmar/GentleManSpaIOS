//
//  VerifiyController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/07/24.
//

import UIKit
import SVPinView

class VerifiyController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var pinViewPhone: SVPinView!
    @IBOutlet weak var btnV: UIButton!
    var email = ""
    var codeStr = ""
    var accessToken = ""
    var enterCodeStr = ""
    var trimmedName = ""
    var trimmedlast = ""
    var trimmedPassword = ""
    var stringPhoneNo = ""
    var stringEmail = ""
    var stringGender = ""
    var phoneCode = ""
    var img = UIImage()
    var imgIS = false
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePhonePinView()
//        let controller:AlertViewController =  UIStoryboard(storyboard: .main).initVC()
//        controller.providesPresentationContextTransitionStyle = true
//        controller.definesPresentationContext = true
//        controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
//        self.present(controller, animated: true, completion: nil)
      
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLoginPressed(_ sender: Any) {
       
        callData()
    
    }
    
    
    func callData(){
        self.view.endEditing(true)
        if enterCodeStr.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter verification code.")
            return
        }
        else if codeStr !=  enterCodeStr{
            NotificationAlert().NotificationAlert(titles: "Incorrect verification code.")
            return
        }
        else{
            SignUp_User()
        }
    }
    
    
    func configurePhonePinView(){
        self.view.layoutIfNeeded()

        self.pinViewPhone.font = UIFont.init(name: FontName.Inter.Medium, size: 24.0) ?? UIFont.systemFont(ofSize: 22)
        self.pinViewPhone.borderLineColor = UIColor.white
        self.pinViewPhone.activeBorderLineColor = UIColor.white
        self.pinViewPhone.borderLineThickness = 1.1
        self.pinViewPhone.activeBorderLineThickness = 1.9
        self.pinViewPhone.interSpace = 15
        self.pinViewPhone.style = .box
        self.pinViewPhone.pinLength = 5
        self.pinViewPhone.fieldCornerRadius = 5
        self.pinViewPhone.activeFieldCornerRadius = 5
        self.pinViewPhone.textColor = UIColor.white
        self.pinViewPhone.shouldSecureText = false
        self.pinViewPhone.keyboardType = .numberPad
        self.pinViewPhone.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        self.pinViewPhone.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            self.enterCodeStr = String(pin)
        }
        
        self.pinViewPhone.didFinishCallback = { pin in
            print("The entered pin is \(pin)")
            self.enterCodeStr = String(pin)
            self.callData()
        }
    }
    
    //MARK:-  Dismiss Keyboard Action
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    
    
       func SignUp_User(){
        
                let params = ["email": stringEmail,
                              "password": trimmedPassword,
                              "firstName":trimmedName ,
                              "lastName": trimmedlast,
                              "dialCode": self.phoneCode,
                              "phoneNumber":stringPhoneNo,
                              "gender":stringGender,
                              "role": "Professional"
                ] as [String : Any]
        
           AccountAPIRequest.shared.RegisterUser(requestParams: params) { (obj, msg, success,Verification) in
        
                    if success == false {
                        self.MessageAlert(title: "Alert", message: msg!)
                    }
                    else
                    {
                        self.save(object: obj!)
                        if self.imgIS == true
                        {
                            self.uploadProfileImageApi()
                        }
                        else{
                            UserDefaults.standard.set(true, forKey: Constants.login)
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.set("Professional", forKey: Constants.userType)
                            UserDefaults.standard.synchronize()
                            let controller:AlertViewController =  UIStoryboard(storyboard: .main).initVC()
                            controller.providesPresentationContextTransitionStyle = true
                            controller.definesPresentationContext = true
                            controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
                            self.present(controller, animated: true, completion: nil)
                        }
                       
            }
        }
    }
    
    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        var apiURL = String("\("Base".uploadProfilePic)")


        AlamofireRequest().uploadImageRemote(urlString: apiURL, image:  self.img ?? UIImage(), name: fileName , userID:  UserDefaults.standard.string(forKey: Constants.userId) ?? ""){ data, error -> Void in
            
            
            if !data!.isEmpty{
                if data == "failure"{
                    UserDefaults.standard.set(true, forKey: Constants.login)
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set("Professional", forKey: Constants.userType)
                    UserDefaults.standard.synchronize()
                    let controller:AlertViewController =  UIStoryboard(storyboard: .main).initVC()
                    controller.providesPresentationContextTransitionStyle = true
                    controller.definesPresentationContext = true
                    controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
                    self.present(controller, animated: true, completion: nil)

                }
                else{
                    UserDefaults.standard.set(data ?? "iOS", forKey: Constants.userImg)
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.set(true, forKey: Constants.login)
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set("Professional", forKey: Constants.userType)
                    UserDefaults.standard.synchronize()
                    let controller:AlertViewController =  UIStoryboard(storyboard: .main).initVC()
                    controller.providesPresentationContextTransitionStyle = true
                    controller.definesPresentationContext = true
                    controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
                    self.present(controller, animated: true, completion: nil)
                }
               
            }
            
        }
        
    }
}


class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       
    }
    
    @IBAction func goPreessed(_ sender: Any){
        
        RootControllerManager().SetRootViewController()
    }
}
