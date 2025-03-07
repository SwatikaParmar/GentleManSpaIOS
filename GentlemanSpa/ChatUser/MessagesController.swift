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
    private var conversations = [UserMessagingList]()
    private var conversationsSort = [UserMessagingList]()

   
    
    @objc func ChatUserList_ObserverRemove(_ notification: NSNotification) {
        if let count = notification.userInfo?["count"] as? String {
            if count == "DeleteAccount" {
               
            }
            else{
                
            

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        getAllConversations(false)

    }
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func getAllConversations(_ isLoader:Bool){
        
        
        var apiURL = "base".chatUsers
        apiURL = String(format: "%@/%@", apiURL, userId())

        GetChatUserListRequest.shared.GetChatUserListAPI(apiURL,isLoader) { (dictionary,message,status) in
            if status {
                if dictionary != nil{
                    if dictionary?.count ?? 0 > 0 {
                        self.conversationsSort = dictionary ?? self.conversationsSort
                        self.noUserView.isHidden = true
                        let sortedItemsLast = self.conversationsSort.sorted { $0.lastMessageTime > $1.lastMessageTime }
                        if sortedItemsLast.count > 0 {
                            self.conversationsSort = sortedItemsLast
                        }

                    }
                    else{
                        self.noUserView.isHidden = false
                        self.conversationsSort.removeAll()

                    }
                }
                else{
                    self.conversationsSort.removeAll()
                    self.noUserView.isHidden = false
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else{
                self.conversationsSort.removeAll()
                self.noUserView.isHidden = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
            cell.lbeLastMessage.text =    self.conversationsSort[indexPath.row].lastMessage
            cell.lbeTime.text =   ""
            let imagePath = String("\(GlobalConstants.BASE_IMAGE_URL)\( self.conversationsSort[indexPath.row].imageUser)")
            let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgView.sd_setImage(with:URL(string: urlString), placeholderImage: UIImage(named: GlobalConstants.MalePlaceHolding))
            
            cell.lbeOnline.layer.cornerRadius = 7
            cell.lbeOnline.clipsToBounds = true
            if self.conversationsSort[indexPath.row].onlineData == 1{
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
        controller.otherUserEmail =  self.conversationsSort[indexPath.row].id
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
        
        if self.conversationsSort.count > index {
                RemoveUserFromPersonalChatRoomRequest.shared.RemoveUserAPI(id:conversationId) { (arrayData,message,isStatus) in
                    self.getAllConversations(false)
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


