//
//  GetServiceListRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/08/24.
//

import Foundation
class GetServiceListRequest: NSObject {

    static let shared = GetServiceListRequest()
    
    func serviceListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ServiceListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".getSalonServiceList)")
            apiURL = String(format:"%@?spaDetailId=%d&pageNumber=1&pageSize=1000&categoryId=%d&searchQuery=%@&subCategoryId=%d",apiURL,requestParams["salonId"] as? Int ?? 0, requestParams["mainCategoryId"] as? Int ?? 0, requestParams["searchQuery"] as? String ?? "Male",requestParams["subCategoryId"] as? Int ?? 0)

            print("URL---->> ",apiURL)
            print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 var homeListObject : [ServiceListModel] = []
                                 if let dataList = data?["data"]?["dataList"] as? NSArray{
                                        for list in dataList{
                                            let dict : ServiceListModel = ServiceListModel.init(fromDictionary: list as! [String : Any])
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

class ServiceListModel: NSObject {
    
    var serviceId = 0
    var salonId = 0
    var salonName = ""
    var mainCategoryId = 0
    var mainCategoryName = ""
    var subCategoryId = 0
    var subCategoryName = ""
    var serviceName = ""
    var serviceDescription = ""
    var listingPrice = 0.00
    var basePrice = 0.00
    var serviceImage : String?
    var durationInMinutes = 0
    
    var genderPreferences = ""
    var isSlotAvailable = 0
    var serviceType = ""
    var serviceCountInCart = 0
    var spaServiceId = 0
    
    init(fromDictionary dictionary: [String:Any]){
        serviceId = dictionary["serviceId"] as? Int ?? 0
        salonName = dictionary["salonName"] as? String ?? ""
        salonId = dictionary["salonId"] as? Int ?? 0
        mainCategoryName = dictionary["mainCategoryName"] as? String ?? ""
        mainCategoryId = dictionary["categoryId"] as? Int ?? 0
        subCategoryName = dictionary["subCategoryName"] as? String ?? ""
        serviceName = dictionary["name"] as? String ?? ""
        serviceDescription = dictionary["description"] as? String ?? ""
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
        basePrice = dictionary["basePrice"] as? Double ?? 0.00
        serviceImage = dictionary["serviceIconImage"] as? String ?? ""
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        serviceCountInCart = dictionary["isAddedinCart"] as? Int ?? 0
        genderPreferences = dictionary["genderPreferences"] as? String ?? ""
        isSlotAvailable = dictionary["isSlotAvailable"] as? Int ?? 0
        serviceType = dictionary["serviceType"] as? String ?? ""
        spaServiceId = dictionary["spaServiceId"] as? Int ?? 0

    }
}




class ServiceDetailRequest: NSObject {

    static let shared = ServiceDetailRequest()
    
    func serviceDetailAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:ServiceDetailModel?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".GetServiceDetail)")
            apiURL = String(format:"%@?serviceId=%d&spaDetailId=%d",apiURL,requestParams["serviceId"] as? Int ?? 0,requestParams["spaDetailId"] as? Int ?? 0)

            print("URL---->> ",apiURL)
            print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 if let dataList = data?["data"] as? [String:Any]{
                                      
                                     let dict : ServiceDetailModel = ServiceDetailModel.init(fromDictionary: dataList )
                                        completion(dict,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                             }
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                    }
                }
            }
        }

class ServiceDetailModel: NSObject {
    
    var salonName = ""
    var serviceName = ""
    var serviceDescription = ""
    var basePrice = 0.00
    var listingPrice = 0.00
    var serviceIconImage = ""
    var durationInMinutes = 0
    var serviceImageArray = NSMutableArray()
    var isAddedinCart = 0
    var spaServiceId = 0

    init(fromDictionary dictionary: [String:Any]){
        salonName = dictionary["salonName"] as? String ?? ""
        serviceName = dictionary["name"] as? String ?? ""
        serviceDescription = dictionary["description"] as? String ?? ""
        basePrice = dictionary["basePrice"] as? Double ?? 0.00
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
        serviceIconImage = dictionary["serviceIconImage"] as? String ?? ""
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        isAddedinCart = dictionary["isAddedinCart"] as? Int ?? 0
        spaServiceId = dictionary["spaServiceId"] as? Int ?? 0

        
        if let dataList = dictionary["imageList"] as? NSArray{
               for list in dataList{
                   serviceImageArray.add(list)
            }
        }
        
    }
}


class GetProfessionalServicesRequest: NSObject {

    static let shared = GetProfessionalServicesRequest()
    
    func GetProfessionalServicesListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ServiceListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".GetProfessionalServices)")
        apiURL = String(format:"%@?professionalDetailId=%d",apiURL,requestParams["professionalDetailId"] as? Int ?? 0)

            print("URL---->> ",apiURL)
            print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 var homeListObject : [ServiceListModel] = []
                                 if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : ServiceListModel = ServiceListModel.init(fromDictionary: list as! [String : Any])
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
