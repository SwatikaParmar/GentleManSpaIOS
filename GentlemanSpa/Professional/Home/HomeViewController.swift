//
//  HomeViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/08/24.
//

import UIKit
import Reachability
import FirebaseAuth
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {
    @IBOutlet weak var tableUp: UITableView!
    var pageName = "Upcoming"
    let refreshControlUp = UIRefreshControl()
    
    @IBOutlet weak var lbeTitlePending: UILabel!
    @IBOutlet weak var lbeLinePending: UIView!
    
    @IBOutlet weak var lbeTitleConfirmed: UILabel!
    @IBOutlet weak var lbeLineConfirmed: UIView!
    @IBOutlet weak var lbeTitlePast: UILabel!
    @IBOutlet weak var lbeLinePast: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    private var userExitPro: DatabaseHandle?
    let UsersRefPro = DatabaseManager.database.child("Users").child(userId())
    var isOnline = true
    var arrSortedService = [ServiceBooking]()


    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControlUp.addTarget(self, action:  #selector(RefreshScreenUp), for: .valueChanged)
        refreshControlUp.tintColor = UIColor.white
        tableUp.refreshControl = refreshControlUp
        
        lbeTitlePending.textColor = UIColor.white
        lbeLinePending.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Menu_Push_Pro), name: NSNotification.Name(rawValue: "Menu_Push_Pro"), object: nil)

        pageName = "Upcoming"
        self.tableUp.reloadData()
        self.getUserDataAPI("Profile")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.firebaseDataPro()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    
      
       

    }
    
    @objc func Menu_Push_Pro(_ notification: NSNotification) {
        if let count = notification.userInfo?["count"] as? String {
            
            
            if count == "Logout"{
                //  DatabaseManager.myConnectionsRef.cancelDisconnectOperations()
                if let refHandle = userExitPro{
                    UsersRefPro.removeObserver(withHandle: refHandle)
                }
                self.userAddPro(false, "Logout")
                
                let FCSToken = UserDefaults.standard.value(forKey:Constants.deviceToken)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(FCSToken, forKey:Constants.deviceToken)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(false, forKey: Constants.login)
                UserDefaults.standard.synchronize()
                RootControllerManager().SetRootViewController()
            }
            
            if count == "DeleteAccount"{
                if let refHandle = userExitPro{
                    UsersRefPro.removeObserver(withHandle: refHandle)
                }
            }
            
            if count == "FirebaseDataUpdate"{
                self.userAddPro(false, "online")
            }
            
            if count == "offline"{
                self.userAddPro(false, "offline")
            }
        }
    }
    
    func MyAppointmentAPI(_ isLoader:Bool){
        var params = [ "Type": pageName
        ] as [String : Any]
        GetServiceAppointmentsPro.shared.GetSerProAPIRequest(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                arrSortedService = arrayData ?? arrSortedService
                self.tableUp.reloadData()
            }
        }
    }
    
    
    func firebaseDataPro(){
        userExitPro = UsersRefPro.observe(.value, with: { (snapshot) in
            guard snapshot.key as? String != nil else{
                print("user doesnt exist")
                self.getUserDataAPI("Update")
                return
            }
            if let dictionary = snapshot.value as? [String: Any] {
             let latestMessage = dictionary["userState"] as? [String:Any]
                let state = latestMessage?["state"] as? String
                if state == "offline"{
                   // self.getUserDataAPI("Update")
                }
                else{
                    if self.isOnline {
                        self.getUserDataAPI("Update")
                    }
                    else{
                      //  self.getUserDataAPI("Profile")
                    }
                }
            }
            else{
                if self.isOnline {
                    self.getUserDataAPI("Update")
                }
            }
        }
        )
    }
        
        func getUserDataAPI(_ text:String){
            
            if UserDefaults.standard.bool(forKey: Constants.login) {
                
                GetProfileProRequest.shared.proProfileAPI(requestParams:[:], false) { (user,message,isStatus) in
                        if isStatus {
                        if user != nil{
                            UserDefaults.standard.set(user?.firstName, forKey: Constants.firstName)
                            UserDefaults.standard.set(user?.lastName, forKey: Constants.lastName)
                            UserDefaults.standard.set(user?.gender, forKey: Constants.gender)
                            UserDefaults.standard.set(user?.email, forKey: Constants.email)
                            UserDefaults.standard.set(user?.profilePic, forKey: Constants.userImg)
                            UserDefaults.standard.set(user?.phone, forKey: Constants.phone)
                            UserDefaults.standard.set(user?.objectPro?.professionalDetailId ?? 0, forKey: Constants.professionalDetailId)
                            UserDefaults.standard.synchronize()
                            
                            if text == "Update"{
                               
                       
                                self.userAddPro(self.isOnline, "online")
                            }
                            
                            if text == "Profile"{
                                self.MyAppointmentAPI(true)
                            }
                        }
                        
                        else{
                            self.userAddPro(self.isOnline, "online")
                        }
                        
                    }
                }
            }
            else {
                if let refHandle = userExitPro{
                    UsersRefPro.removeObserver(withHandle: refHandle)
                }
            }
        }
        
    func userAddPro(_ isCall:Bool, _ logout:String){
        self.isOnline = false
        if UserDefaults.standard.bool(forKey: Constants.login) {
            if UserDefaults.standard.string(forKey: Constants.firstName) ?? "" == "" ||
                UserDefaults.standard.string(forKey: Constants.firstName) ?? "" == nil {
                return
            }
            
            var firstName = ""
            firstName = UserDefaults.standard.string(forKey: Constants.firstName) ?? ""
            
            var lastName = ""
            lastName = UserDefaults.standard.string(forKey: Constants.lastName) ?? ""
            
            let name = firstName + " " + lastName
            
            let chatUser = ChatAppUser(firstName: name.capitalized,
                                       lastName: UserDefaults.standard.string(forKey: Constants.lastName) ?? "",
                                       emailAddress: UserDefaults.standard.string(forKey: Constants.email) ?? "", profilePictureFileName: UserDefaults.standard.string(forKey: Constants.userImg) ?? "",userID: userId())
            
            DatabaseManager.shared.insertUser(with: chatUser, logout, completion: {success in
                if success{
                    if isCall {
                        
                    }
                }
            })
        }
    }
    
    @objc func RefreshScreenUp() {
      
        refreshControlUp.endRefreshing()
            
    }
    
    
    @IBAction func MyProfile(_ sender: Any) {
       
        let controller:MessageProViewController =  UIStoryboard(storyboard: .Professional).initVC()
        self.parent?.navigationController?.pushViewController(controller, animated: true)
       
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }

    @IBAction func PendingAction(_ sender: Any) {
        
      
 
        lbeTitlePending.textColor = UIColor.white
        lbeLinePending.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor = UIColor.clear

        pageName = "Upcoming"
        MyAppointmentAPI(true)

        self.tableUp.reloadData()
    }
 
    @IBAction func ConfirmedAction(_ sender: Any) {
        

        
        lbeTitleConfirmed.textColor = UIColor.white
        lbeLineConfirmed.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor =  UIColor.clear
        
   
        pageName = "Completed"
        MyAppointmentAPI(true)

        self.tableUp.reloadData()

    }
    @IBAction func PastAction(_ sender: Any) {
        
        
      
        
        lbeTitlePast.textColor = UIColor.white
        lbeLinePast.backgroundColor = UIColor.white

        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor =  UIColor.clear

        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor = UIColor.clear
        
        
        pageName = "Cancelled"
        MyAppointmentAPI(true)

        self.tableUp.reloadData()

    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1

        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return arrSortedService.count

        }
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if  pageName == "Upcoming" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "UpcomingTvCell") as! UpcomingTvCell
                
                if let imgUrl = arrSortedService[indexPath.row].userImage,!imgUrl.isEmpty {
                    let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                                 placeholderImage: UIImage(named: "shopPlace"),
                                                 options: .refreshCached,
                                                 completed: nil)
                }
                else{
                    cell.imgService?.image = UIImage(named: "shopPlace")
                }
                cell.lbeName.text = arrSortedService[indexPath.row].userName
                cell.lbeDuration.text = arrSortedService[indexPath.row].serviceName

        
                
        
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                
                
                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )
                cell.btnMessage.tag = indexPath.row
                cell.btnMessage.addTarget(self, action: #selector(Message_ConnectedPro(sender:)), for: .touchUpInside)
                cell.viewMessage.alpha = 1
                
                return cell
            }
            else if pageName == "Completed" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "ConfirmedTvCell") as! ConfirmedTvCell
                
                if let imgUrl = arrSortedService[indexPath.row].userImage,!imgUrl.isEmpty {
                    let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                                 placeholderImage: UIImage(named: "shopPlace"),
                                                 options: .refreshCached,
                                                 completed: nil)
                }
                else{
                    cell.imgService?.image = UIImage(named: "shopPlace")
                }
                cell.lbeName.text = arrSortedService[indexPath.row].userName
                cell.lbeDuration.text = arrSortedService[indexPath.row].serviceName

        
                
        
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                
                
                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )
                cell.btnMessage.tag = indexPath.row
                cell.btnMessage.addTarget(self, action: #selector(Message_ConnectedPro(sender:)), for: .touchUpInside)
                cell.viewMessage.alpha = 1
                return cell
            }
            else{
                let cell = tableUp.dequeueReusableCell(withIdentifier: "PastTvCell") as! PastTvCell
                
                
                if let imgUrl = arrSortedService[indexPath.row].userImage,!imgUrl.isEmpty {
                    let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                                 placeholderImage: UIImage(named: "shopPlace"),
                                                 options: .refreshCached,
                                                 completed: nil)
                }
                else{
                    cell.imgService?.image = UIImage(named: "shopPlace")
                }
                cell.lbeName.text = arrSortedService[indexPath.row].userName
                cell.lbeDuration.text = arrSortedService[indexPath.row].serviceName

        
                
        
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                
                
              
                return cell
            }

           
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if  pageName == "Upcoming" {
                return 205

            }
            else if pageName == "Completed" {
                return 205
            }
            
            return 205

        
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    
    
    @objc func Message_ConnectedPro(sender: UIButton){
        

        open_ChatView(sender.tag)
        
     
    }
    
    func open_ChatView(_ int:Int){
        
        if arrSortedService.count > int{
            Indicator.shared.startAnimating(withMessage:"", colorType: AppColor.TabSelectColor, colorText: UIColor.cyan)
            
            DatabaseManager.shared.userExists(with: self.arrSortedService[int].userId ?? "", completion: {exists in
                if exists{
                    DatabaseManager.shared.conversationExists(with: "", completion: {[weak self] result in
                        Indicator.shared.stopAnimating()
                        guard let strongSelf = self else{
                            return
                        }
                        switch result {
                        case .success(let conversationId):
                            let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
                            controller.isNewConversation = false
                            controller.otherUserEmail = "Email"
                            controller.userName =      self?.arrSortedService[int].userName ?? ""
                            controller.imgString =  self?.arrSortedService[int].userImage ?? "No"
                            controller.otherUserID =  self?.arrSortedService[int].userId ?? ""
                            self?.parent?.navigationController?.pushViewController(controller, animated: true)
                        case .failure(_):
                            let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
                            controller.otherUserEmail = "Email"
                            controller.userName =              self?.arrSortedService[int].userName ?? ""
                            controller.imgString =  self?.arrSortedService[int].userImage ?? "No"
                            controller.otherUserID =  self?.arrSortedService[int].userId ?? ""
                            controller.isNewConversation = true

                            self?.parent?.navigationController?.pushViewController(controller, animated: true)
                        }
                    })
                }
                else{
                    Indicator.shared.stopAnimating()
                    NotificationAlert().NotificationAlert(titles:GlobalConstants.fbUserError)

                }
            })
        }
    }
}
    
    
    
    

class UpcomingTvCell: UITableViewCell {
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnMessage : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class ConfirmedTvCell: UITableViewCell {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnMessage : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class PastTvCell: UITableViewCell {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

class GetServiceAppointmentsPro: NSObject{
    
    static let shared = GetServiceAppointmentsPro()
    
    func GetSerProAPIRequest(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [ServiceBooking]?, _ objectSer: cartServicesDataModel?, _ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("Base".GetServiceAppointmentsAPI)
        
        apiURL = String(format:"%@?pageNumber=1&pageSize=1000&Type=%@&ProfessionalDetailId=%d",apiURL,requestParams["Type"] as? String ?? "Upcoming",professionalDetailId())
        
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print(data ?? "No data")
            if error == nil{
                var messageString : String = ""
                if let status = data?["isSuccess"] as? Bool{
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    if status{
                        var homeListObject : [ServiceBooking] = []
                        if let dataList = data?["data"]?["dataList"] as? NSArray{
                            for list in dataList{
                                let dict : ServiceBooking = ServiceBooking.init(dict: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            completion(homeListObject,nil,messageString,true)
                        }
                        else{
                            completion(nil,nil,messageString,false)
                        }
                    }
                    else
                    {
                        completion(nil,nil,"",false)
                    }
                }
                else
                {
                    completion(nil,nil,"",false)
                }
            }
        }
    }
}
