//
//  UserAccountRequetData.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 05/03/25.
//

import Foundation
class DeleteUserRequest: NSObject {

    static let shared = DeleteUserRequest()
    func accountDelete(id : Int, completion: @escaping (_ objectData: [AddressListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".DeleteAccount)")
        apiURL = String(format: "%@?Id=%@",apiURL,userId())
        print(apiURL)
        AlamofireRequest.shared.DeleteBodyFrom(urlString:apiURL, parameters: [:], authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError
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
