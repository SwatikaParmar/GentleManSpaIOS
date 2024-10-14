//
//  GetOrderListRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 09/10/24.
//

import UIKit

class GetServiceAppointmentsListRequest: NSObject{
    
    static let shared = GetServiceAppointmentsListRequest()
    
    func GetServiceAppointmentsAPIRequest(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ServiceBooking]?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".GetServiceAppointmentsAPI)
        
        apiURL = String(format:"%@?pageNumber=1&pageSize=1000&Type=%@",apiURL,requestParams["Type"] as? String ?? "Upcoming")
        
        
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
                        var homeListObject : [ServiceBooking] = []
                        if let dataList = data?["data"]?["dataList"] as? NSArray{
                            for list in dataList{
                                let dict : ServiceBooking = ServiceBooking.init(dict: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            completion(homeListObject,nil,messageString,true)
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
    
    
    class ServiceBooking: NSObject {
        var fromTime: String
        var image: String?
        var orderDate: String
        var orderId: Int
        var orderStatus: String
        var price = 0.00
        var professionalDetailId: Int
        var professionalName: String
        var serviceBookingId: Int
        var serviceName: String
        var slotDate: String
        var slotId: Int
        var spaServiceId: Int
        var toTime: String
        var durationInMinutes = 0
        
        
        
        init(dict: [String: Any]) {
            self.fromTime = dict["fromTime"] as? String ?? ""
            self.image = dict["image"] as? String ?? ""
            self.orderDate = dict["orderDate"] as? String ?? ""
            self.orderId = dict["orderId"] as? Int ?? 0
            self.orderStatus = dict["orderStatus"] as? String ?? ""
            self.price = dict["price"] as? Double ?? 0.00
            self.professionalDetailId = dict["professionalDetailId"] as? Int ?? 0
            self.professionalName = dict["professionalName"] as? String ?? ""
            self.serviceBookingId = dict["serviceBookingId"] as? Int ?? 0
            self.serviceName = dict["serviceName"] as? String ?? ""
            self.slotDate = dict["slotDate"] as? String ?? ""
            self.slotId = dict["slotId"] as? Int ?? 0
            self.spaServiceId = dict["spaServiceId"] as? Int ?? 0
            self.toTime = dict["toTime"] as? String ?? ""
            self.durationInMinutes = dict["durationInMinutes"] as? Int ?? 0

        }
    }


class GetOrderedProductsListRequest: NSObject{
    
    static let shared = GetOrderedProductsListRequest()
    
    func GetOrderedProductsRequest(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [OrderItem]?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".GetOrderedProducts)
        
        apiURL = String(format:"%@?pageNumber=1&pageSize=1000&Type=%@",apiURL,requestParams["Type"] as? String ?? "Upcoming")
        
        
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
                        var homeListObject : [OrderItem] = []
                        if let dataList = data?["data"]?["dataList"] as? NSArray{
                            for list in dataList{
                                let dict : OrderItem = OrderItem.init(dict: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            completion(homeListObject,nil,messageString,true)
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
    
class OrderItem: NSObject {
    var orderId: Int
    var productId: Int
    var productName: String?
    var productImage: String?
    var quantity: Int
    var price: Double
    var orderStatus: String
    var professionalDetailId: Int
    var professionalName: String
    var orderDate: String

    init(dict: [String: Any]) {
        self.orderId = dict["orderId"] as? Int ?? 0
        self.productId = dict["productId"] as? Int ?? 0
        self.productName = dict["productName"] as? String ?? ""
        self.productImage = dict["productImage"] as? String ?? ""
        self.quantity = dict["quantity"] as? Int ?? 0
        self.price = dict["price"] as? Double ?? 0.00
        self.orderStatus = dict["orderStatus"] as? String ?? ""
        self.professionalDetailId = dict["professionalDetailId"] as? Int ?? 0
        self.professionalName = dict["professionalName"] as? String ?? ""
        self.orderDate = dict["orderDate"] as? String ?? ""
    }
}
