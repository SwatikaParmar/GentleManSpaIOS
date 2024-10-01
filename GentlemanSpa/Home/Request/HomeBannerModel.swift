//
//  HomeBannerModel.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 23/07/24.
//

import Foundation

class BannerRequest: NSObject {

    static let shared = BannerRequest()
    
    func getBannerListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [HomeBannerModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("\("".GetBanners)")

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
                                 var object : [HomeBannerModel] = []
                                 if let dataList = data?["data"]as? NSArray{
                                        for list in dataList{
                                            let dict : HomeBannerModel = HomeBannerModel.init(fromDictionary: list as! [String : Any])
                                            object.append(dict)
                                            
                                        }
                                 
                                        completion(object,messageString,true)
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
class HomeBannerModel: NSObject {
    
    var featureBannerId : String?
    var featureBannerImage : String?
    var isModifiedAndroid : Bool?
    var isModifiedIos : Bool?
    var productId : String?
    var mainProductCategoryId = 0
    var mainProductCategoryName = ""
    init(fromDictionary dictionary: [String:Any]){
        featureBannerImage = dictionary["bannerImage"] as? String ?? ""

    }
}
