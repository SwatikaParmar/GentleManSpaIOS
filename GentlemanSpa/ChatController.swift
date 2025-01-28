//
//  ChatController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 28/10/24.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FirebaseDatabase
class ChatController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lbeUserName: UILabel!
    @IBOutlet weak var lbeOnline: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var bottomConstraintViewChat: NSLayoutConstraint!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myMessageDelete: UIView!
    
    @IBOutlet weak var otherMessageDelete: UIView!
    
    @IBOutlet weak var effectMessageDelete: UIVisualEffectView!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var unBlockView: UIView!
    @IBOutlet weak var btnUnBlock: UIButton!
    @IBOutlet weak var lbeBlock: UILabel!
    
    @IBOutlet weak var imgDots: UIImageView!
    @IBOutlet weak var btnBlock: UIButton!
    
    
    
    var imgString = ""
    var userName = ""
    var fcm = ""
    var isNewConversation = false
    var otherUserEmail = ""
    var otherUserID = ""
    var lastContentOffset: CGFloat = 0
    var pageNumberCount = 1
    var isLoadMore = false
    var deleteIndex = 0
    var isBlockByMe = false
    var isBlockByOther = false
    
    
    private var messages = [Message]()
    private var newMessageRefHandle: DatabaseHandle?
    
    let kReuseIdentifierChatRightTextTableCell  = "ChatRightTextTableCell"
    let kReuseIdentifierRightImageSTableCell   = "RightImageSTableCell"
    
    let kReuseIdentifierChatLeftTextTableCell   = "ChatLeftTextTableCell"
    let kReuseIdentifierChatLeftImageSTableCell   = "LeftImageCell"
    
    
    private var userRefHandle: DatabaseHandle?
    let UsersRef = DatabaseManager.database.child("Users")
    private var blockMeRefHandle: DatabaseHandle?
    private var blockOtherRefHandle: DatabaseHandle?
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    public static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter
    }()
    
    
     func timeConversion12(time24: String) -> String {
         let dateAsString = time24
             let df = DateFormatter()
             df.dateFormat = "HH:mm"

         let date = df.date(from: dateAsString) ?? Date()
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en-US")
         formatter.dateFormat = "hh:mm a"
         formatter.amSymbol = "AM"
         formatter.pmSymbol = "PM"
         let time12 = formatter.string(from: date)
     
         return time12
       
      
    }
    
    
   
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func Block_User_Back(_ notification: NSNotification) {
        
        if let refHandle = userRefHandle{
            UsersRef.removeObserver(withHandle: refHandle)
        }
        
        
        
        
        
        //        let refData = DatabaseManager.database.child("Contacts").child(AppUser.userId).child(otherUserID)
        //        let myMessage = DatabaseManager.database.child("Messages").child(AppUser.userId).child(otherUserID)
        //            myMessage.removeValue { (error, ref) in
        //                   if error != nil {
        //                   }
        //                else{
        //                    refData.removeValue { (error, ref) in
        //                           if error != nil {
        //                           }
        //                        else{
        //                       }
        //                    }
        //                  }
        //               }
        //
        //
        //        let refDataOther = DatabaseManager.database.child("Contacts").child(otherUserID).child(AppUser.userId)
        //        refDataOther.removeValue { (error, ref) in
        //               if error != nil {
        //               }
        //            else{
        //
        //           }
        //        }
        //
        //        let myMessageOther = DatabaseManager.database.child("Messages").child(otherUserID).child(AppUser.userId)
        //        myMessageOther.removeValue { (error, ref) in
        //               if error != nil {
        //               }
        //            else{
        //
        //           }
        //        }
        //
        //
        //        self.navigationController?.popViewController(animated: true)
        //        self.navigationController?.popToRootViewController(animated: true)
        //
        //        NotificationCenter.default.post(name: Notification.Name("Show_Home_Class"), object: nil, userInfo: ["TypeScreen":"Home"])
        
        
    }
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 75
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Block_User_Back), name: NSNotification.Name(rawValue: "Block_User"), object: nil)
        
        imgViewUser.layer.masksToBounds = true
        imgViewUser.layer.cornerRadius = 25
        imgViewUser.layer.borderWidth = 2
        imgViewUser.layer.borderColor = UIColor.white.cgColor
        myMessageDelete.isHidden = true
        otherMessageDelete.isHidden = true
        effectMessageDelete.isHidden = true
        
        let imagePath = String("\(GlobalConstants.BASE_IMAGE_URL)\(imgString)")
        
        let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        imgViewUser.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))
        lbeUserName.text = userName
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatRightTextTableCell, bundle: nil), forCellReuseIdentifier: kReuseIdentifierChatRightTextTableCell)
        
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierRightImageSTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierRightImageSTableCell)
        
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatLeftTextTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierChatLeftTextTableCell)
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatLeftImageSTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierChatLeftImageSTableCell)
        
        self.tblView.separatorStyle = .none
        self.textMessage.backgroundColor = UIColor.clear
        self.textMessage.isScrollEnabled = false
        self.textMessage.text = ""
        
        if let refHandle = userRefHandle{
            UsersRef.removeObserver(withHandle: refHandle)
        }
        userRefHandle = UsersRef.child(otherUserID).observe(.value, with: {snapshot in
            guard let dictionaryData = snapshot.value as? [String: Any] else{
                return
            }
            if let dictionary = snapshot.value as? [String: Any] {
                self.userName = dictionary["name"] as? String ?? "".capitalized
                self.fcm = dictionary["fcm_token"] as? String ?? ""
                self.imgString = dictionary["image"] as? String ?? ""
                let imagePath = String("\(GlobalConstants.BASE_IMAGE_URL)\(self.imgString)")
                let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                if dictionary["gender"] as? Int ?? 0 == 0  || dictionary["gender"] as? Int ?? 0 == 1{
                    self.imgViewUser.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))
                    
                }
                else if dictionary["gender"] as? Int ?? 0 == 2  || dictionary["gender"] as? Int ?? 0 == 3{
                    self.imgViewUser.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.FemalePlaceHolding))
                    
                }
                
                self.lbeUserName.text = self.userName.capitalized
                let latestMessage = dictionary["userState"] as? [String:Any]
                let time = latestMessage?["time"] as? String
                let state = latestMessage?["state"] as? String
                if state == "online"{
                    self.lbeOnline.text = "online"
                }
                else{
                    self.lbeOnline.text = String(format: "Last seen: %@", time ?? "")
                }
                
            }
        })
        
        self.lbeBlock.isHidden = true
        self.lbeBlock.text = ""
        self.btnUnBlock.isHidden = true
        self.unBlockView.isHidden = true
        self.textMessage.isHidden = false
        self.btnSend.isHidden = false
        
        
        
        let BlockByMeRef = DatabaseManager.database.child("Contacts").child(userId()).child(otherUserID).child("ContactStatus")
        blockMeRefHandle = BlockByMeRef.observe(.value, with: { (snapshot) in
            guard snapshot.key as? String != nil else{
                print("user doesnt exist")
                return
            }
            let childern = snapshot.children
            for child in childern{
                
                let newChild = child as! DataSnapshot
                if let checkID = newChild.value as? Bool{
                    if checkID == true {
                        self.isBlockByMe = true
                        self.lbeBlock.isHidden = false
                        self.lbeBlock.text = "Please unblock first to chat with this user?"
                        self.btnUnBlock.isHidden = false
                        self.unBlockView.isHidden = false
                        self.textMessage.isHidden = true
                        self.btnSend.isHidden = true
                        self.imgDots.isHidden = true
                        self.btnBlock.isHidden = true
                        
                    }
                    else{
                        self.isBlockByMe = false
                        self.imgDots.isHidden = false
                        self.btnBlock.isHidden = false
                        
                        if self.isBlockByOther {
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                            self.btnUnBlock.isHidden = true
                            self.unBlockView.isHidden = true
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                            self.lbeBlock.text = "This user have blocked you!"
                            self.lbeBlock.isHidden = false
                            
                        }
                        else{
                            self.lbeBlock.isHidden = true
                            self.lbeBlock.text = ""
                            self.btnUnBlock.isHidden = true
                            self.unBlockView.isHidden = true
                            self.textMessage.isHidden = false
                            self.btnSend.isHidden = false
                            
                        }
                    }
                }
            }
        })
        
        self.otherUserBlockMe()
        
        
        
    }
    
    
    func otherUserBlockMe() {
        
        let BlockByOtherRef = DatabaseManager.database.child("Contacts").child(otherUserID).child(userId()).child("ContactStatus")
        
        
        blockOtherRefHandle = BlockByOtherRef.observe(.value, with: { (snapshot) in
            guard snapshot.key as? String != nil else{
                print("user doesnt exist")
                return
            }
            let childern = snapshot.children
            for child in childern{
                print("Child :- ",child)
                let newChild = child as! DataSnapshot
                if let checkID = newChild.value as? Bool{
                    if checkID == true {
                        self.isBlockByOther = true
                        if self.isBlockByMe {
                            self.lbeBlock.isHidden = false
                            self.lbeBlock.text = "Please unblock first to chat with this user?"
                            self.btnUnBlock.isHidden = false
                            self.unBlockView.isHidden = false
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                        }
                        else{
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                            self.btnUnBlock.isHidden = true
                            self.unBlockView.isHidden = true
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                            self.lbeBlock.text = "This user have blocked you!"
                            self.lbeBlock.isHidden = false
                            
                        }
                    }
                    else{
                        self.isBlockByOther = false
                        
                        if self.isBlockByMe {
                            self.lbeBlock.isHidden = false
                            self.lbeBlock.text = "Please unblock first to chat with this user?"
                            self.btnUnBlock.isHidden = false
                            self.unBlockView.isHidden = false
                            self.textMessage.isHidden = true
                            self.btnSend.isHidden = true
                        }
                        else{
                            self.lbeBlock.isHidden = true
                            self.lbeBlock.text = ""
                            self.btnUnBlock.isHidden = true
                            self.unBlockView.isHidden = true
                            self.textMessage.isHidden = false
                            self.btnSend.isHidden = false
                            
                            
                            
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenForMessages(id:otherUserID, shouldScrollToBottom: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //    let del = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        addObservers()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.black
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysHide
        removeObservers()
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.unBlockView.frame.size
        gradientLayer.colors =
        [UIColor(red:243/255, green:102/255, blue:8/255, alpha:1).cgColor,UIColor(red:201/255, green:21/255, blue:27/255, alpha:1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        unBlockView.layer.addSublayer(gradientLayer)
        unBlockView.layer.cornerRadius = 15
        unBlockView.clipsToBounds = true
    }
    
    
    
    
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.bottomConstraintViewChat.constant = 0
            self.view.layoutIfNeeded()
            
        } else {
            self.bottomConstraintViewChat.constant = keyboardViewEndFrame.height
            self.view.layoutIfNeeded()
            
            
            
            if  self.messages.count > 0 {
                let lastRow: Int = self.tblView.numberOfRows(inSection: 0) - 1
                let indexPath = IndexPath(row: lastRow, section: 0);
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func UnBlocksUser(_ sender: Any) {
        
        
        
        
    }
    
    
    @IBAction func Back(_ sender: Any) {
        if let refHandle = userRefHandle{
            UsersRef.removeObserver(withHandle: refHandle)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        
        
        let message = self.textMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if message.count > 0
        {
            self.view.layoutIfNeeded()
            self.textMessage.isScrollEnabled = false
            self.textMessage.text = ""
            self.textMessage.text = nil
            sendMessage(message )
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.textMessage {
            
         //   print(self.viewChat.frame.size.height)
        //    print(self.textMessage.contentSize.height)
         //   print(self.textMessage.frame.size.height)
            
            if self.viewChat.frame.size.height >= 100 {
                if self.textMessage.contentSize.height < self.textMessage.frame.size.height {
                    self.textMessage.isScrollEnabled = false
                }
                else {
                    self.textMessage.isScrollEnabled = true
                }
            }
        }
        
        
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if InterNetConnection()
        {
            if self.lastContentOffset < scrollView.contentOffset.y {
                
                let visibleRows = tblView.visibleCells
                let lastVisibleCell = visibleRows.last
                var path: IndexPath? = nil
                if let lastVisibleCell = lastVisibleCell {
                    path = tblView.indexPath(for: lastVisibleCell)
                }
                if path?.row == self.messages.count - 1  {
                    self.isLoadMore = false
                    pageNumberCount = 1
                }
            } else if self.lastContentOffset > scrollView.contentOffset.y {
                
            }
        }
    }
    
    
    
    
    
    
    
    func sendMessage(_ text:String)
    {
        
        if isNewConversation{
            var time = ChatController.timeFormatter.string(from: Date())
            if ChatController.timeFormatter.string(from: Date()).contains("AM") || ChatController.timeFormatter.string(from: Date()).contains("PM"){
                
            }
            else {
                time = timeConversion12(time24:time)
            }
            
            let message = Message(from: userId(), to: otherUserID, messageId: "", sentDate: ChatController.dateFormatter.string(from: Date()), sentTime:time, type: "text", message:text)
            
            
            DatabaseManager.shared.createNewConversation(with: otherUserID,
                                                         name: userName,
                                                         firstMessage: message,
                                                         completion: { [weak self] success in
                if success{
                    print("message sent")
                    self?.isNewConversation = false
                }
                else{
                    print("message wasnt sent")
                }
            })
        }
        else{
            var time = ChatController.timeFormatter.string(from: Date())
            if ChatController.timeFormatter.string(from: Date()).contains("AM") || ChatController.timeFormatter.string(from: Date()).contains("PM"){
                
            }
            else {
                time = timeConversion12(time24:time)
            }
            
            
            let message = Message(from: userId(), to: otherUserID, messageId: "", sentDate: ChatController.dateFormatter.string(from: Date()), sentTime:time, type: "text", message:text)
            
            
            DatabaseManager.shared.userExists(with: userId(), completion: {exists in
                if exists{
                }
                else{
                    if let refHandle = self.userRefHandle{
                        self.UsersRef.removeObserver(withHandle: refHandle)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("Show_Home_Class"), object: nil, userInfo: ["TypeScreen":"Home"])
                    return
                }
            })
            
            DatabaseManager.shared.userExists(with: otherUserID, completion: {exists in
                if exists{
                    DatabaseManager.shared.conversationExists(with: self.otherUserID, completion: {[weak self] result in
                        
                        switch result {
                        case .success(_):
                        
                            DatabaseManager.shared.finishCreatingConversation(otherUserID: self!.otherUserID,name:self!.userName, firstMessage: message, completion: { [weak self] success in
                                if success{
                                    print("message sent")
                                    
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to:self?.fcm ?? "", title: "", body:text, otherUserID: self?.otherUserID ?? "")
                                }
                                else{
                                    print("failed to send")
                                    
                                }
                            })
                            
                            
                        case .failure(_):
                            
                            if let refHandle = self?.userRefHandle{
                                self?.UsersRef.removeObserver(withHandle: refHandle)
                            }
                            self?.navigationController?.popViewController(animated: true)
                            self?.navigationController?.popToRootViewController(animated: true)
                            NotificationCenter.default.post(name: Notification.Name("Show_Home_Class"), object: nil, userInfo: ["TypeScreen":"Home"])
                            return
                        }
                        
                    })
                }
                else{
                    
                    if let refHandle = self.userRefHandle{
                        self.UsersRef.removeObserver(withHandle: refHandle)
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("Show_Home_Class"), object: nil, userInfo: ["TypeScreen":"Home"])
                    return
                }
            })
            
        }
    }
    
    
    private func listenForMessages(id:String, shouldScrollToBottom:Bool){
        
        let myMessage = DatabaseManager.database.child("Messages").child(userId()).child(otherUserID)
        
        let messageQuery = myMessage.queryLimited(toLast: 2000)
        newMessageRefHandle = messageQuery.observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else{
                self.messages.removeAll()
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
                return
            }
            self.messages.removeAll()
            let childern = snapshot.children
            for child in childern{
                let newChild = child as! DataSnapshot
                if let emptyDictionary = newChild.value as? [String: Any]{
                    let messageID = emptyDictionary["messageID"] as? String
                    let to = emptyDictionary["to"] as? String
                    let from = emptyDictionary["from"] as? String
                    let dateString = emptyDictionary["date"] as? String
                    let time = emptyDictionary["time"] as? String
                    let type = emptyDictionary["type"] as? String
                    let message = emptyDictionary["message"] as? String
                    let finalMessage = Message(from: from ?? "", to: to ?? "", messageId: messageID ?? "", sentDate: dateString ?? "", sentTime:time ?? "", type: type ?? "", message: message ?? "")
                    self.messages.append(finalMessage)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.messages.count > 0 {
                    let lastRow: Int = self.messages.count - 1
                    let indexPath = IndexPath(row: lastRow, section: 0);
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        })
    }
    
    
    
    //MARK:- UITableViewDataSource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var usedCell = UITableViewCell()
        
        var type = ""
        type = messages[indexPath.row].type
        
        var userID = ""
        userID = messages[indexPath.row].from
        
        if  userID == userId()
        {
            if type == "text"{
                let cellIdentifier = kReuseIdentifierChatRightTextTableCell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRightTextTableCell
                
                usedCell = cell!
                
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
                cell?.accessoryType = .none
                cell?.labelMessage.text = messages[indexPath.row].message
                cell?.labelTime.text = messages[indexPath.row].sentTime.uppercased()
                
                let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                lpgr.minimumPressDuration = 0.1
                lpgr.delegate = self
                cell?.viewRight.addGestureRecognizer(lpgr)
            }
            
            else{
                let cellIdentifier = kReuseIdentifierChatRightTextTableCell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRightTextTableCell
                
                usedCell = cell!
                
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
                cell?.accessoryType = .none
                
                cell?.labelMessage.text = messages[indexPath.row].message
                cell?.labelTime.text = messages[indexPath.row].sentTime.uppercased()
            }
            
            
            
            
        }
        else
        {
            
            
            
            let cellIdentifier = kReuseIdentifierChatLeftTextTableCell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatLeftTextTableCell
            
            usedCell = cell!;
            
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
            cell?.accessoryType = .none
            
            cell?.labelMessage.text = messages[indexPath.row].message
            cell?.labelTime.text = messages[indexPath.row].sentTime.uppercased()
            cell?.imageViewProfile.image = UIImage (named: "userb")
            
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressLeft))
            lpgr.minimumPressDuration = 0.1
            lpgr.delegate = self
            cell?.viewLeft.addGestureRecognizer(lpgr)
            
            
            //  cell?.imageViewProfile.sd_setImage(with:URL(string: GlobalConstants.ImageBaseURL + PatientProfilePic), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))
        }
        
        
        return usedCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: point)
        if let index = indexPath{
            print(index.row)
            myMessageDelete.isHidden = false
            effectMessageDelete.isHidden = false
            otherMessageDelete.isHidden = true
            
            deleteIndex = index.row
        }
        else{
            print("Could not find index path")
        }
    }
    
    @objc func handleLongPressLeft(gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: point)
        if let index = indexPath{
            print(index.row)
            myMessageDelete.isHidden = true
            otherMessageDelete.isHidden = false
            effectMessageDelete.isHidden = false
            deleteIndex = index.row
        }
        else{
            print("Could not find index path")
        }
    }
    
    
    @IBAction func OtherForMe(_ sender: Any)
    {
        
        var messageId = ""
        if messages.count > deleteIndex {
            messageId = messages[deleteIndex].messageId
        }
        else{
            otherMessageDelete.isHidden = true
            myMessageDelete.isHidden = true
            effectMessageDelete.isHidden = true
            return
        }
        let myMessage = DatabaseManager.database.child("Messages").child(userId()).child(otherUserID).child(messageId)
        myMessage.removeValue { (error, ref) in
            if error != nil {
                self.otherMessageDelete.isHidden = true
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
            }
            else{
                self.otherMessageDelete.isHidden = true
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func OtherCancel(_ sender: Any){
        otherMessageDelete.isHidden = true
        myMessageDelete.isHidden = true
        effectMessageDelete.isHidden = true
        
    }
    
    
    
    
    
    @IBAction func Cancel(_ sender: Any) {
        myMessageDelete.isHidden = true
        effectMessageDelete.isHidden = true
    }
    
    @IBAction func ForMe(_ sender: Any) {
        
        var messageId = ""
        if messages.count > deleteIndex {
            messageId = messages[deleteIndex].messageId
        }
        else{
            myMessageDelete.isHidden = true
            effectMessageDelete.isHidden = true
            return
        }
        let myMessage = DatabaseManager.database.child("Messages").child(userId()).child(otherUserID).child(messageId)
        myMessage.removeValue { (error, ref) in
            if error != nil {
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
            }
            else{
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
                //  if self.messages.count > self.deleteIndex {
                // self.messages.remove(at: self.deleteIndex)
                //   }
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func EveryOne(_ sender: Any) {
        
        
        var messageId = ""
        if messages.count > deleteIndex {
            messageId = messages[deleteIndex].messageId
        }
        else{
            myMessageDelete.isHidden = true
            effectMessageDelete.isHidden = true
            return
        }
        let myMessage = DatabaseManager.database.child("Messages").child(userId()).child(otherUserID).child(messageId)
        myMessage.removeValue { (error, ref) in
            if error != nil {
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
            }
            else{
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true
                // if self.messages.count > self.deleteIndex {
                // self.messages.remove(at: self.deleteIndex)
                //  }
                self.tblView.reloadData()
                
                let myMessage = DatabaseManager.database.child("Messages").child(self.otherUserID).child(userId()).child(messageId)
                myMessage.removeValue { (error, ref) in
                    if error != nil {
                        
                    }
                    else{
                        self.tblView.reloadData()
                        let UsersOther = DatabaseManager.database.child("Contacts").child(self.otherUserID).child(userId()).child("latest_message").child("message")
                        UsersOther.setValue("")
                        
                        let UsersCurrent = DatabaseManager.database.child("Contacts").child(userId()).child(self.otherUserID).child("latest_message").child("message")
                        UsersCurrent.setValue("")
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func BlockUser(_ sender: Any) {
        
        
    }
    
    
}


class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, otherUserID:String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title,"body" : body,"badge": "1"],
                                           "data" : ["senderId" :userId(),"fromNotification" :"messageScreen","body" : body,"title" : title,"receiverId": otherUserID]
                                           
        ]
        
   
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA9DE-xZQ:APA91bF9MXwYOv6UIqaW4GUyVtPic16dUKOTKt-H4SQ8gm_zGG2RP8F88m2BUvsMWOO0b--FtCK1D07iAr0HWPi1QfBDePQhU_P6Ou4Z32tz2OjQ0QtCAhFP1yeE8Q3rb8Q3IyBF5wam", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
