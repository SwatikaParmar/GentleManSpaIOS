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
        var professionalImage: String?

        
        
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
            self.professionalImage = dict["professionalImage"] as? String ?? ""

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


class CancelOrderServiceRequest: NSObject {

    static let shared = CancelOrderServiceRequest()
    
    func CancelOrderAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".CancelOrder)
        
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





class GetOrderDetailRequest: NSObject{
    
    static let shared = GetOrderDetailRequest()
    
    func GetOrderDetail(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [OrderDetails]?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".GetOrderDetail)
        
        apiURL = String(format:"%@/%d",apiURL,requestParams["orderId"] as? Int ?? 0)
        
        
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
                        var homeListObject : [OrderDetails] = []
                        if let list = data?["data"] as? [String : Any]{
                            let dict : OrderDetails = OrderDetails.init(dict: list )
                                homeListObject.append(dict)
                            
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
class OrderDetails: NSObject {
    var orderId: Int
    var orderDate: String
    var totalOrder: Int
    var servicesCount: Int
    var productsCount: Int
    var orderStatus: String
    var totalAmount: Double
    var cancelledAmount: Int
    var refundedAmount: Int
    var paybleAmount: Int
    var customerName: String
    var delieveryType: String
    var paymentType: String
    var paymentStatus: String?
    var customerAddressId: String?
    var services: [OrderService] = []
    var products: [OrderProduct] = []
    var customerAddress: String?

    init(dict: [String: Any]) {
        self.orderId = dict["orderId"] as? Int ?? 0
        self.orderDate = dict["orderDate"] as? String ?? ""
        self.totalOrder = dict["totalOrder"] as? Int ?? 0
        self.servicesCount = dict["servicesCount"] as? Int ?? 0
        self.productsCount = dict["productsCount"] as? Int ?? 0
        self.orderStatus = dict["orderStatus"] as? String ?? ""
        self.totalAmount = dict["totalAmount"] as? Double ?? 0.00
        self.cancelledAmount = dict["cancelledAmount"] as? Int ?? 0
        self.refundedAmount = dict["refundedAmount"] as? Int ?? 0
        self.paybleAmount = dict["paybleAmount"] as? Int ?? 0
        self.customerName = dict["customerName"] as? String ?? ""
        self.delieveryType = dict["delieveryType"] as? String ?? ""
        self.paymentType = dict["paymentType"] as? String ?? ""
        self.paymentStatus = dict["paymentStatus"] as? String
        self.customerAddressId = dict["customerAddressId"] as? String
        self.customerAddress = dict["customerAddress"] as? String

        if let dataList = dict["services"] as? NSArray{
               for list in dataList{
                   let dict : OrderService = OrderService.init(dict: list as! [String : Any])
                   services.append(dict)
            }
        }
        

    
        if let dataList = dict["products"] as? NSArray{
               for list in dataList{
                   let dict : OrderProduct = OrderProduct.init(dict: list as! [String : Any])
                   products.append(dict)
            }
        }
    }
}

class OrderService: NSObject {
    var orderId: Int
    var spaServiceId: Int
    var slotId: Int
    var serviceBookingId: Int
    var serviceName: String
    var image: String?
    var slotDate: String
    var fromTime: String
    var toTime: String
    var price: Double
    var professionalDetailId: Int
    var professionalName: String
    var professionalImage: String?
    var orderStatus: String
    var orderDate: String?

    init(dict: [String: Any]) {
        self.orderId = dict["orderId"] as? Int ?? 0
        self.spaServiceId = dict["spaServiceId"] as? Int ?? 0
        self.slotId = dict["slotId"] as? Int ?? 0
        self.serviceBookingId = dict["serviceBookingId"] as? Int ?? 0
        self.serviceName = dict["serviceName"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.slotDate = dict["slotDate"] as? String ?? ""
        self.fromTime = dict["fromTime"] as? String ?? ""
        self.toTime = dict["toTime"] as? String ?? ""
        self.price = dict["price"] as? Double ?? 0.00
        self.professionalDetailId = dict["professionalDetailId"] as? Int ?? 0
        self.professionalName = dict["professionalName"] as? String ?? ""
        self.professionalImage = dict["professionalImage"] as? String
        self.orderStatus = dict["orderStatus"] as? String ?? ""
        self.orderDate = dict["orderDate"] as? String
    }
}

class OrderProduct: NSObject {
    var orderId: Int
    var productId: Int
    var productName: String
    var productImage: String?
    var quantity: Int
    var price: Double
    var orderStatus: String
    var professionalDetailId: Int
    var professionalName: String
    var orderDate: String?

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
        self.orderDate = dict["orderDate"] as? String
    }
}
