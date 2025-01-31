//
//  UserChatRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 30/01/25.
//

import Foundation
class AddUserToChatRequest: NSObject {

    static let shared = AddUserToChatRequest()
    
    func AddUserToChatAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".addusertochat)
        
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
                                 completion(nil,messageString,false)
                             }
                         }else{
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

class GetMessageReplysRequest: NSObject {
        
        static let shared = GetMessageReplysRequest()
        
        func GetMessageReplysAPI(_ url : String ,_ isLoader:Bool, completion: @escaping (_ objectData: [ComplaintReply]?,_ message : String?, _ isStatus : Bool) -> Void) {
            
            AlamofireRequest.shared.GetBodyFrom(urlString:url, parameters: [:], authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
               // print(data ?? "No data")
                if error == nil{
                    var messageString : String = ""
                    if let status = data?["isSuccess"] as? Bool{
                        if let msg = data?["messages"] as? String{
                            messageString = msg
                        }
                        if status{
                            var arrayObject : [ComplaintReply] = []
                            if let dataArray = data?["data"] as? [String: Any] {
                                            let dict : ComplaintReply = ComplaintReply.init(dict: dataArray)
                                            arrayObject.append(dict)

                                        
                                completion(arrayObject,messageString,true)

                                    }
                            }else{
                                completion(nil,messageString,false)
                            }
                        
                    }else{
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)

                    }
                }
            }
        }
    }
class ComplaintReply: NSObject {
    
        var receiverOnlineStatus: Int
        var replies: [MessagingList] = []
    
    init(dict: [String: Any]) {
        self.receiverOnlineStatus = dict["receiverOnlineStatus"] as? Int ?? 0

        if let slotsArray = dict["messages"] as? [[String: Any]] {
            for slot in slotsArray {
                self.replies.append(MessagingList(dict: slot))
            }
        }
    }
}

class MessagingList: NSObject {
    
    var type: String
    var sentTime: String
    var message : String
    var id = 0
    var senderId : String

    init(dict: [String: Any]) {
        self.type = dict["messageType"] as? String ?? ""
        self.message = dict["messageContent"] as? String ?? ""
        self.sentTime = dict["timestamp"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.senderId = dict["senderUserName"] as? String ?? ""


    }
}
class SendReplyRequest: NSObject {

    static let shared = SendReplyRequest()

    func AddReplyAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".messagesSend)
        let urlString = apiURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlString)
        print(requestParams)

        AlamofireRequest.shared.PostBodyForRawData(urlString:urlString, parameters: requestParams, authToken:accessToken(), isLoader: false, loaderMessage: "") { (data, error) in
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
                             completion(nil,messageString,false)
                         }
                     }else{
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

class GetChatUserListRequest: NSObject {
        
        static let shared = GetChatUserListRequest()
        
        func GetChatUserListAPI(_ url : String ,_ isLoader:Bool, completion: @escaping (_ objectData: [UserMessagingList]?,_ message : String?, _ isStatus : Bool) -> Void) {
            
            AlamofireRequest.shared.GetBodyFrom(urlString:url, parameters: [:], authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                print(data ?? "No data")
                if error == nil{
                    var messageString : String = ""
                    if let status = data?["isSuccess"] as? Bool{
                        if let msg = data?["messages"] as? String{
                            messageString = msg
                        }
                        if status{
                            var arrayObject : [UserMessagingList] = []
                            if let dataArray = data?["data"] as? [[String: Any]] {
                                        for item in dataArray {
                                            let dict : UserMessagingList = UserMessagingList.init(dict: item)
                                            arrayObject.append(dict)

                                        }
                                completion(arrayObject,messageString,true)

                                    }
                            }else{
                                completion(nil,messageString,false)
                            }
                        
                    }else{
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)

                    }
                }
            }
        }
    }



class UserMessagingList: NSObject {
    
    var id:String
    var name:String
    var imageUser:String
    var firstName:String
    var lastName:String
    var lastMessage:String

    var onlineData = 0
    
    init(dict: [String: Any]) {
        self.id = dict["userName"] as? String ?? ""
        self.imageUser = dict["profilePic"] as? String ?? ""
        self.firstName = dict["firstName"] as? String ?? ""
        self.lastName = dict["lastName"] as? String ?? ""
        self.lastMessage = dict["lastMessage"] as? String ?? ""

        self.onlineData = dict["onlineStatus"] as? Int ?? 0
        
        self.name = (self.firstName) + " " + (self.lastName)
        name = name.capitalized

    }
}



class MessageDeleteRequest: NSObject {

    static let shared = MessageDeleteRequest()
    func MessageDeleteAPI(id : Int, completion: @escaping (_ objectData: [AddressListModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = String("\("Base".deleteMessages)")
        apiURL = String(format: "%@/%d",apiURL,id)
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
