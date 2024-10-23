//
//  AddProductCartAPI.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/09/24.
//

import Foundation
class AddOrUpdateProductInCartRequest: NSObject {

    static let shared = AddOrUpdateProductInCartRequest()
    
    func addProductAPI(requestParams : [String:Any], _ isLoader : Bool, completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".AddOrUpdateProductInCart)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
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



class GetProductCartRequest: NSObject {

    static let shared = GetProductCartRequest()
    
    func GetCartItemsAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: CartDataModel?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool, _ totalAmount: Double) -> Void) {

        let apiURL = String("Base".GetCartItems)
        
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




class CartDataModel: NSObject {

    var totalItem = 0
    var totalMrp = 0.00
    var totalDiscount = 0.00
    var totalDiscountAmount = 0.00
    var totalSellingPrice = 0.00
    var salonCount = 0
    var morningDailyDeliveryTime = 0
    var eveningDailyDeliveryTime = 0
    var allCartProductArray : [AllCartProducts] = []

    
    init(fromDictionary dictionary: [String:Any]) {
        totalItem = dictionary["totalItem"] as? Int ?? 0
        totalMrp = dictionary["totalMrp"] as? Double ?? 0.00
        totalDiscount = dictionary["totalDiscount"] as? Double ?? 0.00
        totalDiscountAmount = dictionary["totalDiscount"] as? Double ?? 0.00
        totalSellingPrice = dictionary["totalSellingPrice"] as? Double ?? 0.00

        
        if let dataList = dictionary["products"] as? NSArray{
               for list in dataList{
                   let dict : AllCartProducts = AllCartProducts.init(fromDictionary: list as! [String : Any])
                   allCartProductArray.append(dict)
            }
        }

        
    }
}
class AllCartProducts: NSObject {
    
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
    var inStock = 0
    var genderPreferences = ""
    var isSlotAvailable = 0
    var serviceType = ""
    var productCountInCart = 0
    
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
        serviceImage = dictionary["productImage"] as? String ?? ""
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        inStock = dictionary["stock"] as? Int ?? 0
        genderPreferences = dictionary["genderPreferences"] as? String ?? ""
        isSlotAvailable = dictionary["isSlotAvailable"] as? Int ?? 0
        serviceType = dictionary["serviceType"] as? String ?? ""
        productCountInCart = dictionary["countInCart"] as? Int ?? 0

    }
    
}


class cartServicesDataModel: NSObject {

    var totalItem = 0
    var totalMrp = 0.00
    var totalDiscount = 0.00
    var totalDiscountAmount = 0.00
    var totalSellingPrice = 0.00
    var salonCount = 0
    var morningDailyDeliveryTime = 0
    var durationInMinutes = 0
    var allServicesArray : [AllCartServices] = []

    
    init(fromDictionary dictionary: [String:Any]) {
        totalItem = dictionary["totalItem"] as? Int ?? 0
        totalMrp = dictionary["totalMrp"] as? Double ?? 0.00
        totalDiscount = dictionary["totalDiscount"] as? Double ?? 0.00
        totalDiscountAmount = dictionary["totalDiscount"] as? Double ?? 0.00
        totalSellingPrice = dictionary["totalSellingPrice"] as? Double ?? 0.00
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        
        if let dataList = dictionary["services"] as? NSArray{
               for list in dataList{
                   let dict : AllCartServices = AllCartServices.init(fromDictionary: list as! [String : Any])
                   allServicesArray.append(dict)
            }
        }

        
    }
}


class AllCartServices: NSObject {
    
    var productId = 0
    var slotId = 0
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
    var inStock = 0
    var genderPreferences = ""
    var isSlotAvailable = 0
    var serviceType = ""
    var serviceCountInCart = 0
    var spaServiceId = 0
    var serviceId = 0
    var slotDate = ""
    var fromTime = ""
    var professionalName = ""
    var professionalImage : String?

    init(fromDictionary dictionary: [String:Any]){
        productId = dictionary["productId"] as? Int ?? 0
        salonName = dictionary["salonName"] as? String ?? ""
        slotId = dictionary["slotId"] as? Int ?? 0
        mainCategoryName = dictionary["mainCategoryName"] as? String ?? ""
        mainCategoryId = dictionary["categoryId"] as? Int ?? 0
        subCategoryName = dictionary["subCategoryName"] as? String ?? ""
        serviceName = dictionary["name"] as? String ?? ""
        serviceDescription = dictionary["description"] as? String ?? ""
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
        basePrice = dictionary["basePrice"] as? Double ?? 0.00
        serviceImage = dictionary["serviceIconImage"] as? String ?? ""
        durationInMinutes = dictionary["durationInMinutes"] as? Int ?? 0
        inStock = dictionary["stock"] as? Int ?? 0
        genderPreferences = dictionary["genderPreferences"] as? String ?? ""
        isSlotAvailable = dictionary["isSlotAvailable"] as? Int ?? 0
        serviceType = dictionary["serviceType"] as? String ?? ""
        serviceCountInCart = dictionary["serviceCountInCart"] as? Int ?? 0
        spaServiceId = dictionary["spaServiceId"] as? Int ?? 0
        serviceId = dictionary["serviceId"] as? Int ?? 0
        slotDate = dictionary["slotDate"] as? String ?? ""
        fromTime = dictionary["fromTime"] as? String ?? ""
        
        professionalName = dictionary["professionalName"] as? String ?? "".capitalized
        professionalName = professionalName.capitalized
        
        professionalImage = dictionary["professionalImage"] as? String ?? ""

    }
    
}



class AddUpdateCartServiceRequest: NSObject {

    static let shared = AddUpdateCartServiceRequest()
    
    func AddUpdateCartServiceAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".AddUpdateCartService)
        
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



class RescheduleServiceRequest: NSObject {

    static let shared = RescheduleServiceRequest()
    
    func RescheduleAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".RescheduleService)
        
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


