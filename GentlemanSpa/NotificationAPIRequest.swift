//
//  NotificationAPIRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 11/02/25.
//

import Foundation
class NotificationTokenAPIRequest: NSObject {

    static let shared = NotificationTokenAPIRequest()
    func tokenApi(requestParams : [String:Any], completion: @escaping (_ objectData: NotificationData?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".updateFCMToken)
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: false, loaderMessage: "") { (data, error) in
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError 
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(nil,messageString,true)

                             }else{
                                 
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
        
                            completion(nil,"",false)
                    }
                }
            }
        }
class NotificationData: NSObject {
    
    var fcmToken = ""
    
    init(fromDictionary dictionary: [String:Any]){
        
        fcmToken = dictionary["fcmToken"] as? String ?? ""
    }
}


class NotifiactionListRequest: NSObject {
    
    static let shared = NotifiactionListRequest()
    func notificationData(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: DataNotificationList?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("".getNotificationList)
        apiURL = String(format:"%@?pageNumber=%d&pageSize=1000",apiURL,requestParams["pageNumber"] as? Int ?? 1)
        
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
                       
                        if let result = data?["data"] as? [String: Any]{
                            
                            let userModel : DataNotificationList = DataNotificationList.init(fromDictionary: result)
                    
                            completion(userModel ,messageString,true)
                        } else{
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
        }
    }
}
class NotificationModel: NSObject {
    
    var notificationDataDict : DataNotificationList?
    var unreadnotificationCount = 0

    init(fromDictionary dictionary: [String: Any]) {
        unreadnotificationCount = dictionary["unreadnotificationCount"] as? Int ?? 0

        if let dataList = dictionary["notificationList"] as? NSDictionary{
               
            let dict : DataNotificationList = DataNotificationList.init(fromDictionary: dataList as! [String : Any])
            notificationDataDict = dict
            
        }
        
        }
    }


class DataNotificationList : NSObject{
    
    
    var notificationList : [NotificationDataList] = []
    
    init(fromDictionary dictionary: [String: Any]) {
        
        if let dataList = dictionary["dataList"] as? NSArray{
            for list in dataList{
                let dict : NotificationDataList = NotificationDataList.init(fromDictionary: list as! [String : Any])
                notificationList.append(dict)
            }
        }
    }
}
    
    
class NotifiactionListObject : NSObject {
    var totalCount = 0 ;
    var pageSize = 0 ;
    var currentPage = 0 ;
    var totalPages = 0 ;
    var previousPage = 0 ;
    var nextPage = 0 ;
    var searchQuery = "" ;
    var dataList : [NotificationDataList] = []
    
    init(fromDictionary dictionary: [String: Any]) {
        totalCount = dictionary["totalCount"] as? Int ?? 0
        pageSize = dictionary["pageSize"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
        totalPages = dictionary["totalPages"] as? Int ?? 0
        previousPage = dictionary["previousPage"] as? Int ?? 0
        nextPage = dictionary["nextPage"] as? Int ?? 0
        searchQuery = dictionary["searchQuery"] as? String ?? ""
        
    }
    
}
class NotificationDataList : NSObject {
    var notificationSentId = 0 ;
    var userId = "" ;
    var title = "" ;
    var descriptionStr = "" ;
    var isNotificationRead : Bool ;
    var notificationType = "" ;
    var createDate = ""
    
    init(fromDictionary dictionary: [String: Any]) {
        notificationSentId = dictionary["notificationSentId"] as? Int ?? 0
        userId = dictionary["userId"] as? String  ?? ""
        title = dictionary["title"] as? String ?? ""
        descriptionStr = dictionary["description"] as? String ?? ""
        isNotificationRead = dictionary["isNotificationRead"] as? Bool ?? false
        notificationType = dictionary["notificationType"] as? String ?? ""
        createDate = dictionary["createDate"] as? String ?? ""
    }
}

class GetNotificationCountRequest: NSObject {
    
    static let shared = GetNotificationCountRequest()
    func getNotificationCountData(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: Int?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("".getNotificationCount)
        apiURL = String(format:"%@",apiURL)
        
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
                       
                        if let result = data?["data"] as? [String: Any]{
    
                            completion(result["notificationCount"] as? Int ,messageString,true)
                        } else{
                            completion(0,messageString,true)
                        }

                    }else{
                        completion(0,messageString,false)
                    }
                }
                else
                {
                    completion(0,"",false)
                }
            }
        }
    }
}

class ReadNotificationRequest: NSObject {
    
    static let shared = ReadNotificationRequest()
    func readNotificationRequestData(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: Int?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("".readNotification)
        apiURL = String(format:"%@?notificationSentId=0",apiURL)
        
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
                       
                        if let result = data?["data"] as? [String: Any]{
    
                            completion(result["notificationCount"] as? Int ,messageString,true)
                        } else{
                            completion(0,messageString,true)
                        }

                    }else{
                        completion(0,messageString,false)
                    }
                }
                else
                {
                    completion(0,"",false)
                }
            }
        }
    }
}
