//
//  GetProfessional.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/09/24.
//

import Foundation
class GetProfessionalListRequest: NSObject {

    static let shared = GetProfessionalListRequest()
    
    func GetProfessionalListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [GetProfessionalObject]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "BaseURL".GetProfessionalList
        
        apiURL = String(format:"%@?spaDetailId=%d&spaServiceId=%d",apiURL,requestParams["spaDetailId"] as? Int ?? 0,requestParams["spaServiceId"] as? Int ?? 0)


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
                                 var homeListObject : [GetProfessionalObject] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : GetProfessionalObject = GetProfessionalObject.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
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
class GetProfessionalObject: NSObject {
    
    var firstName: String?
    var lastName: String?
    var profilepic: String?
    var id : String?
    var object : professionalDetail?
    

    
    init(fromDictionary dictionary: [String:Any]){
        firstName = dictionary["firstName"] as? String ?? "".capitalized
        firstName = firstName?.capitalized
        
        lastName = dictionary["lastName"] as? String ?? "".capitalized
        lastName = lastName?.capitalized
        
        profilepic = dictionary["profilepic"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""

        if let dataList = dictionary["professionalDetail"] as? [String:Any]{
              
            let dict : professionalDetail = professionalDetail.init(fromDictionary: dataList )
            object = dict
        }
        
    }
}
            
class professionalDetail: NSObject {
    var arrayData = NSArray()
    var professionalDetailId = 0
    init(fromDictionary dictionary: [String:Any]){
        professionalDetailId = dictionary["professionalDetailId"] as? Int ?? 0
        arrayData = dictionary["speciality"] as? NSArray ?? NSArray()
    }
}
class TeamsProfessionalListRequest: NSObject {

    static let shared = TeamsProfessionalListRequest()
    
    func TeamsProfessionalListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [GetProfessionalObject]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "BaseURL".GetProfessionalList

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
                                 var homeListObject : [GetProfessionalObject] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : GetProfessionalObject = GetProfessionalObject.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
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
