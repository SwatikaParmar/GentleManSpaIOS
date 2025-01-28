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
import EventKit

class HomeUserViewController: UIViewController {
    @IBOutlet weak var tableViewHome : UITableView!
    var arrayHomeBannerModel = [HomeBannerModel]()
    var arrSortedCategory = [dashboardCategoryObject]()
    var arrSortedProductCategories = [ProductCategoriesObject]()
    var arrGetProfessionalList = [GetProfessionalObject]()
    var arrSortedService = [ServiceBooking]()
    
    private var userExit: DatabaseHandle?
    let UsersRef = DatabaseManager.database.child("Users").child(userId())
    var isOnline = true
    let refreshControlUp = UIRefreshControl()
    let appleEventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
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
        generateEvent()
        refreshControlUp.addTarget(self, action:  #selector(RefreshScreenUp), for: .valueChanged)
        refreshControlUp.tintColor = UIColor.white
        tableViewHome.refreshControl = refreshControlUp
        
        
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Banner_Timer_Stop"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Menu_Push_Action), name: NSNotification.Name(rawValue: "Menu_Push_Action"), object: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.firebaseData()
        }
    }
    @objc func RefreshScreenUp() {
        BannerAPI()
        categoryAPI(false, true, 1)
        ProductCategoriesAPI(false, true, 1)
        GetProfessionalListAPI(false, true, 1)
        refreshControlUp.endRefreshing()
        
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
                
                deleteAllEvents()
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
            if count == "CancelService"{
                generateEvent()
            }
            if count == "RescheduleService"{
                generateEvent()
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
        BannerRequest.shared.getBannerListAPI(requestParams:[:], false) { (arrayData,message,isStatus) in
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
    
    
    
    func generateEvent() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status)
        {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // User has access
            print("User has access to calendar")
            self.MyAppointmentAPI(false)
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            noPermission()
        case .fullAccess: break
            
        case .writeOnly: break
            
        @unknown default:
            print("default")
        }
    }
    func noPermission()
    {
        print("User has to change settings...goto settings to view access")
    }
    func requestAccessToCalendar() {
        appleEventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                DispatchQueue.main.async {
                    print("User has access to calendar")
                    self.MyAppointmentAPI(false)
                }
            } else {
                DispatchQueue.main.async{
                    self.noPermission()
                }
            }
        })
    }
    
    func addAppleEvents(_ startDate: String, endDate: String,serviceName: String , notes : String)
    {
        if startDate.count > 0 {
            let event:EKEvent = EKEvent(eventStore: appleEventStore)
            event.title = serviceName
            
           
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            if let startDate = dateFormatter.date(from: startDate) {
                print("The date is: \(startDate)")
                event.startDate = startDate
                if let endDate = dateFormatter.date(from: endDate) {
                    event.endDate = endDate
                }
            } else {
                print("Failed to parse date")
                return
            }
            
            event.notes = notes
            
            event.calendar = appleEventStore.defaultCalendarForNewEvents
            
            let aInterval: TimeInterval = -30 * 60
            let alaram = EKAlarm(relativeOffset: aInterval)
            event.alarms = [alaram]
            
            do {
                try appleEventStore.save(event, span: .thisEvent)
                print("events added with dates:")
            } catch let e as NSError {
                print(e.description)
                return
            }
            print("Saved Event")
        }
    }
    
    func MyAppointmentAPI(_ isLoader:Bool){
        var params = [ "Type": "Upcoming"
        ] as [String : Any]
        GetServiceAppointmentsListRequest.shared.GetServiceAppointmentsAPIRequest(requestParams:params, false) { [self] (arrayData,arrayService,message,isStatus) in
            
          
            let calendars = self.appleEventStore.calendars(for: .event)
            if calendars.count > 0 {
                for calendar in calendars {
                    if calendar.title == "Calendar" {
                        let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                        let oneMonthAfter = Date(timeIntervalSinceNow: 30*24*3600)
                        let predicate =  self.appleEventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
                        
                        let events = self.appleEventStore.events(matching: predicate)
                        if events.count > 0 {
                            for event in events {
                                
                                print(event.title)
                                print(event.eventIdentifier)
                                print(event.startDate)
                                
                                let currentDate = event.startDate
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                let formattedDateString = dateFormatter.string(from: currentDate ?? Date())
                                
                                print(formattedDateString)
                                
                                let dateFormatterTime = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm"
                                let timeString = dateFormatter.string(from: currentDate ?? Date())
                                
                                if let matchingPerson = arrayData?.first(where: { person in
                                    
                                    let person = person as? ServiceBooking
                                    return person?.serviceName == event.title &&
                                    person?.slotDate == formattedDateString &&
                                    person?.fromTime == timeString
                                }) as? ServiceBooking {
                                    print("Found person: \(matchingPerson.serviceName), Age: \(matchingPerson.slotDate)")
                                } else {
                                    print("No matching person found.")
                                    
                                    if let eventToDelete = self.appleEventStore.event(withIdentifier: event.eventIdentifier){
                                        do {
                                            try self.appleEventStore.remove(eventToDelete, span: .thisEvent)
                                        } catch let error as NSError {
                                            print("failed to save event with error : \(error)")
                                        }
                                        print("removed Event")
                                    }
                                }
                            }
                        }
                    }
                }
                
            }

            var isNotMatch = false
            for i in 0..<(arrayData?.count ?? 0)
            {
                isNotMatch = false
                let calendars = self.appleEventStore.calendars(for: .event)
                if calendars.count > 0 {
                    for calendar in calendars {
                        if calendar.title == "Calendar" {
                            let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                            let oneMonthAfter = Date(timeIntervalSinceNow: 30*24*3600)
                            let predicate =  self.appleEventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
                            
                            let events = self.appleEventStore.events(matching: predicate)
                            if events.count > 0 {
                                for event in events {
                                    
                                    print(event.title)
                                    print(event.eventIdentifier)
                                    print(event.startDate)
                                    
                                    let currentDate = event.startDate
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    
                                    let formattedDateString = dateFormatter.string(from: currentDate ?? Date())
                                    
                                    print(formattedDateString)
                                    
                                    let dateFormatterTime = DateFormatter()
                                    dateFormatter.dateFormat = "HH:mm"
                                    let timeString = dateFormatter.string(from: currentDate ?? Date())
                                    
                                    if arrayData?[i].serviceName == event.title && arrayData?[i].slotDate == formattedDateString && arrayData?[i].fromTime == timeString{
                                        isNotMatch = true
                                    }
                                    
                                    if let matchingPerson = arrayData?.first(where: { person in
                                        
                                        let person = person as? ServiceBooking
                                        return person?.serviceName == event.title &&
                                        person?.slotDate == formattedDateString
                                    }) as? ServiceBooking {
                                        print("Found person: \(matchingPerson.serviceName), Age: \(matchingPerson.slotDate)")
                                    } else {
                                        print("No matching person found.")
                                        
                                        if let eventToDelete = self.appleEventStore.event(withIdentifier: event.eventIdentifier){
                                            do {
                                                try self.appleEventStore.remove(eventToDelete, span: .thisEvent)
                                            } catch let error as NSError {
                                                print("failed to save event with error : \(error)")
                                            }
                                            print("removed Event")
                                        }
                                    }
                                }
                            }
                            else{
                                if arrayData?.count ?? 0 > 0 {
                                    arrSortedService = arrayData ?? arrSortedService
                                    isNotMatch = true

                                    let dateString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].fromTime)
                                    let dateEndString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].toTime)
                                    
                                    let notes = String(format: "Service: %@ with %@", arrSortedService[i].serviceName, arrSortedService[i].professionalName)
                                    
                                    self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedService[i].serviceName, notes: notes)
                                }
                            }
                        }
                    }
                    
                }
                else{
                    if arrayData?.count ?? 0 > 0 {
                        arrSortedService = arrayData ?? arrSortedService
                        isNotMatch = true

                        let dateString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].fromTime)
                        let dateEndString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].toTime)
                        
                        let notes = String(format: "Service: %@ with %@", arrSortedService[i].serviceName, arrSortedService[i].professionalName)
                        
                        self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedService[i].serviceName, notes: notes)
                        

                    }
                }
                
                if isNotMatch == false {
                    if arrayData?.count ?? 0 > 0 {
                        arrSortedService = arrayData ?? arrSortedService
                        
                        let dateString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].fromTime)
                        let dateEndString = String(format: "%@ %@", arrSortedService[i].slotDate, arrSortedService[i].toTime)
                        
                        let notes = String(format: "Service: %@ with %@", arrSortedService[i].serviceName, arrSortedService[i].professionalName)
                        
                        self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedService[i].serviceName, notes: notes)
                    }
                }
            }
        }
    }
    
    func deleteAllEvents(){
        let calendars = self.appleEventStore.calendars(for: .event)
        if calendars.count > 0 {
            for calendar in calendars {
                if calendar.title == "Calendar" {
                    let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                    let oneMonthAfter = Date(timeIntervalSinceNow: 30*24*3600)
                    let predicate =  self.appleEventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
                    
                    let events = self.appleEventStore.events(matching: predicate)
                    if events.count > 0 {
                        for event in events {
                            
                            print(event.title)
                            print(event.eventIdentifier)
                            print(event.startDate)
                            
                            if let eventToDelete = self.appleEventStore.event(withIdentifier: event.eventIdentifier){
                                do {
                                    try self.appleEventStore.remove(eventToDelete, span: .thisEvent)
                                } catch let error as NSError {
                                    print("failed to save event with error : \(error)")
                                }
                                print("removed Event")
                            }
                            
                          
                        }
                    }
                }
            }
            
        }
    }
}

