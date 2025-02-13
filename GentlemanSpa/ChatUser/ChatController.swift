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
    var apiTimer: Timer?
    
    
    private var messages = [MessagingList]()
    
    
    let kReuseIdentifierChatRightTextTableCell  = "ChatRightTextTableCell"
    let kReuseIdentifierRightImageSTableCell   = "RightImageSTableCell"
    
    let kReuseIdentifierChatLeftTextTableCell   = "ChatLeftTextTableCell"
    let kReuseIdentifierChatLeftImageSTableCell   = "LeftImageCell"
    
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
        self.lbeOnline.text = ""
        unBlockView.isHidden = true
        btnUnBlock.isHidden = true
        lbeBlock.isHidden = true
        btnBlock.isHidden = true
        
        imgViewUser.layer.masksToBounds = true
        imgViewUser.layer.cornerRadius = 25
        imgViewUser.layer.borderWidth = 1.5
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
        getReplyData(false)
        startApiCallEveryMinute()
        
        
    }
    func startApiCallEveryMinute() {
        apiTimer?.invalidate()
        apiTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(callApi), userInfo: nil, repeats: true)
    }
    
    @objc func callApi() {
        if !InterNetConnection()
        {
            InternetAlert()
            stopApiCall()
            return
        }
        getReplyData(false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        stopApiCall()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    func stopApiCall() {
        apiTimer?.invalidate()
        apiTimer = nil
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
    
    @IBAction func Back(_ sender: Any) {
        
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
                
                print()
            }
        }
    }
    
    
    func sendMessage(_ text:String)
    {
        let patientFeedback  = [
            "senderUserName": userId(),
            "receiverUserName": otherUserID,
            "messageContent": text,
            "messageType": "text",
            "id": 0
        ]as [String : AnyObject]
        
        
        SendReplyRequest.shared.AddReplyAPI(requestParams: patientFeedback) { (user,message,isStatus) in
            self.getReplyData(false)
        }
        
    }
    
    
    func getReplyData(_ isLoader : Bool){
        
        
        var apiURL = "base".messagesGet
        apiURL = String(format: "%@?senderId=%@&receiverId=%@&pageNumber=1&pageSize=1000", apiURL, userId(),otherUserID)
       
        GetMessageReplysRequest.shared.GetMessageReplysAPI(apiURL,isLoader) { (dictionary,message,status) in
            if status {
                if dictionary != nil{
                    if dictionary?.count ?? 0 > 0 {
                        var isLastMessageCount = true
                        if self.messages.count == dictionary?[0].replies.count {
                            isLastMessageCount = false
                        }
                        
                        self.messages = dictionary?[0].replies ?? self.messages
                        if dictionary?[0].receiverOnlineStatus == 1 {
                            self.lbeOnline.text = "Online"
                            self.lbeOnline.textColor = .green
                        }
                        else {
                            self.lbeOnline.text = ""
                        }
                        
                        self.imgString = dictionary?[0].senderProfilePic ?? ""
                        
                        let imagePath = String("\(GlobalConstants.BASE_IMAGE_URL)\(self.imgString)")
                        
                        let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        self.imgViewUser.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))
                        
                        self.lbeUserName.text = dictionary?[0].name
    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if self.messages.count > 0 {
                                if isLastMessageCount {
                                    let lastRow: Int = self.messages.count - 1
                                    let indexPath = IndexPath(row: lastRow, section: 0);
                                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
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
        userID = messages[indexPath.row].senderId
        
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
                cell?.labelTime.text = "".ReplyWithString(self.messages[indexPath.row].sentTime)
                
                
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
                cell?.labelTime.text = "".ReplyWithString(self.messages[indexPath.row].sentTime)
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
            cell?.labelTime.text = "".ReplyWithString(self.messages[indexPath.row].sentTime)
            cell?.imageViewProfile.image = UIImage (named: "userb")
            
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressLeft))
            lpgr.minimumPressDuration = 0.1
            lpgr.delegate = self
            cell?.viewLeft.addGestureRecognizer(lpgr)
            
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
            myMessageDelete.isHidden = true
            otherMessageDelete.isHidden = false
            effectMessageDelete.isHidden = false
            
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
        if messages.count > deleteIndex{
            MessageDeleteRequest.shared.MessageDeleteAPI(id:messages[deleteIndex].id) { (arrayData,message,isStatus) in
                self.getReplyData(false)
                self.otherMessageDelete.isHidden = true
                self.myMessageDelete.isHidden = true
                self.effectMessageDelete.isHidden = true

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
    
    @IBAction func ForMe(_ sender: Any)
    {
        
    }
    
    @IBAction func EveryOne(_ sender: Any) {
        
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
