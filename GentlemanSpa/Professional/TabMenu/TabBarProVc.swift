//
//  TabBarProVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/08/24.
//

import UIKit

class TabBarProVc: UIViewController {
    
    
    @IBOutlet weak var TabBarView: UIView!
    @IBOutlet weak var Contentview: UIView!
    
    @IBOutlet weak var lbeCount: UILabel!
    
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewHome: UIImageView!
    @IBOutlet weak var imgViewSearch: UIImageView!
    @IBOutlet weak var imgViewChats: UIImageView!
    
    @IBOutlet weak var lbeHome: UILabel!
    @IBOutlet weak var lbePro: UILabel!
    @IBOutlet weak var lbeReward: UILabel!
    @IBOutlet weak var lbeProfile: UILabel!
    
    
    public static var sharedNavigationControllerPro = UINavigationController()

    var homeClass: HomeViewController?
    var className = "Home"
    var lastOpenClass = ""
    
    var homeClassNav: UINavigationController?
    var profileNav: UINavigationController?
    var searchNav: UINavigationController?
    var notificationNav: UINavigationController?
    var messagesControllerNav: UINavigationController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(accessToken())
        
//            TabBarView.layer.masksToBounds = false
//            TabBarView?.layer.shadowColor = UIColor.darkGray.cgColor
//            TabBarView?.layer.shadowOffset =  CGSize.zero
//            TabBarView?.layer.shadowOpacity = 0.20
//            TabBarView?.layer.shadowRadius = 6
        self.lbeCount.layer.cornerRadius = 12
        lbeCount.layer.masksToBounds = true
        lbeHome.text = "Home"
        lbePro.text = "Schedule"
        lbeReward.text = "Notification"
        lbeProfile.text = "Profile"
        
        imgViewHome.image = UIImage(named: "home_s_ic")
        imgViewSearch.image = UIImage(named: "addApp")
        imgViewChats.image = UIImage(named: "notification_ic")
        imgViewUser.image = UIImage(named: "profile_s_ic")
        
        imgViewHome.tintColor = AppColor.BrownColor
        imgViewSearch.tintColor = AppColor.BrownColor
        imgViewChats.tintColor = AppColor.BrownColor
        imgViewUser.tintColor = AppColor.BrownColor
        lbeHome.textColor = AppColor.BrownColor
        lbePro.textColor = AppColor.BrownColor
        lbeReward.textColor = AppColor.BrownColor
        lbeProfile.textColor = AppColor.BrownColor
        
        GetProductCountInCartCall()
        getProfileAPI()
        lbePro.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
        lbeReward.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
        lbeProfile.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
        lbeHome.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
        let storyboardPro = UIStoryboard(name: "Professional", bundle: nil)

        if className == "Home" {
           
            lbeHome.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
            imgViewHome.tintColor = AppColor.TabSelectColor
            lbeHome.textColor = AppColor.TabSelectColor
           
            
            if homeClass != nil {
                homeClassNav?.popToRootViewController(animated: false)
                homeClassNav!.didMove(toParent: self)
                self.Contentview.bringSubviewToFront(self.homeClassNav!.view)
                
                lastOpenClass = "Home"
            }
            else{
                guard let home = storyboardPro.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return}
                homeClass = home
                homeClassNav = UINavigationController(rootViewController: home)
                homeClassNav?.view.frame = Contentview.bounds
                addChild(homeClassNav!)
                Contentview.addSubview((homeClassNav?.view)!)
                homeClassNav!.didMove(toParent: self)
                lastOpenClass = "Home"
                
            }
            TabBarProVc.sharedNavigationControllerPro = homeClassNav!

        }
        
        
        else if className == "ProductVc"{
           
            lbePro.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
            imgViewSearch.tintColor = AppColor.TabSelectColor
            lbePro.textColor = AppColor.TabSelectColor
           
            
            if Contentview.contains(searchNav?.view ?? UIView()){
                searchNav?.view.removeFromSuperview()
            }
            
            guard let home = storyboardPro.instantiateViewController(identifier: "AppointmentsViewController") as? AppointmentsViewController else { return}
            home.view.frame = Contentview.bounds
            searchNav = UINavigationController(rootViewController: home)
            searchNav?.view.frame = Contentview.bounds
            addChild(searchNav!)
            Contentview.addSubview((searchNav?.view)!)
            searchNav!.didMove(toParent: self)
            
            lastOpenClass = "Favourites"
            TabBarProVc.sharedNavigationControllerPro = searchNav!

        }
        
        else if className == "RewardsVc"{
          
            
            lbeReward.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
            imgViewChats.tintColor = AppColor.TabSelectColor
            lbeReward.textColor = AppColor.TabSelectColor
            
            if Contentview.contains(notificationNav?.view ?? UIView()){
                notificationNav?.view.removeFromSuperview()
            }
            
            guard let home = storyboardPro.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController else { return}
            home.view.frame = Contentview.bounds
            notificationNav = UINavigationController(rootViewController: home)
            notificationNav?.view.frame = Contentview.bounds
            addChild(notificationNav!)
            Contentview.addSubview((notificationNav?.view)!)
            notificationNav!.didMove(toParent: self)
            
            lastOpenClass = "Favourites"
            TabBarProVc.sharedNavigationControllerPro = notificationNav!

        }
        else{
            
         
            
            lbeProfile.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
            imgViewUser.tintColor = AppColor.TabSelectColor
            lbeProfile.textColor = AppColor.TabSelectColor
            
            
            
            if Contentview.contains(profileNav?.view ?? UIView()){
                profileNav?.view.removeFromSuperview()
            }
            
            
            guard let home = storyboardPro.instantiateViewController(identifier: "UpdateProfileProViewController") as? UpdateProfileProViewController else { return}
            home.view.frame = Contentview.bounds
            profileNav = UINavigationController(rootViewController: home)
            profileNav?.view.frame = Contentview.bounds
            
            addChild(profileNav!)
            Contentview.addSubview((profileNav?.view)!)
            profileNav!.didMove(toParent: self)
            lastOpenClass = "p"
            TabBarProVc.sharedNavigationControllerPro = profileNav!

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @objc func Refresh_Cart_Count(_ notification: NSNotification) {
        
        GetProductCountInCartCall()
        
    }
    
    @objc func UpdateProfileTab(_ notification: NSNotification) {
    }
    
// MARK: - get Profile API
func getProfileAPI(){

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
                    
                    UserDefaults.standard.set(user?.objectPro?.professionalDetailId ?? 0, forKey: Constants.professionalDetailId)
                    UserDefaults.standard.synchronize()
                }
            }
        }
}
    
    // MARK: - Cart API
    func GetProductCountInCartCall(){
        
    }
    
    
    @objc func showHomeClass(_ notification: NSNotification) {
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeClass?.view.frame = Contentview.bounds
    }
    
    
    
    @IBAction func HomeAction(_ sender: Any) {
        className = "Home"
        viewDidLoad()
        
    }
    
    @IBAction func MessagesAction(_ sender: Any) {
        className = "RewardsVc"
        viewDidLoad()
    }
    
    @IBAction func ProfileAction(_ sender: Any) {
        
        className = "Profile"
        viewDidLoad()
    }
    @IBAction func SearchAction(_ sender: Any) {
        
        className = "ProductVc"
        viewDidLoad()
    }
    
    @IBAction func SAction(_ sender: Any) {
        
        
        
    }
    
}

