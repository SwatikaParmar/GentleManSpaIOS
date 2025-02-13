//
//  AvailableDatesRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/10/24.
//

import UIKit

class AvailableDatesRequest: NSObject {

    static let shared = AvailableDatesRequest()
    
    func dateListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:[String],_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "b".getAvailableDates
            apiURL = String(format:"%@?SpaServiceIds=%d&ProfessionalId=%d",apiURL,requestParams["SpaServiceIds"] as? Int ?? 0,requestParams["ProfessionalId"] as? Int ?? 0)

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
                                 var dateArray = [String]()
                                 if let dataList = data?["data"] as? NSArray{
                                     let formatter = DateFormatter()
                                     let CurrentDate = Date()
                                     formatter.timeZone = TimeZone.current
                                     formatter.dateFormat = "dd-MM-yyyy"
                                     var todayStr = formatter.string(from: CurrentDate)
                                     formatter.timeZone = TimeZone.current
                                     let currentDateTime = formatter.date(from: todayStr)
                                        for list in dataList{
                                            formatter.timeZone = TimeZone.current
                                            formatter.dateFormat = "yyyy-MM-dd"

                                            let dateList = formatter.date(from: list as? String ?? "30-12-2023")
                                   
                                            if currentDateTime ?? Date() <= dateList ?? Date() {
                                                formatter.timeZone = TimeZone.current
                                                formatter.dateFormat = "dd-MM-yyyy"
                                                dateArray.append(formatter.string(from: dateList ?? Date()))
                                            }
                                        }
                                        completion(dateArray,messageString,true)
                                 }
                                 else{
                                     completion([],messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                             }
                         }
                         else
                         {
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                           
                    }
                }
            }
        }




class AvailableTimeRequest: NSObject {
    
    static let shared = AvailableTimeRequest()
    
    func timeListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [TimeListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = "b".GetAvailableTimeSlots
        
        apiURL = String(format:"%@?SpaServiceIds=%d&Date=%@&ProfessionalId=%d",apiURL,requestParams["SpaServiceIds"] as? Int ?? 0,requestParams["queryDate"] as? String ?? "",requestParams["ProfessionalId"] as? Int ?? 0)
        
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
                        var homeListObject : [TimeListModel] = []
                        
                        if let dataList = data?["data"] as? NSArray{
                            if dataList.count > 0 {
                                let  dictionary: [String:Any]
                                dictionary = dataList[0] as! [String:Any]
                                
                                if let slots = dictionary["slots"] as? NSArray{
                                    for list in slots{
                                        let dict : TimeListModel = TimeListModel.init(fromDictionary: list as! [String : Any])
                                        homeListObject.append(dict)
                                    }
                                    completion(homeListObject,messageString,true)
                                }
                                else{
                                    completion(nil,messageString,true)

                                }
                            }
                            else{
                                completion(nil,messageString,true)

                            }
                        }
                        else{
                            completion(nil,messageString,true)

                        }
                        
                    }else{
                        completion(nil,messageString,true)
                    }
                    
                }else{
                    NotificationAlert().NotificationAlert(titles: messageString)
                }
            }
        }
    }
}
        



    class TimeListModel: NSObject {
        
        var slotId = 0
        var slotCount = 4
        var fromTime = ""
        var toTime = ""
        var status = true

        init(fromDictionary dictionary: [String:Any]){
            slotId = dictionary["slotId"] as? Int ?? 0
            fromTime = dictionary["fromTime"] as? String ?? ""
            toTime = dictionary["toTime"] as? String ?? ""
            status = dictionary["status"] as? Bool ?? false
            slotCount = dictionary["slotCount"] as? Int ?? 0
        }
    }




class IncludeServiceModel: NSObject {
   
    var serviceId = 0
    var serviceName =  ""
    var serviceIconImage : String?
    var basePrice = 0
    var discount = 0.00
    var listingPrice = 0.00
    
    init(fromDictionary dictionary: [String:Any]){
        serviceName = dictionary["serviceName"] as? String ?? ""
        serviceIconImage = dictionary["serviceIconImage"] as? String ?? ""
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
    }

}




class ServiceImageModel: NSObject {
    var salonServiceImage : String?
    
    init(fromDictionary dictionary: [String:Any]){
        salonServiceImage = dictionary["salonServiceImage"] as? String ?? ""
    }

}


