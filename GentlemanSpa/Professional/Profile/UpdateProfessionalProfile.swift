//
//  UpdateProfessionalProfile.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 05/08/24.
//

import Foundation
class UpdateProfessionalProfile: NSObject {
    
    static let shared = UpdateProfessionalProfile()
    func Update(requestParams : [String:Any], completion: @escaping (_ object: String?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".UpdateProfessionalProfile)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".UpdateProfessionalProfile, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = GlobalConstants.serverError 
                    
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
