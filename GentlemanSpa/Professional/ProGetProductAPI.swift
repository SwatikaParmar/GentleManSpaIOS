//
//  ProGetProductAPI.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 22/08/24.
//

import Foundation
class ProGetProductListRequest: NSObject {

    static let shared = ProGetProductListRequest()
    
    func productListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ProProductListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".GetProductList)")
            apiURL = String(format:"%@?PageNumber=1&PageSize=1000&ProfessionalDetailId=%d", apiURL,professionalDetailId())

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
                                 var homeListObject : [ProProductListModel] = []
                                 if let dataList = data?["data"]?["dataList"] as? NSArray{
                                        for list in dataList{
                                            let dict : ProProductListModel = ProProductListModel.init(fromDictionary: list as! [String : Any])
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

class ProProductListModel: NSObject {
    
    var productId = 0
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
    var serviceType = ""
    var stock = 0
    
    init(fromDictionary dictionary: [String:Any]){
        productId = dictionary["productId"] as? Int ?? 0
        salonName = dictionary["salonName"] as? String ?? ""
        salonId = dictionary["salonId"] as? Int ?? 0
        mainCategoryName = dictionary["mainCategoryName"] as? String ?? ""
        mainCategoryId = dictionary["categoryId"] as? Int ?? 0
        subCategoryName = dictionary["subCategoryName"] as? String ?? ""
        serviceName = dictionary["name"] as? String ?? ""
        serviceDescription = dictionary["description"] as? String ?? ""
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
        basePrice = dictionary["basePrice"] as? Double ?? 0.00
        serviceImage = dictionary["image"] as? String ?? ""
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        genderPreferences = dictionary["genderPreferences"] as? String ?? ""
        serviceType = dictionary["serviceType"] as? String ?? ""
        stock = dictionary["stock"] as? Int ?? 0

    }
}

