//
//  MessagesController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 10/10/24.
//

import UIKit
import Firebase
import FirebaseDatabase
class MessagesController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var noUserView: UIView!

    @IBOutlet weak var tableView: UITableView!
    private var conversations = [Conversation]()
    private var conversationsSort = [Conversation]()

    var friendArray = [String]()

    var friendArrayList = [[String: Any]]()
    var friendLastMessage = [[String: Any]]()

    
    private var friendRefHandle: DatabaseHandle?
    let ContactsRef = DatabaseManager.database.child("Contacts").child(userId())
    
    private var userRefHandle: DatabaseHandle?
    let UsersRef = DatabaseManager.database.child("Users")

    
    
    @objc func ChatUserList_ObserverRemove(_ notification: NSNotification) {
        if let count = notification.userInfo?["count"] as? String {
            if count == "DeleteAccount" {
                if let refHandle = friendRefHandle{
                    ContactsRef.removeObserver(withHandle: refHandle)
                }
                
                if let refHandle = userRefHandle{
                    UsersRef.removeObserver(withHandle: refHandle)
                }
            }
            else{
                
                if let refHandle = friendRefHandle{
                    ContactsRef.removeObserver(withHandle: refHandle)
                }
                
                NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "ChatUserList_ObserverRemove"), object: nil)

            }
        }
    }
    
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
        self.noUserView.isHidden = true

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ChatUserList_ObserverRemove), name: NSNotification.Name(rawValue: "ChatUserList_ObserverRemove"), object: nil)

        self.friendLastMessage.removeAll()
        self.friendArrayList.removeAll()
        self.conversations.removeAll()
        self.tableView.reloadData()
        
        if let refHandle = friendRefHandle{
            ContactsRef.removeObserver(withHandle: refHandle)
        }
        getAllConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        

    }
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func startListeningForConversations(_ userID:String){
        
        if let refHandle = userRefHandle{
            UsersRef.removeObserver(withHandle: refHandle)
        }

        userRefHandle = UsersRef.child(userID).observe(.value, with: {snapshot in
            guard let dictionaryData = snapshot.value as? [String: Any] else{
                return
            }
            
            if let dictionary = snapshot.value as? [String: Any] {
                if !self.friendArrayList.contains(where: { (friend) -> Bool in
                    friend["uid"] as? String == dictionary["uid"] as? String
                }){
                    
                    let conversationId = dictionary["uid"] as? String
                    let name = dictionary["name"] as? String
                    let gender = dictionary["gender"] as? Int
                    let otherUserEmail = dictionary["email"] as? String
                    let latestMessage = dictionary["userState"] as? [String:Any]
                    let date = latestMessage?["date"] as? String
                    let state = latestMessage?["state"] as? String
                    let fcm_token = dictionary["fcm_token"] as? String
                    let image = dictionary["image"] as? String
                    let time = latestMessage?["time"] as? String

                    let OnlineData = OnlineData(date: date ?? "",
                                                            state: state ?? "",
                                                            time: time ?? "")
                    
                    
                    var dateStr = ""
                    var messageStr = ""
                    var timeStr = ""
                    var timeStamp = 0


                    let index = self.friendLastMessage.firstIndex(where: { (friend) -> Bool in
                        friend["userID"] as? String == dictionary["uid"] as? String
                    })
                    if index != nil {
                        
                        if let dictionary = self.friendLastMessage[index ?? 0]["latest_message"] as? [String: Any]{
                            dateStr   = dictionary["date"] as? String ?? ""
                            messageStr  = dictionary["message"] as? String ?? ""
                            timeStr = dictionary["time"] as? String ?? ""
                            timeStamp = dictionary["timeStamp"] as? Int ?? 0
                        }
                        
                
                    let latestMessageData = LatestMessage(date:dateStr,
                                                          message:messageStr ,
                                                          time: timeStr, timeStamp: timeStamp )
                        
                        
                    let data = Conversation(id: conversationId ?? "",
                                            name: name ?? "", gender: gender ?? 0,
                                            otherUserEmail: otherUserEmail ?? "", imageUser: image ?? "", fcm: fcm_token ?? "",
                                                latestMessage: latestMessageData,
                                                onlineData : OnlineData)
                        
                        self.conversations.append(data)
                        self.friendArrayList.append(dictionary)

                        let sortedPost = self.conversations.sorted{ $0.latestMessage.timeStamp > $1.latestMessage.timeStamp  }
                        
                        self.conversationsSort = sortedPost
                        DispatchQueue.main.async {
                           self.tableView.reloadData()
                        }
                    }
                    return
                }
                
                
                
                
                let index = self.friendArrayList.firstIndex(where: { (friend) -> Bool in
                    friend["uid"] as? String == dictionary["uid"] as? String
                })
                
                if index != nil {
                    if self.conversations.count > index ?? 0{
                    self.conversations.remove(at: index ?? 0)
                    self.friendArrayList.remove(at: index ?? 0)
                    
                    let conversationId = dictionary["uid"] as? String
                    let name = dictionary["name"] as? String
                    let gender = dictionary["gender"] as? Int

                    let otherUserEmail = dictionary["email"] as? String
                    let latestMessage = dictionary["userState"] as? [String:Any]
                    let date = latestMessage?["date"] as? String
                    let state = latestMessage?["state"] as? String
                    let fcm_token = dictionary["fcm_token"] as? String
                    let image = dictionary["image"] as? String
                    let time = latestMessage?["time"] as? String

                    let OnlineData = OnlineData(date: date ?? "",
                                                                state: state ?? "",
                                                                time: time ?? "")
                        
                        var dateStr = ""
                        var messageStr = ""
                        var timeStr = ""
                        var timeStamp = 0

                        let index = self.friendLastMessage.firstIndex(where: { (friend) -> Bool in
                            friend["userID"] as? String == dictionary["uid"] as? String
                        })
                        if index != nil {
                            
                            if let dictionary = self.friendLastMessage[index ?? 0]["latest_message"] as? [String: Any]{
                                dateStr   = dictionary["time"] as? String ?? ""
                                messageStr  = dictionary["message"] as? String ?? ""
                                timeStr = dictionary["time"] as? String ?? ""
                                timeStamp = dictionary["timeStamp"] as? Int ?? 0

                            }
                            
                        }
                        
                        let latestMessageData = LatestMessage(date:dateStr,
                                                              message:messageStr ,
                                                              time: timeStr, timeStamp: timeStamp )
                        
                        
                        let data = Conversation(id: conversationId ?? "",
                                                name: name ?? "", gender: gender ?? 0,
                                            otherUserEmail: otherUserEmail ?? "", imageUser: image ?? "", fcm: fcm_token ?? "",
                                                latestMessage: latestMessageData,
                                                onlineData : OnlineData)
                    
                        self.conversations.append(data)
                        self.friendArrayList.append(dictionary)

                        let sortedPost = self.conversations.sorted{ $0.latestMessage.timeStamp > $1.latestMessage.timeStamp  }
                        self.conversationsSort = sortedPost
                     DispatchQueue.main.async {
                       self.tableView.reloadData()
                     }
                }
                }
            }
        })
    }
    
   
    
    
    ///Fetches and returns all the conversations for the user with passed in email
    public func getAllConversations(){
        
        friendRefHandle = ContactsRef.observe(.value, with: { (snapshot) in

            guard snapshot.key as? String != nil else{
                print("user doesnt exist")
                self.noUserView.isHidden = false
                return
            }
            self.friendLastMessage.removeAll()
            self.friendArrayList.removeAll()
            self.conversations.removeAll()
            self.tableView.reloadData()
            
            
            let childern = snapshot.children
            for child in childern{
                let key = (child as AnyObject).key as String
                print("key :- ",key)

                let newChild = child as! DataSnapshot
                if let checkID = newChild.value as? [String: Any]{
                    var emptyDictionary = [String: Any]()
                    emptyDictionary = checkID
                    emptyDictionary["userID"] = key
                    self.friendLastMessage.append(emptyDictionary)

                }
            }
            print("Array :- ",self.friendLastMessage.count)

            if self.friendLastMessage.count > 0 {
                self.noUserView.isHidden = true
            }
            else{
                self.conversations.removeAll()
                self.friendArrayList.removeAll()
                self.conversationsSort.removeAll()
                DispatchQueue.main.async {
                  self.tableView.reloadData()
                }
                self.noUserView.isHidden = false
                
            }
            for i in 0..<self.friendLastMessage.count {
                let firstObject = self.friendLastMessage[i]
                self.startListeningForConversations(firstObject["userID"] as! String)
            }
        })
    }


    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  self.conversationsSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        
        cell.imgView.layer.masksToBounds = true
        cell.imgView.layer.cornerRadius = 32.5
        cell.imgView.layer.borderWidth = 0.5
        cell.imgView.layer.backgroundColor = UIColor.darkGray.cgColor
        if self.conversationsSort.count > indexPath.row {
            cell.lbeName.text =   self.conversationsSort[indexPath.row].name.capitalized
            cell.lbeLastMessage.text =   self.conversationsSort[indexPath.row].latestMessage.message
            cell.lbeTime.text =   self.conversationsSort[indexPath.row].latestMessage.time.uppercased()

            
            
            let imagePath = String("\(GlobalConstants.BASE_IMAGE_URL)\( self.conversationsSort[indexPath.row].imageUser)")
            let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgView.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))

            
            cell.lbeOnline.layer.cornerRadius = 8
            cell.lbeOnline.clipsToBounds = true
            if self.conversationsSort[indexPath.row].onlineData.state == "online"{
                cell.lbeOnline.isHidden = false
            }
            else{
                cell.lbeOnline.isHidden = true
            }
        }
   
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if self.conversationsSort.count > indexPath.row {

            let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
        controller.isNewConversation = false
        controller.otherUserEmail =  self.conversationsSort[indexPath.row].otherUserEmail
        controller.userName =  self.conversationsSort[indexPath.row].name.capitalized
        controller.imgString =  self.conversationsSort[indexPath.row].imageUser
        controller.otherUserID =  self.conversationsSort[indexPath.row].id

        self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            if self.conversationsSort.count > indexPath.row {

            let conversationId = conversationsSort[indexPath.row].id
            let alertController = UIAlertController(title: "", message: "Are you sure you want to delete all chat with this user?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                self.deleteConversation(conversationId: conversationId, index: indexPath.row)

            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            }
    
        }
    }
    
    
    public func deleteConversation(conversationId:String, index:Int){
       
        let refData = DatabaseManager.database.child("Contacts").child(userId()).child(conversationId)
        let myMessage = DatabaseManager.database.child("Messages").child(userId()).child(conversationId)
        myMessage.removeValue { (error, ref) in
               if error != nil {
               }
            else{
                refData.removeValue { (error, ref) in
                       if error != nil {
                       }
                    else{
                        DispatchQueue.main.async {
                           self.tableView.reloadData()
                        }
                   }
                }
              }
           }
        }
}


class MessagesCell: UITableViewCell {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeLastMessage : UILabel!
    @IBOutlet weak var lbeTime : UILabel!
    @IBOutlet weak var lbeOnline : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


