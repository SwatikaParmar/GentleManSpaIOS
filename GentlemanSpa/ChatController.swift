//
//  ChatController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 28/10/24.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

   

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
    @IBOutlet weak var imgViewUser: UIImageView!

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
    
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
         return .lightContent
    }
    
    @objc func Block_User_Back(_ notification: NSNotification) {
        
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Block_User_Back), name: NSNotification.Name(rawValue: "Block_User"), object: nil)

       
        myMessageDelete.isHidden = true
        otherMessageDelete.isHidden = true
        effectMessageDelete.isHidden = true
        
 
        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatRightTextTableCell, bundle: nil), forCellReuseIdentifier: kReuseIdentifierChatRightTextTableCell)
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierRightImageSTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierRightImageSTableCell)
        
        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatLeftTextTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierChatLeftTextTableCell)

        self.tblView.register(UINib.init(nibName: kReuseIdentifierChatLeftImageSTableCell, bundle: nil), forCellReuseIdentifier:kReuseIdentifierChatLeftImageSTableCell)
        
        self.tblView.separatorStyle = .none
        self.textMessage.backgroundColor = UIColor.clear
        self.textMessage.isScrollEnabled = false
        self.textMessage.text = ""
        
       
        
        self.lbeBlock.isHidden = true
        self.lbeBlock.text = ""
        self.btnUnBlock.isHidden = true
        self.unBlockView.isHidden = true
        self.textMessage.isHidden = false
        self.btnSend.isHidden = false
        
        
        imgViewUser.layer.masksToBounds = true
        imgViewUser.layer.cornerRadius = 25
        imgViewUser.layer.borderWidth = 2
        imgViewUser.layer.borderColor = UIColor.white.cgColor
       
        
       
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
         
            
//            self.viewChat.frame.size.height = 82.5
//            self.textMessage.contentSize.height = 35.5
//         //   self.textMessage.frame.size.height = 35.5
//            self.viewChat.layoutIfNeeded()

         //   self.viewHeightConstraint.constant = 82.5
            self.view.layoutIfNeeded()
            
            self.textMessage.isScrollEnabled = false
            self.textMessage.text = ""
            self.textMessage.text = nil

            sendMessage(message )
        }
    
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if textView == self.textMessage {
             
             print(self.viewChat.frame.size.height)
             print(self.textMessage.contentSize.height)
             print(self.textMessage.frame.size.height)
             
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
        
  
      }

    
    
    
    
    
    
    func sendMessage(_ text:String)
    {
       
        if isNewConversation{
            
            
        }
       
    }
    
    
    private func listenForMessages(id:String, shouldScrollToBottom:Bool){
        
    }
    
    
    
    //MARK:- UITableViewDataSource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var usedCell = UITableViewCell()
    
        var type = "text"
        
        var userID = "1"

        if  indexPath.row == 1
        {
          
                let cellIdentifier = kReuseIdentifierChatRightTextTableCell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRightTextTableCell
                
                usedCell = cell!
                
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
                cell?.accessoryType = .none
                cell?.labelMessage.text = "Hello"
                cell?.labelTime.text = "11:00 PM".uppercased()
                
                let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                   lpgr.minimumPressDuration = 0.1
                   lpgr.delegate = self
                cell?.viewRight.addGestureRecognizer(lpgr)
            }
            else{
                let cellIdentifier = kReuseIdentifierChatLeftTextTableCell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatLeftTextTableCell
                
                usedCell = cell!
                
                cell?.backgroundColor = UIColor.clear
                cell?.selectionStyle = .none
                cell?.accessoryType = .none
                
                cell?.labelMessage.text = "Hi"
                cell?.labelTime.text = "10:00 PM".uppercased()
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
        
    }
    
    @IBAction func EveryOne(_ sender: Any) {
        
    }
    
    
    @IBAction func BlockUser(_ sender: Any) {
        
    }
}




//class PushNotificationSender {
//    func sendPushNotification(to token: String, title: String, body: String, otherUserID:String) {
//        let urlString = "https://fcm.googleapis.com/fcm/send"
//        let url = NSURL(string: urlString)!
//        let paramString: [String : Any] = ["to" : token,
//                                           "notification" : ["title" : title,"body" : body,"badge": "1"],
//                                           "data" : ["senderId" :AppUser.userId,"fromNotification" :"messageScreen","body" : body,"title" : title,"receiverId": otherUserID]
//                                           
//        ]
//        
//   
//        
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=AAAA9DE-xZQ:APA91bF9MXwYOv6UIqaW4GUyVtPic16dUKOTKt-H4SQ8gm_zGG2RP8F88m2BUvsMWOO0b--FtCK1D07iAr0HWPi1QfBDePQhU_P6Ou4Z32tz2OjQ0QtCAhFP1yeE8Q3rb8Q3IyBF5wam", forHTTPHeaderField: "Authorization")
//        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
//            do {
//                if let jsonData = data {
//                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
//                        NSLog("Received data:\n\(jsonDataDict))")
//                    }
//                }
//            } catch let err as NSError {
//                print(err.debugDescription)
//            }
//        }
//        task.resume()
//    }
//}
