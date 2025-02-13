//
//  HomeList.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 31/07/24.
//

import Foundation
class HomeListRequest: NSObject {

    static let shared = HomeListRequest()
    
    func homeListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [dashboardCategoryObject]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "BaseURL".homeApi
            apiURL = String(format:"%@?spaDetailId=%d",apiURL,requestParams["spaDetailId"] as? Int ?? 0)

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
                                 var homeListObject : [dashboardCategoryObject] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            
                                            let dict : dashboardCategoryObject = dashboardCategoryObject.init(fromDictionary: list as! [String : Any])
                                           
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
class dashboardCategoryObject: NSObject {
    
    var categoryName: String?
    var categoryImage: String?
    var mainCategoryId = 0
    var subProductCategoryId = 0
    var subSubProductCategoryId = 0
    

    
    init(fromDictionary dictionary: [String:Any]){
        categoryName = dictionary["categoryName"] as? String ?? ""
        categoryImage = dictionary["categoryImage"] as? String ?? ""
        mainCategoryId = dictionary["categoryId"] as? Int ?? 0
        subProductCategoryId = dictionary["subProductCategoryId"] as? Int ?? 0
        subSubProductCategoryId = dictionary["subSubProductCategoryId"] as? Int ?? 0
        
    }
}


class GetSpaSubCategoriesRequest: NSObject {

    static let shared = GetSpaSubCategoriesRequest()
    
    func GetSpaSubCategoriesAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [SpaSubCategoriesObject]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "BaseURL".homeApi
            apiURL = String(format:"%@?spaDetailId=%d&categoryId=%d",apiURL,requestParams["spaDetailId"] as? Int ?? 0,requestParams["categoryId"] as? Int ?? 0)

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
                                 var homeListObject : [SpaSubCategoriesObject] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            
                                            let dict : SpaSubCategoriesObject = SpaSubCategoriesObject.init(fromDictionary: list as! [String : Any])
                                           
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
class SpaSubCategoriesObject: NSObject {
    
    var categoryName: String?
    var categoryImage: String?
    var mainCategoryId = 0
    var subProductCategoryId = 0
    var subSubProductCategoryId = 0
    

    
    init(fromDictionary dictionary: [String:Any]){
        categoryName = dictionary["categoryName"] as? String ?? ""
        categoryImage = dictionary["categoryImage"] as? String ?? ""
        mainCategoryId = dictionary["subCategoryId"] as? Int ?? 0
        subProductCategoryId = dictionary["subProductCategoryId"] as? Int ?? 0
        subSubProductCategoryId = dictionary["subSubProductCategoryId"] as? Int ?? 0
        
    }
}
