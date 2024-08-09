//
//  SetPasswordRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 15/07/24.
//

import Foundation
class SetPasswordRequest: NSObject {
    
    static let shared = SetPasswordRequest()
    
    func changePassword(requestParams : [String:Any], completion: @escaping (_ object: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        print("URL---->> ","BaseURL".ChangePassword)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".ChangePassword, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
            print("*************************************************")
            print(data ?? "No data")
            if error == nil{
                
                if let status = data?["isSuccess"] as? Bool{
                    var messageString : String = ""
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    if status == true{
                        completion(nil, messageString,status)
                    }
                    else
                    {
                        completion(nil, messageString, status)
                    }
                }
                else
                {
                    completion(nil, GlobalConstants.serverError,false)
                }
            }
            else{
                completion(nil,GlobalConstants.serverError,false)
            }
        }
    }
}
class ResendEmailAPIRequest: NSObject {
    
    static let shared = ResendEmailAPIRequest()
    
    func ResendEmail(requestParams : [String:Any],accessToken:String, completion: @escaping (_ message : String?, _ status : Bool, _ otp:Int) -> Void) {
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".ResendEmailURL, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
            
            if error == nil{
                print(data as Any)
                
                if let status = data?["isSuccess"] as? Bool{
                    
                    var messageString : String = ""
                    var OTP = 0
                    
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                        
                        if let Result = data?["data"] as? [String : Any]{
                            
                            if let otpCodes = Result["otp"] as? Int{
                                OTP = otpCodes
                            }
                        }
                        
                        completion(messageString, true,OTP)
                    }
                    else{
                        
                        completion(messageString, false,OTP)
                    }
                }
                else
                {
                    completion( "There was an error connecting to server.", false,0)
                }
                
            }else{
                completion("There was an error connecting to server.try again", false,0)
            }
        }
    }
}
class AccountAPIRequest: NSObject {
    
    static let shared = AccountAPIRequest()
    func RegisterUser(requestParams : [String:Any], completion: @escaping (_ object: LoginObject?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".SignUpURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".SignUpURL, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "Sign Up") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = ""
                    var accessToken : String = ""
                    
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                        if let Result = data?["data"] as? [String : Any]{
                            
                            if let accessTokenS = Result["token"] as? String{
                                accessToken = accessTokenS
                                UserDefaults.standard.set(accessToken, forKey: Constants.accessToken)
                                UserDefaults.standard.synchronize()
                            }
                            
                            
                            
                            let userModel : LoginObject = LoginObject.init(model: Result as [String : Any])
                            completion(userModel, messageString, status, "")
                        }
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
