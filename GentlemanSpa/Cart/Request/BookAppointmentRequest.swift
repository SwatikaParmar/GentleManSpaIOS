//
//  BookAppointmentRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 08/10/24.
//

import Foundation
class BookAppointmentRequest: NSObject {

    static let shared = BookAppointmentRequest()
    
    func  bookingAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = "B".PlaceOrder
        
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



class PayByStripeRequest: NSObject {

    static let shared = PayByStripeRequest()
    
    func  PayByStripeAmountAPI(requestParams : [String:Any], completion: @escaping (_ sessionUrl: String?,_ paymentId: Int?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = "baseURL".PayByStripe
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["status"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(data?["data"]?["sessionUrl"] as? String,data?["data"]?["paymentId"] as? Int,messageString,true)

                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,nil,messageString,false)
                             }
                         }else{
                             NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                             completion(nil,nil,"",false)
                         }
                     }else{
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,nil,"",false)
                    }
                }
            }
        }



class OrderConfirmationRequest: NSObject{
    
    static let shared = OrderConfirmationRequest()
    
    func OrderConfirmationRequestAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: String?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".OrderConfirmation)
        
        apiURL = String(format:"%@?paymentId=%d",apiURL,requestParams["paymentId"] as? Int ?? 0)
        
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print(data ?? "No data")
            if error == nil{
                var messageString : String = ""
                if let status = data?["status"] as? Bool{
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    if status{
                        if let dataList = data?["data"]?["paymentStatus"] as? String{
                         
                            completion(dataList,nil,messageString,true)
                        }
                        else{
                            completion(nil,nil,messageString,false)
                        }
                    }
                    else
                    {
                        completion(nil,nil,"",false)
                    }
                }
                else
                {
                    completion(nil,nil,"",false)
                }
            }
        }
    }
}
    
