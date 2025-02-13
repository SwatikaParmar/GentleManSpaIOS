//
//  CreateSchedule.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 05/08/24.
//

import Foundation
class CreateScheduleAPIRequest: NSObject {
    
    static let shared = CreateScheduleAPIRequest()
    func CreateSche(requestParams : [String:Any], completion: @escaping (_ object: String?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".AddUpdateProfessionalSchedule)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".AddUpdateProfessionalSchedule, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
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

class GetProfessionalSchedulesRequest: NSObject {

    static let shared = GetProfessionalSchedulesRequest()
    
    func GetProfessionalSchedAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:[SchedulesModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        
        let apiURL = String(format: "%@?professionalDetailId=%d","BaseURL".GetProfessionalSchedulesByProfessionalDetailId, professionalDetailId())
         

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
                                 var homeListObject : [SchedulesModel] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : SchedulesModel = SchedulesModel.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                // NotificationAlert().NotificationAlert(titles: messageString)
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


class GetWeekdaysRequest: NSObject {

    static let shared = GetWeekdaysRequest()
    
    func GetWeekdaysRequestAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:[WeekdaysModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        
        let apiURL = String(format: "%@","BaseURL".GetWeekdays)
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError 
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 var homeListObject : [WeekdaysModel] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : WeekdaysModel = WeekdaysModel.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                // NotificationAlert().NotificationAlert(titles: messageString)
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


class WeekdaysModel: NSObject {
    
    var weekName: String?
    var weekdaysId = 0
    
    init(fromDictionary dictionary: [String:Any]){
        weekName = dictionary["weekName"] as? String ?? ""
        weekdaysId = dictionary["weekdaysId"] as? Int ?? 0

        
    }
}



class SchedulesModel: NSObject {
    
    var weekName: String?
    var weekdaysId = 0
    var professionalScheduleId = 0
    var workingTime: [[String: String]] = []


    init(fromDictionary dictionary: [String:Any]){
        weekName = dictionary["weekName"] as? String ?? ""
        weekdaysId = dictionary["weekdaysId"] as? Int ?? 0
        if let workingTimeArray = dictionary["workingTime"] as? [[String: String]] {
            self.workingTime = workingTimeArray
        }
       

        professionalScheduleId = dictionary["professionalScheduleId"] as? Int ?? 0

    }
}
