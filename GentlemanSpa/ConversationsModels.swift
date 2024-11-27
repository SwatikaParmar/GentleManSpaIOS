//
//  ConversationsModels.swift
//  Messenger
//
//  Created by Valados on 18.11.2021.
//

import Foundation
import UIKit

struct Conversation{
    let id:String
    let name:String
    let gender:Int
    let otherUserEmail:String
    let imageUser:String
    let fcm:String
    let latestMessage: LatestMessage
    let onlineData: OnlineData

}
struct LatestMessage{
    let date: String
    let message: String
    let time: String
    let timeStamp: Int

}

struct OnlineData{
    let date: String
    let state: String
    let time: String
}


struct Message {
    public var from: String
    public var to: String
    public var messageId: String
    public var sentDate: String
    public var sentTime: String
    public var type: String
    public var message: String

}

struct Sender{
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct MediaData{
    var url: URL?
    var image: UIImage
    var placeholderImage: UIImage
    var size: CGSize
}

