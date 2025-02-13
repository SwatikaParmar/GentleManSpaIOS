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
        apiURL = String(format:"%@?PageNumber=1&PageSize=1000&ProfessionalDetailId=%d&SearchQuery=%@&SpaDetailId=21", apiURL,professionalDetailId(), requestParams["SearchQuery"] as? String ?? "")

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

class ProAddProductRequest: NSObject {
    
    static let shared = ProAddProductRequest()
    func AddProductRequest(requestParams : [String:Any], completion: @escaping (_ productId: Int?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".AddProduct)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".AddProduct, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = GlobalConstants.serverError
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                            
                        if let productId = data?["data"]?["productId"] as? Int
                        {
                            completion(productId, messageString, status, "")
                        }
                        
                    }
                    else
                    {
                        completion(nil, messageString, status,"")
                    }
                }
                else
                {
                    completion(nil, "There was an error connecting to server.", false,"")
                }
            }
            else{
                completion(nil,"There was an error connecting to server.try again", false,"")
            }
        }
    }
}


class ProductDetailRequest: NSObject {

    static let shared = ProductDetailRequest()
    
    func ProductDetailRequestAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:ProductDetailModel?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".GetProductDetails)")
            apiURL = String(format:"%@?id=%d",apiURL,requestParams["id"] as? Int ?? 0)

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
                                 if let dataList = data?["data"] as? [String:Any]{
                                      
                                     let dict : ProductDetailModel = ProductDetailModel.init(fromDictionary: dataList )
                                        completion(dict,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                             }
                         }
                         else
                         {
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                    }
                }
            }
        }


class ProductDetailModel: NSObject {
    
    var stock = 0
    var serviceName = ""
    var serviceDescription = ""
    var basePrice = 0.00
    var listingPrice = 0.00
    var serviceIconImage = ""
    var mainCategoryId = 0
    var subCategoryId = 0
    var serviceImageArray = NSMutableArray()
    var mainCategoryName = ""
    var countInCart = 0
    var inStock = 0
    var productId = 0
    
    init(fromDictionary dictionary: [String:Any]){
        stock = dictionary["stock"] as? Int ?? 0
        serviceName = dictionary["name"] as? String ?? ""
        serviceDescription = dictionary["description"] as? String ?? ""
        basePrice = dictionary["basePrice"] as? Double ?? 0.00
        listingPrice = dictionary["listingPrice"] as? Double ?? 0.00
        serviceIconImage = dictionary["serviceIconImage"] as? String ?? ""
        mainCategoryId = dictionary["mainCategoryId"] as? Int ?? 0
        subCategoryId = dictionary["subCategoryId"] as? Int ?? 0
        mainCategoryName = dictionary["mainCategoryName"] as? String ?? ""
        countInCart = dictionary["countInCart"] as? Int ?? 0
        inStock = dictionary["stock"] as? Int ?? 0
        productId = dictionary["productId"] as? Int ?? 0

        if let dataList = dictionary["images"] as? NSArray{
               for list in dataList{
                   serviceImageArray.add(list)
            }
        }
        
    }
}

class ProUpdateProductRequest: NSObject {
    
    static let shared = ProUpdateProductRequest()
    func ProUpdateProduct(requestParams : [String:Any], completion: @escaping (_ productId: Int?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".UpdateProduct)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".UpdateProduct, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = GlobalConstants.serverError 
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                            
                        if let productId = data?["data"]?["productId"] as? Int
                        {
                            completion(productId, messageString, status, "")
                        }
                        
                    }
                    else
                    {
                        completion(nil, messageString, status,"")
                    }
                }
                else
                {
                    completion(nil, "There was an error connecting to server.", false,"")
                }
            }
            else{
                completion(nil,"There was an error connecting to server.try again", false,"")
            }
        }
    }
}


class ProDeleteProductRequest: NSObject {
    
    static let shared = ProDeleteProductRequest()
    func deleteProductRequest(requestParams : Int, completion: @escaping (_ productId: Int?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".DeleteProduct)
        print("Request---->> ",requestParams)
        
        var str = String(format: "%@?id=%d", "BaseURL".DeleteProduct, requestParams)
        
        AlamofireRequest.shared.DeleteBodyFrom(urlString: str, parameters: [:], authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = GlobalConstants.serverError 
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                            
                        
                            completion(nil, messageString, status, "")
                        
                        
                    }
                    else
                    {
                        completion(nil, messageString, status,"")
                    }
                }
                else
                {
                    completion(nil, "There was an error connecting to server.", false,"")
                }
            }
            else{
                completion(nil,"There was an error connecting to server.try again", false,"")
            }
        }
    }
}
