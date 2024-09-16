//
//  AddProductCartAPI.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/09/24.
//

import Foundation
class AddOrUpdateProductInCartRequest: NSObject {

    static let shared = AddOrUpdateProductInCartRequest()
    
    func addProductAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".AddOrUpdateProductInCart)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
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


