//
//  HomeUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit
import Reachability
import FirebaseAuth
import Firebase
import FirebaseDatabase

class HomeUserViewController: UIViewController {
    @IBOutlet weak var tableViewHome : UITableView!
    var arrayHomeBannerModel = [HomeBannerModel]()
    var arrSortedCategory = [dashboardCategoryObject]()
    var arrSortedProductCategories = [ProductCategoriesObject]()
    var arrGetProfessionalList = [GetProfessionalObject]()
    private var userExit: DatabaseHandle?
    let UsersRef = DatabaseManager.database.child("Users").child(userId())
    var isOnline = true

    func topViewLayout(){
        if !CreateAccountController.hasSafeArea{
           print("YES")
        }
        else{
      
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Banner_Timer_Stop"), object: nil)

        topViewLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Menu_Push_Action), name: NSNotification.Name(rawValue: "Menu_Push_Action"), object: nil)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.firebaseData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        BannerAPI()
        categoryAPI(true, true, 1)
        ProductCategoriesAPI(true, true, 1)
        GetProfessionalListAPI(true, true, 1)
    }
    
    @objc func Menu_Push_Action(_ notification: NSNotification) {
        if let count = notification.userInfo?["count"] as? String {
            
            
            if count == "Logout"{
                //  DatabaseManager.myConnectionsRef.cancelDisconnectOperations()
                if let refHandle = userExit{
                    UsersRef.removeObserver(withHandle: refHandle)
                }
                self.userAdd(false, "Logout")
                
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
                if let refHandle = userExit{
                    UsersRef.removeObserver(withHandle: refHandle)
                }
            }
            
            if count == "FirebaseDataUpdate"{
                self.userAdd(false, "online")
            }
            
            if count == "offline"{
                self.userAdd(false, "offline")
            }
        }
    }
    
func firebaseData(){
    userExit = UsersRef.observe(.value, with: { (snapshot) in
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
            
            GetProfileRequest.shared.getProfileAPI(requestParams:[:], false) { (user,message,isStatus) in
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
                            NotificationCenter.default.post(name: Notification.Name("SideMenuUpdate"), object: nil, userInfo: ["count":String(0)])
                            
                            self.userAdd(self.isOnline, "online")
                        }
                        
                        if text == "Profile"{
                            NotificationCenter.default.post(name: Notification.Name("SideMenuUpdate"), object: nil, userInfo: ["count":String(0)])
                        }
                    }
                    
                    else{
                        self.userAdd(self.isOnline, "online")
                    }
                    
                }
            }
        }
        else {
            if let refHandle = userExit{
                UsersRef.removeObserver(withHandle: refHandle)
            }
        }
    }
    
    func userAdd(_ isCall:Bool, _ logout:String){
        
        if UserDefaults.standard.string(forKey: Constants.firstName) ?? "" == "" ||
            UserDefaults.standard.string(forKey: Constants.firstName) ?? "" == nil {
            return
        }
        
        var firstName = ""
        firstName = UserDefaults.standard.string(forKey: Constants.firstName) ?? ""
        
        var lastName = ""
        lastName = UserDefaults.standard.string(forKey: Constants.lastName) ?? ""
        
        let name = firstName + " " + lastName

        
        self.isOnline = false
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
    
    @IBAction func sideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    
    @IBAction func notification(_ sender: Any) {
        let controller:UserNotificationViewController =  UIStoryboard(storyboard: .User).initVC()
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Category API
    func categoryAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "categoryType": type,
                       
        ] as [String : Any]
        
        HomeListRequest.shared.homeListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedCategory = arrayData ?? self.arrSortedCategory
                    if self.arrSortedCategory.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrSortedCategory.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrSortedCategory.removeAll()
                self.tableViewHome.reloadData()
            }
        }
    }
    
    //MARK: - Banner
    func BannerAPI(){
        BannerRequest.shared.getBannerListAPI(requestParams:[:], true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrayHomeBannerModel.removeAll()
                    self.arrayHomeBannerModel = arrayData ?? self.arrayHomeBannerModel
                    self.tableViewHome.reloadData()
 
                }
            }
        }
    }
    
    
    //MARK: - ProductCategories API
    func ProductCategoriesAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "categoryType": type,
        ] as [String : Any]
        
        ProductCategoriesRequest.shared.ProductCategoriesRequestAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedProductCategories = arrayData ?? self.arrSortedProductCategories
                    if self.arrSortedProductCategories.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrSortedProductCategories.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrSortedProductCategories.removeAll()
                
                self.tableViewHome.reloadData()
            }
        }
    }
    
    
    //MARK: - GetProfessionalList API
    func GetProfessionalListAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
        ] as [String : Any]
        
        TeamsProfessionalListRequest.shared.TeamsProfessionalListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrGetProfessionalList = arrayData ?? self.arrGetProfessionalList
                    if self.arrGetProfessionalList.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrGetProfessionalList.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrGetProfessionalList.removeAll()
                
                self.tableViewHome.reloadData()
            }
        }
    }
    
}
