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
import EventKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var tableUp: UITableView!
    var pageName = "Upcoming"
    let refreshControlUp = UIRefreshControl()
    @IBOutlet weak var viewNoData: UIView!

    @IBOutlet weak var lbeTitlePending: UILabel!
    @IBOutlet weak var lbeLinePending: UIView!
    
    @IBOutlet weak var lbeTitleConfirmed: UILabel!
    @IBOutlet weak var lbeLineConfirmed: UIView!
    @IBOutlet weak var lbeTitlePast: UILabel!
    @IBOutlet weak var lbeLinePast: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    private var userExitPro: DatabaseHandle?
    
    let appleEventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    
    var isOnline = true
    var arrSortedService = [ServiceBooking]()
    var arrSortedServiceEvents = [ServiceBooking]()


    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        topViewLayout()
        self.viewNoData.isHidden = true

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
        self.getUserDataAPI("Profile",true)

       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func Menu_Push_Pro(_ notification: NSNotification) {
        
        if let count = notification.userInfo?["count"] as? String {
            
            
            if count == "Logout"{
                callApiWhenBackgroundedPro(false)
                deleteAllEvents()
                let FCSToken = UserDefaults.standard.value(forKey:Constants.fcmToken)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(FCSToken, forKey:Constants.fcmToken)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(false, forKey: Constants.login)
                UserDefaults.standard.synchronize()
                RootControllerManager().SetRootViewController()
            }
            
            if count == "DeleteAccount"{
                callApiWhenBackgroundedPro(false)
                deleteAllEvents()
                let FCSToken = UserDefaults.standard.value(forKey:Constants.fcmToken)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(FCSToken, forKey:Constants.fcmToken)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(false, forKey: Constants.login)
                UserDefaults.standard.synchronize()
                RootControllerManager().SetRootViewController()
            }
            
            if count == "online"{
                callApiWhenBackgroundedPro(true)
            }
            if count == "offline"{
                callApiWhenBackgroundedPro(false)
            }
            
        }else if  let senderId = notification.userInfo?["senderId"] as? String {
            let userDefaults = UserDefaults.standard
            userDefaults.set(nil, forKey: "senderId")
            self.chatViewOpen(senderId)
            
        }
    }
        
        func chatViewOpen(_ senderId: String) {
            
            let viewControllers: [UIViewController] = TabBarProVc.sharedNavigationControllerPro.viewControllers
            if viewControllers.count > 0 {
                if viewControllers[0].parent?.navigationController?.viewControllers.last is ChatController {
                }
                else{
                    
                    let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
                    controller.otherUserID = senderId
                    viewControllers.last?.parent?.navigationController?.pushViewController(controller, animated: true)

                }
            }
        }
            
    private func callApiWhenBackgroundedPro(_ isOff: Bool) {
        
        let apiURL = "BaseURL".updateOnlineStatusManually

        let url = URL(string: apiURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if accessToken() != ""{
            let bearer : String = "Bearer \(accessToken())"
            print(bearer)
            request.addValue(bearer, forHTTPHeaderField: "Authorization")
        }
        else{
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonPayload = ["userName": userId(),
                           "onlineStatus": isOff] as [String : Any]
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonPayload, options: .prettyPrinted),
           let jsonString = String(data: data, encoding: .utf8) {
            request.httpBody = jsonString.data(using: .utf8)

        }
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 print("Error during API call: \(error)")
                 return
             }
             if let data = data {
                 print("API Response: \(String(data: data, encoding: .utf8) ?? "")")
                 print(isOff)

             }
         }
        task.resume()
     }
    
    func MyAppointmentAPI(_ isLoader:Bool){
        var params = [ "Type": pageName
        ] as [String : Any]
        GetServiceAppointmentsPro.shared.GetSerProAPIRequest(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                arrSortedService = arrayData ?? arrSortedService
                self.tableUp.reloadData()
                self.viewNoData.isHidden = true
                if arrSortedService.count == 0 {
                    self.viewNoData.isHidden = false
                }
                
            }
            else{
                arrSortedService.removeAll()
                self.tableUp.reloadData()
                self.viewNoData.isHidden = false
            }
        }
    }
    
    
    func MyAppointmentAPIEvents(_ isLoader:Bool){
        var params = [ "Type": "Upcoming"
        ] as [String : Any]
        GetServiceAppointmentsPro.shared.GetSerProAPIRequest(requestParams:params, false) { [self] (arrayData,arrayService,message,isStatus) in
            
          
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
                                
                                let currentDate = event.startDate
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                let formattedDateString = dateFormatter.string(from: currentDate ?? Date())
                                
                                print(formattedDateString)
                                
                                let dateFormatterTime = DateFormatter()
                                dateFormatter.dateFormat = "hh:mm a"
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
                                    
                              
                                    let currentDate = event.startDate
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    
                                    let formattedDateString = dateFormatter.string(from: currentDate ?? Date())
                                    
                                    print(formattedDateString)
                                    
                                    let dateFormatterTime = DateFormatter()
                                    dateFormatter.dateFormat = "hh:mm a"
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
                                    arrSortedServiceEvents = arrayData ?? arrSortedServiceEvents
                                    isNotMatch = true

                                    let dateString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].fromTime)
                                    let dateEndString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].toTime)
                                    
                                    let notes = String(format: "Service: %@ for %@", arrSortedServiceEvents[i].serviceName, arrSortedServiceEvents[i].userName ?? "")
                                    
                                    self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedServiceEvents[i].serviceName, notes: notes)
                                }
                            }
                        }
                    }
                    
                }
                else{
                    if arrayData?.count ?? 0 > 0 {
                        arrSortedServiceEvents = arrayData ?? arrSortedServiceEvents
                        isNotMatch = true

                        let dateString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].fromTime)
                        let dateEndString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].toTime)
                        
                        let notes = String(format: "Service: %@ for %@", arrSortedServiceEvents[i].serviceName, arrSortedServiceEvents[i].userName ?? "")
                        
                        self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedServiceEvents[i].serviceName, notes: notes)
                        

                    }
                }
                
                if isNotMatch == false {
                    if arrayData?.count ?? 0 > 0 {
                        arrSortedServiceEvents = arrayData ?? arrSortedServiceEvents
                        
                        let dateString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].fromTime)
                        let dateEndString = String(format: "%@ %@", arrSortedServiceEvents[i].slotDate, arrSortedServiceEvents[i].toTime)
                        
                        let notes = String(format: "Service: %@ for %@", arrSortedServiceEvents[i].serviceName, arrSortedServiceEvents[i].userName ?? "")
                        
                        self.addAppleEvents(dateString, endDate: dateEndString, serviceName: arrSortedServiceEvents[i].serviceName, notes: notes)
                    }
                }
            }
        }
    }
    
    
        
    func getUserDataAPI(_ text:String, _ isLoding:Bool){
            
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
                       
                          
                                self.MyAppointmentAPI(isLoding)
                                self.callApiWhenBackgroundedPro(true)
                                self.generateEvent()
                                self.notificationTokenData()
                            let userDefaults = UserDefaults.standard
                            if let senderId = userDefaults.object(forKey: "senderId") as? String {
                                self.chatViewOpen(senderId)
                            }
                            userDefaults.set(nil, forKey: "senderId")
                            
                        }
                    }
                }
            }
        }
        
    //MARK: - NotificationTokenApi
    func notificationTokenData(){
        
            let param = ["fcmToken" : Constants.fcmTokenFirePuch]
                    NotificationTokenAPIRequest.shared.tokenApi(requestParams: param) { (user,message,isStatus) in
            }
        
    }
    
    @objc func RefreshScreenUp() {
        self.getUserDataAPI("Profile",true)
        refreshControlUp.endRefreshing()
            
    }
    
    
    @IBAction func MyProfile(_ sender: Any) {
       
        let controller:MessageProViewController =  UIStoryboard(storyboard: .Professional).initVC()
        self.parent?.navigationController?.pushViewController(controller, animated: true)
       
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdatePro"), object: nil)
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
        
       
        generateEvent()
        

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

                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )

                
        
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                return cell
            }

           
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if  pageName == "Upcoming" {
                return 230

            }
            else if pageName == "Completed" {
                return 230
            }
            
            return 220

        
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    
    
    @objc func Message_ConnectedPro(sender: UIButton){
        

        open_ChatView(sender.tag)
        
     
    }
    
    func open_ChatView(_ int:Int){
        
        if arrSortedService.count > int{
            let Model = ["currentUserName": userId(),
                             "targetUserName" :  self.arrSortedService[int].userId] as [String : AnyObject]
            AddUserToChatRequest.shared.AddUserToChatAPI(requestParams: Model) { (user,message,isStatus) in
                if isStatus {
                    let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
                    controller.isNewConversation = false
                    controller.otherUserEmail = ""
                    controller.userName =   self.arrSortedService[int].userName ?? ""
                    controller.imgString =  self.arrSortedService[int].userImage ?? "No"
                    controller.otherUserID =  self.arrSortedService[int].userId ?? ""
                    self.parent?.navigationController?.pushViewController(controller, animated: true)
                    
                }
                else{
                    NotificationAlert().NotificationAlert(titles: message ??  GlobalConstants.serverError)
                }
                
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
            self.MyAppointmentAPIEvents(false)
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
                    self.MyAppointmentAPIEvents(false)
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
            
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
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
                var messageString : String = GlobalConstants.serverError
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
