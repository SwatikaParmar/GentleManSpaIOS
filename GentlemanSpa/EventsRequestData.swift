//
//  EventsRequestData.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 19/12/24.
//

import Foundation


class GetEventsListRequest: NSObject{
    
    static let shared = GetEventsListRequest()
    
    func GetEventRequest(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [EventData]?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".GetEventList)
        
        apiURL = String(format:"%@?UserId=%@&pageNumber=1&pageSize=1000",apiURL,userId())
        
        
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
                        var homeListObject : [EventData] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : EventData = EventData.init(dict: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            completion(homeListObject,messageString,true)
                        }
                        else{
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
}

class EventData: NSObject {
    var eventId: Int
    var spaDetailId: Int
    var title: String
    var descriptionStr: String
    var startDate: String
    var endDate: String
    var location: String
    var isPublic: Bool
    var organizedBy: String
    var capacity: Int
    var registeredCount: Int
    var isDeleted: Bool
    var languageMode: String
    var createdBy: String?
    var createdAt: String
    var updatedBy: String?
    var updatedAt: String?
    var isRegistered: Bool
    
    init(dict: [String: Any]) {
        self.eventId = dict["eventId"] as? Int ?? 0
        self.spaDetailId = dict["spaDetailId"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.descriptionStr = dict["description"] as? String ?? ""
        self.startDate = dict["startDate"] as? String ?? ""
        self.endDate = dict["endDate"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        self.isPublic = dict["isPublic"] as? Bool ?? false
        self.organizedBy = dict["organizedBy"] as? String ?? ""
        self.capacity = dict["capacity"] as? Int ?? 0
        self.registeredCount = dict["registeredCount"] as? Int ?? 0
        self.isDeleted = dict["isDeleted"] as? Bool ?? false
        self.languageMode = dict["languageMode"] as? String ?? ""
        self.createdBy = dict["createdBy"] as? String
        self.createdAt = dict["createdAt"] as? String ?? ""
        self.updatedBy = dict["updatedBy"] as? String
        self.updatedAt = dict["updatedAt"] as? String
        self.isRegistered = dict["isRegistered"] as? Bool ?? false
    }
}
class AddOrUpdateEventRegistrationRequest: NSObject {

    static let shared = AddOrUpdateEventRegistrationRequest()
    
    func AddOrUpdateEventRegistrationAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".AddEvent)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
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
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }else{
                             NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                             completion(nil,"",false)
                         }
                     }else{
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,"",false)
                    }
                }
            }
        }

