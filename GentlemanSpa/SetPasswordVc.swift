//
//  SetPasswordVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 12/07/24.
//

import UIKit
import CocoaTextField

class SetPasswordVc: UIViewController {
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Password : CocoaTextField!
    @IBOutlet weak var txt_CPassword : CocoaTextField!
    
    var code = ""
    var email = ""
    
    var eyeClick = true
    var eyeClickC = true

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Phone.text = email
        applyStyle(to: txt_Phone)
        txt_Phone.placeholder = "Email or Phone no"
        txt_Phone.keyboardType = .emailAddress
        txt_Phone.autocapitalizationType = .none
        
        applyStyle(to: txt_Password)
        txt_Password.placeholder = "Password"
        txt_Password.isSecureTextEntry = true
        
        applyStyle(to: txt_CPassword)
        txt_CPassword.placeholder = "Confirm Password"
        txt_CPassword.isSecureTextEntry = true
        addEye()
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
        
        txt_CPassword.isSecureTextEntry = true

        let buttonNewC = UIButton(type: .custom)
        buttonNewC.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
        buttonNewC.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNewC.frame = CGRect(x: CGFloat(txt_CPassword.frame.size.width - 35), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
        buttonNewC.addTarget(self, action: #selector(self.eyePassword1), for: .touchUpInside)
        txt_CPassword.rightView = buttonNewC
        txt_CPassword.rightViewMode = .always
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
            txt_CPassword.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
            txt_CPassword.isSecureTextEntry = true
        }
        eyeClickC = !eyeClickC
    }
    @IBAction func Back(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }

    @IBAction fileprivate func setAction(_ sender: Any) {
        self.view .endEditing(true)
        
        let trimmedP = txt_Password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = txt_CPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if (trimmedP?.isEmpty)!{
            MessageAlert(title:"",message: "Please enter password")
            return
        }
        if trimmedP?.count ?? 0 < 6{
            MessageAlert(title:"Alert",message: "Password should be 6 characters or more")
            return
        }
        if (trimmedPassword?.isEmpty)!{
            MessageAlert(title:"",message: "Please enter confirm password")
            return
        }
        
        if (trimmedP?.trimmingCharacters(in: .whitespaces)) != (trimmedPassword?.trimmingCharacters(in: .whitespaces)){
           
            NotificationAlert().NotificationAlert(titles: "Password not match")
            return
        }
        
        
        
        var dataDict = Dictionary<String, Any>()
        dataDict = [  "email": email,
                      "activationCode":  code,
                      "currentPassword":trimmedP ?? "",
                      "newPassword":  trimmedP ?? ""] as [String : Any]
        
        changePassword(Params: dataDict)

    }
    
    
    //MARK: -  Login Data API Call --
    func changePassword(Params:[String: Any])
    {
        self.view.endEditing(true)
        
        SetPasswordRequest.shared.changePassword(requestParams: Params) { (obj, msg, success) in
            
            if success == false {
                self.MessageAlert(title: "Alert", message: msg!)
            }
            else
            {
                UserDefaults.standard.set(true, forKey: Constants.login)
                UserDefaults.standard.synchronize()
                                
                UserDefaults.standard.set("User", forKey: Constants.userType)
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
