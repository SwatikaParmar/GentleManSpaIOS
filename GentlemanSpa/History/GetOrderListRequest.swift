//
//  GetOrderListRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 09/10/24.
//

import UIKit

class GetOrderListRequest: NSObject{

        static let shared = GetOrderListRequest()
        
        func GetOrderListAPIRequest(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: CartDataModel?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool, _ totalAmount: Double) -> Void) {

            let apiURL = String("Base".GetServiceAppointmentsAPI)
            
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
                                     
                                     var totalAmount = 0.00
                                     totalAmount = data?["data"]?["spaTotalSellingPrice"] as? Double ?? 0.00
                                     
                                     if let result = data?["data"]?["cartProducts"] as? [String : Any]{
                                        let dict : CartDataModel = CartDataModel.init(fromDictionary: result as! [String : Any])
                                            
                                             
                                         if let result = data?["data"]?["cartServices"] as? [String : Any]{
                                             let dictNew : cartServicesDataModel = cartServicesDataModel.init(fromDictionary: result as! [String : Any])
                                             completion(dict,dictNew,messageString,true, totalAmount)

                                         }
                                         else{
                                             completion(dict,nil,messageString,true,totalAmount)

                                         }

                                     }
                                     else{
                                         if let result = data?["data"]?["cartServices"] as? [String : Any]{
                                             let dictNew : cartServicesDataModel = cartServicesDataModel.init(fromDictionary: result as! [String : Any])
                                             completion(nil,dictNew,messageString,true,totalAmount)

                                         }
                                         else{
                                             completion(nil,nil,messageString,true,totalAmount)
                                         }
                                     }
                                    
                          
                                 }else{
                                     NotificationAlert().NotificationAlert(titles: messageString)
                                     completion(nil,nil,messageString,false,0.00)
                                 }
                             }
                             else
                             {
                                 completion(nil,nil,"",false,0.00)
                             }
                        }
                        else
                            {
                                
                            completion(nil,nil,"",false,0.00)
                        }
                    }
                }
            }
      

