//
//  MyServiceAPI.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 06/08/24.
//

import Foundation
class MyServiceListRequest: NSObject {
    
   
    
    
    static let shared = MyServiceListRequest()
    
    func MyServiceAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ServiceListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".GetProfessionalServices)")
            apiURL = String(format:"%@?professionalDetailId=%d&pageNumber=1&pageSize=1000&categoryId=%d&genderPreferences=%@&subCategoryId=%d",apiURL,requestParams["professionalDetailId"] as? Int ?? 0, requestParams["mainCategoryId"] as? Int ?? 0, requestParams["genderPreferences"] as? String ?? "Male",requestParams["subCategoryId"] as? Int ?? 0)

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

