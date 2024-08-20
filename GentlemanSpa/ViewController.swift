//
//  ViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 11/07/24.
//

import UIKit
import CocoaTextField
import Reachability

class ViewController: UIViewController {
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Password : CocoaTextField!
    @IBOutlet weak var txt_ActivationCode : CocoaTextField!
    
    var eyeClick = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEye()
        applyStyle(to: txt_Phone)
        txt_Phone.placeholder = "Email or Phone no"
        txt_Phone.keyboardType = .emailAddress
        txt_Phone.autocapitalizationType = .none
        
        applyStyle(to: txt_Password)
        txt_Password.placeholder = "Password"
        txt_Password.isSecureTextEntry = true
        
        applyStyle(to: txt_ActivationCode)
        txt_ActivationCode.placeholder = "Activation code"
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
    
    @IBAction fileprivate func ForgotAction(_ sender: Any) {
        self.view .endEditing(true)
        //    let controller:ForgotPasswordController =  UIStoryboard(storyboard: .main).initVC()
        //    self.navigationController?.pushViewController(controller, animated: true)
        
        let controller:SetPasswordVc =  UIStoryboard(storyboard: .main).initVC()
            controller.email = ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction fileprivate func SignUp(_ sender: Any) {
        self.view .endEditing(true)
           let controller:CreateAccountController =  UIStoryboard(storyboard: .main).initVC()
           self.navigationController?.pushViewController(controller, animated: true)
    }

    
    @IBAction fileprivate func SignInAction(_ sender: Any) {
        self.view .endEditing(true)
        
        let trimmedEmailName = txt_Phone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = txt_Password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAc = txt_ActivationCode.text
        
        var dataDict = Dictionary<String, Any>()
                      
        if (trimmedEmailName?.isEmpty)! && (trimmedAc?.isEmpty)!{
            MessageAlert(title:"",message: "Please enter your email or Activation Code")
            return
        }
        else{
            if trimmedEmailName == ""{
                if (trimmedAc?.isEmpty)!{
                    MessageAlert(title:"",message: "Please enter Activation Code.")
                    return
                }
                dataDict = ["emailOrPhoneNumber": "",
                              "password":  "",
                              "activationCode": trimmedAc ?? "",
                              "language":Language.English.rawValue] as [String : Any]
                
                loginRequest(Params: dataDict)
            }
            else{
                if (trimmedPassword?.isEmpty)!{
                    MessageAlert(title:"",message: "Please enter your password.")
                    return
                }
                
                dataDict = ["emailOrPhoneNumber": trimmedEmailName ?? "",
                              "password": trimmedPassword ?? "",
                              "activationCode": "",
                              "language":Language.English.rawValue] as [String : Any]
                
                loginRequest(Params: dataDict)

            }
        }
        
     
    }
    //MARK: -  Login Data API Call --
    func loginRequest(Params:[String: Any])
    {
        self.view.endEditing(true)
        
        LoginAPIRequest.shared.login(requestParams: Params) { (obj, msg, success,Verification,ScreenNumber,accessToken,email) in
            
            if success == false {
                self.MessageAlert(title: "Alert", message: msg!)
            }
            else
            {
                if Verification {
                    self.save(object: obj!)
                    UserDefaults.standard.set(true, forKey: Constants.login)
                    UserDefaults.standard.synchronize()
                    RootControllerManager().SetRootViewController()
                }
                else{
                     let controller:SetPasswordVc =  UIStoryboard(storyboard: .main).initVC()
                         controller.email = email
                         controller.code = Params["activationCode"] as! String
                     self.navigationController?.pushViewController(controller, animated: true)
                }

            }
        }
    }
    
   
}

extension UIViewController {
    func save(object : LoginObject){
        
    do {
        let encodedData = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedData, forKey: "Login")
        UserDefaults.standard.synchronize()
       } catch {
           fatalError("Can't encode data: \(error)")
       }
    }

    
        static var hasSafeArea: Bool {
            var statusBarHeight: CGFloat = 0
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            if statusBarHeight > 24 {
                return true
         }
            return false
     }
 

    
    func applyStyle(to v: CocoaTextField) {
    
        v.tintColor = UIColor.darkGray
        v.textColor = UIColor.black
        v.inactiveHintColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        v.activeHintColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        v.focusedBackgroundColor = UIColor.clear
        v.defaultBackgroundColor = UIColor.clear
        v.borderColor = UIColor.clear
        v.errorColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 0.7)
    }

    func MessageAlert(title:String,message:String)
    {
        let alert = UIAlertController(title:"Oops!", message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func popMessageAlert(title:String,message:String)
    {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func SessionMessageAlert(title:String,message:String)
    {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
        
            NotificationCenter.default.post(name: Notification.Name("SessionExpire"), object: nil)
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    func InterNetConnection()->Bool  {
        
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            return true
        }
        else
        {
            return false
        }
    }
    
    func InternetAlert()
    {
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Internet not available, Cross check your internet connectivity and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
