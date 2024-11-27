//
//  LocationApiRequest.swift
//  SalonApp
//
//  Created by mac on 30/08/23.
//

import Foundation


class LiveLocationRequest: NSObject {

    static let shared = LiveLocationRequest()
    func liveLocationAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("\("Base".updateLiveLocation)")


        AlamofireRequest.shared.LivePostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader:false, loaderMessage: "") { (data, error) in
                
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(nil,messageString,true)

                             }else{
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



class GetAddressListRequest: NSObject {

    static let shared = GetAddressListRequest()
    func getLocationList(requestParams : [String:Any], _ isLoader : Bool, completion: @escaping (_ objectData: [AddressListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("\("Base".GetCustomerAddressList)")

        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 var homeListObject : [AddressListModel] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : AddressListModel = AddressListModel.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 completion(nil,messageString,false)
                             }
                         }
                         else
                         {
                             completion(nil," ",false)
                         }
                        }
                        else
                        {
                            completion(nil,"",false)
                }
            }
        }
}


class AddressListModel: NSObject {
    
    var addressLatitude = ""
    var addressLongotude = "";
    var addressType = "";
    var alternatePhoneNumber = "";
    var city = "";
    var crateDate = "";
    var customerAddressId = 0;
    var customerUserId = "";
    var fullName = "";
    var houseNoOrBuildingName = "";
    var nearbyLandMark = "";
    var phoneNumber = "";
    var pincode = "";
    var state = "";
    var status = 0;
    var streetAddresss = "";
    
 
    
    init(fromDictionary dictionary: [String:Any]){
        
        addressLatitude = dictionary["addressLatitude"] as? String ?? ""
        addressLongotude = dictionary["addressLongotude"] as? String ?? ""
        addressType = dictionary["addressType"] as? String ?? ""
        alternatePhoneNumber = dictionary["alternatePhoneNumber"] as? String ?? ""
        city = dictionary["city"] as? String ?? ""
        crateDate = dictionary["crateDate"] as? String ?? ""
        customerAddressId = dictionary["customerAddressId"] as? Int ?? 0
        customerUserId = dictionary["customerUserId"] as? String ?? ""
        fullName = dictionary["fullName"] as? String ?? ""
        houseNoOrBuildingName = dictionary["houseNoOrBuildingName"] as? String ?? ""
        nearbyLandMark = dictionary["nearbyLandMark"] as? String ?? ""
        phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        pincode = dictionary["pincode"] as? String ?? ""
        state = dictionary["state"] as? String ?? ""
        status = dictionary["status"] as? Int ?? 0
        streetAddresss = dictionary["streetAddresss"] as? String ?? ""

    }
}


class SetCustomerAddressRequest: NSObject {

    static let shared = SetCustomerAddressRequest()
    
    func SetCustomerAddressAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("\("Base".setCustomerAddressStatus)")

        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader:false, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,true)

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
                         
                            completion(nil,"",false)
                        }
                }
            }
        }







class AddCustomerAddressRequest: NSObject {

    static let shared = AddCustomerAddressRequest()
    
    func addAddressAPI(requestParams : [String:Any], completion: @escaping (_ objectData: AddressModel?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("\("Base".addCustomerAddress)")


        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader:true, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 
                                 if let result = data!["data"] as? [String : Any]{
                                     let userModel : AddressModel = AddressModel.init(fromDictionary: result)
                                     completion(userModel,messageString,true)
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
                         
                            completion(nil,"",false)
                    }
                }
            }
        }



class AddressModel: NSObject{
    
    var customerAddressId = 0
   
    init(fromDictionary dictionary: [String:Any]){
        
        customerAddressId = dictionary["customerAddressId"] as? Int ?? 0
        
    }
    
}



class UpdateCustomerAddressRequest: NSObject {

    static let shared = UpdateCustomerAddressRequest()
    
    func updateAddressAPI(requestParams : [String:Any], completion: @escaping (_ objectData: AddressModel?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".updateCustomerAddress)")


        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader:true, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 
                                 if let result = data!["data"] as? [String : Any]{
                                     let userModel : AddressModel = AddressModel.init(fromDictionary: result)
                                     completion(userModel,messageString,true)
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
                            completion(nil,"",false)
                        }
                }
            }
        }


class AddressDeleteRequest: NSObject {

    static let shared = AddressDeleteRequest()
    func addressDelete(id : Int, completion: @escaping (_ objectData: [AddressListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".deleteCustomerAddress)")
        apiURL = String(format: "%@?customerAddressId=%d",apiURL,id)
        print(apiURL)
        AlamofireRequest.shared.DeleteBodyFrom(urlString:apiURL, parameters: [:], authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 let homeListObject : [AddressListModel] = []
                                  completion(homeListObject,messageString,true)
                                 
                             }else{
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

