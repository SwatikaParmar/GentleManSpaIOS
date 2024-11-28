//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Valados on 06.11.2021.
//

import Foundation
import FirebaseDatabase
import CoreMedia
import CoreLocation
/// Manager object to read and write data to real time firebase database
final class DatabaseManager{
    public static let shared = DatabaseManager()
    static let database = Database.database(url: "https://gentlemanspa-18321-default-rtdb.firebaseio.com").reference()
   // static let database = Database.database(url: "https://chatapp-90b45-default-rtdb.firebaseio.com").reference()
}

class OnlineDatabaseManager{
    let myConnectionsRef = DatabaseManager.database.database.reference(withPath: String(format:"Users/%@/userState",(userId())))

}

// MARK: -  Account Management
extension DatabaseManager{
   
    public func userExists(with userID:String,
                           completion: @escaping ((Bool) -> Void)){
        
        let UsersRef = DatabaseManager.database.child("Users").child(userID)
        UsersRef.observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? [String : Any] != nil else{
                print("user doesnt exist")
                completion(false)
                return
            }
            print(snapshot.value!)
            print("user exists")
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, _ logout:String, completion: @escaping (Bool) -> Void){
         
        var onlineData = [
            "date": ChatController.dateFormatter.string(from: Date()),
            "state": logout,
            "time": ChatController.timeFormatter.string(from: Date())
        ]
        
        if "Logout" == logout {
            onlineData = [
                "date": ChatController.dateFormatter.string(from: Date()),
                "state": "offline",
                "time": ChatController.timeFormatter.string(from: Date())
            ]
        }
        
        if "offline" == logout {
            onlineData = [
                "date": ChatController.dateFormatter.string(from: Date()),
                "state": "offline",
                "time": ChatController.timeFormatter.string(from: Date())
            ]
        }
        
        
        var newElement = [
            "name": user.firstName,
            "gender": UserDefaults.standard.string(forKey: Constants.gender) ?? "",
            "email": user.emailAddress,
            "fcm_token": Constants.fcmTokenFirePuch,
            "image": user.profilePictureFileName,
            "uid":user.userID,
            "userState": onlineData,

        ] as [String : Any]
        
        if "Logout" == logout {
            newElement = [
                "name": user.firstName,
                "gender": UserDefaults.standard.string(forKey: Constants.gender) ?? "",
                "email": user.emailAddress,
                "fcm_token": "logout",
                "image": user.profilePictureFileName,
                "uid":user.userID,
                "userState": onlineData,

            ] as [String : Any]
        }
    
        let UsersRef = DatabaseManager.database.child("Users").child(user.userID)

        UsersRef.setValue(newElement,withCompletionBlock: {error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }

    public func getAllUsers(completion: @escaping(Result<[[String:String]], Error>) -> Void){
        DatabaseManager.database.child("Users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    public enum DatabaseError: Error{
        case failedToFetch
    }
}
// MARK: - Sending messages / conversations
extension DatabaseManager{
    
    ///Creates a new conversation with target user email and first message sent
    public func createNewConversation(with otherUserEmail:String, name: String,firstMessage: Message, completion: @escaping(Bool)->Void){
        
        DatabaseManager.database.child("Contacts").child(otherUserEmail).child(userId()).child("ContactStatus").updateChildValues(["BlockStatus": false,"Contact": "Saved"])
        
         DatabaseManager.database.child("Contacts").child(userId()).child(otherUserEmail).child("ContactStatus").updateChildValues(["BlockStatus": false,"Contact": "Saved"])
        
        self.finishCreatingConversation(otherUserID: otherUserEmail, name: name, firstMessage: firstMessage, completion: completion)

    }
    
    
    public func finishCreatingConversation(otherUserID: String, name: String, firstMessage: Message, completion: @escaping(Bool)->Void){
        

        guard let myUserID = userId() as? String else{
            completion(false)
            return
        }
        
    
        
        let myMessage = DatabaseManager.database.child("Messages").child(myUserID).child(otherUserID).childByAutoId()
     
        let collectionMessageForMe: [String:Any] = [
            "messageID": myMessage.key as Any,
            "date":firstMessage.sentDate,
            "time":firstMessage.sentTime,
            "from":firstMessage.from,
            "to":firstMessage.to,
            "type":firstMessage.type,
            "message":firstMessage.message
        ]
        
        
        let otherMessage = DatabaseManager.database.child("Messages").child(otherUserID).child(myUserID).child(myMessage.key ?? "1")
     
        let collectionMessage: [String:Any] = [
            "messageID": myMessage.key as Any,
            "date":firstMessage.sentDate,
            "time":firstMessage.sentTime,
            "from":firstMessage.from,
            "to":firstMessage.to,
            "type":firstMessage.type,
            "message":firstMessage.message
        ]
     
        myMessage.setValue(collectionMessageForMe, withCompletionBlock: {error, _ in
            guard error == nil else{
                completion(false)
                return
            }
            otherMessage.setValue(collectionMessage)
            
            let timestamp = Date().currentTimeMillis()

            let messageLast : [String:Any] =  [
                "date": ChatController.dateFormatter.string(from: Date()),
                "message": firstMessage.message,
                "time": ChatController.timeFormatter.string(from: Date()),
                "timeStamp": timestamp
            ]
            
            let UsersOther = DatabaseManager.database.child("Contacts").child(otherUserID).child(userId()).child("latest_message")
            UsersOther.setValue(messageLast)
            
            let UsersCurrent = DatabaseManager.database.child("Contacts").child(userId()).child(otherUserID).child("latest_message")
            UsersCurrent.setValue(messageLast)
            completion(true)
        })
    }
   

    
   
    
    public func conversationExists(with targetRecipientUserID:String, completion: @escaping (Result<String, Error>) -> Void){
        
        let otherID = targetRecipientUserID
        guard let myID = userId() as? String else{
            return
        }
        
        DatabaseManager.database.child("Contacts").observeSingleEvent(of: .value, with: {snapshot in
            
            guard let collection = snapshot.value as? [String:Any] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            // iterate and find conversation with target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0.key as? String else{
                    return false
                }
                return myID == targetSenderEmail
            }){
                
                guard let collection = conversation.value as? [String:Any] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                if let id = collection.first(where: {
                    guard let targetSenderEmail = $0.key as? String else{
                        return false
                    }
                    return otherID == targetSenderEmail
                }){
                    completion(.success(otherID))
                    return

                }
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
    }
    
    public func observeOnline() {
    
        let connectedRef = DatabaseManager.database.database.reference(withPath: ".info/connected")
            connectedRef.observe(.value, with: { snapshot in
               guard let connected = snapshot.value as? Bool, connected else { return }
    
                if UserDefaults.standard.bool(forKey: Constants.login){
                    let con =  OnlineDatabaseManager().myConnectionsRef.child("state")
                        con.onDisconnectSetValue("offline")
                        con.setValue("offline")

                    let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm a"
                        formatter.amSymbol = "AM"
                        formatter.pmSymbol = "PM"
                    let timeStamp = formatter.string(from: Date())
                
                    let time =  OnlineDatabaseManager().myConnectionsRef
                        time.onDisconnectUpdateChildValues(["time": timeStamp])

                    let formatterDate = DateFormatter()
                        formatterDate.dateFormat = "dd/MM/yyyy"
                    let dateStamp = formatterDate.string(from: Date())

                    let date =  OnlineDatabaseManager().myConnectionsRef
                    date.onDisconnectUpdateChildValues(["date": dateStamp])
                }
          })
        }
     }



struct ChatAppUser{
    let firstName: String
    let lastName: String
    let emailAddress:String
    var profilePictureFileName: String
    var userID: String
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
