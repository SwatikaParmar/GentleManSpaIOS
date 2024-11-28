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

        pageName = "Upcoming"
        self.tableUp.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.firebaseDataPro()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
 
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
                    self.getUserDataAPI("Update")
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
                            UserDefaults.standard.synchronize()
                            
                            if text == "Update"{
                                
                                self.userAddPro(self.isOnline, "online")
                            }
                            
                            if text == "Profile"{
                                NotificationCenter.default.post(name: Notification.Name("SideMenuUpdate"), object: nil, userInfo: ["count":String(0)])
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
                      //  DatabaseManager.shared.observeOnline()
                    }
                }
            })
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
        self.tableUp.reloadData()
    }
 
    @IBAction func ConfirmedAction(_ sender: Any) {
        

        
        lbeTitleConfirmed.textColor = UIColor.white
        lbeLineConfirmed.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor =  UIColor.clear
        
   
        pageName = "Confirmed"
        self.tableUp.reloadData()

    }
    @IBAction func PastAction(_ sender: Any) {
        
        
      
        
        lbeTitlePast.textColor = UIColor.white
        lbeLinePast.backgroundColor = UIColor.white

        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor =  UIColor.clear

        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor = UIColor.clear
        
        
        pageName = "Past"
        self.tableUp.reloadData()

    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1

        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return 11

        }
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if  pageName == "Upcoming" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "UpcomingTvCell") as! UpcomingTvCell
                return cell
            }
            else if pageName == "Confirmed" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "ConfirmedTvCell") as! ConfirmedTvCell
                return cell
            }
            else{
                let cell = tableUp.dequeueReusableCell(withIdentifier: "PastTvCell") as! PastTvCell
                return cell
            }

           
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if  pageName == "Upcoming" {
                return 250

            }
            else if pageName == "Confirmed" {
                return 200
            }
            
            return 200

        
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
}
    
    
    
    

class UpcomingTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class ConfirmedTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class PastTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
