//
//  HistoryUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class HistoryUserViewController: UIViewController {
    @IBOutlet weak var lbeUPCOMING: UILabel!
    @IBOutlet weak var lbeCONFIRMED: UILabel!
    @IBOutlet weak var lbePAST: UILabel!
    @IBOutlet weak var tableUp: UITableView!
    var pageName = "Upcoming"
    var arrSortedService = [ServiceBooking]()
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
      
        lbeUPCOMING.textColor = AppColor.BlackColor
        lbePAST.textColor = AppColor.BlackColor
        lbeCONFIRMED.textColor = AppColor.BlackColor
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
        MyAppointmentAPI(true)
    }
    
    @IBAction func btn_Up(_ sender: Any) {
        
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
        pageName = "Upcoming"
        arrSortedService.removeAll()
        self.tableUp.reloadData()
        MyAppointmentAPI(true)

    }
    
    @IBAction func btn_Co(_ sender: Any) {
        
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = AppColor.BrownColor
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Completed"
        arrSortedService.removeAll()

        self.tableUp.reloadData()
        MyAppointmentAPI(true)

    }
    
    @IBAction func btn_Past(_ sender: Any) {
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = AppColor.BrownColor
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Cancelled"
        arrSortedService.removeAll()

        self.tableUp.reloadData()
      
        MyAppointmentAPI(true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        MyAppointmentAPI(true)
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func MyAppointmentAPI(_ isLoader:Bool){
        var params = [ "Type": pageName
        ] as [String : Any]
        GetServiceAppointmentsListRequest.shared.GetServiceAppointmentsAPIRequest(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                arrSortedService = arrayData ?? arrSortedService
                self.tableUp.reloadData()
            }
        }
    }
}

extension HistoryUserViewController: UITableViewDataSource,UITableViewDelegate {
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1

        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrSortedService.count

        }
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if  pageName == "Upcoming" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "UpcomingUTvCell") as! UpcomingUTvCell
                
                cell.btn_Cancel.tag = indexPath.row
                cell.btn_Cancel.addTarget(self, action: #selector(cancel_Tap(sender:)), for: .touchUpInside)
                
                cell.btn_Reschedule.tag = indexPath.row
                cell.btn_Reschedule.addTarget(self, action: #selector(reschedule_Tap(sender:)), for: .touchUpInside)
                
                if let imgUrl = arrSortedService[indexPath.row].image,!imgUrl.isEmpty {
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
                cell.lbeName.text = arrSortedService[indexPath.row].serviceName
                
                var listingPrice = ""
                if arrSortedService[indexPath.row].price.truncatingRemainder(dividingBy: 1) == 0 {
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                else{
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                cell.lbeAmount.text = "$" + listingPrice
                
                if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
                    cell.lbeDuration.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes)
                }
                else{
                    cell.lbeDuration.text = "30 mins"
                }
                
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                
                cell.lbeProfessionalName.text = String(format: "%@", self.arrSortedService[indexPath.row].professionalName )
                
                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )
                cell.btnMessage.tag = indexPath.row
                cell.btnMessage.addTarget(self, action: #selector(Message_Connected(sender:)), for: .touchUpInside)
                cell.viewMessage.alpha = 1
                
                return cell
            }
            else if pageName == "Completed" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "ConfirmedUTvCell") as! ConfirmedUTvCell
                if let imgUrl = arrSortedService[indexPath.row].image,!imgUrl.isEmpty {
                    let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                                 placeholderImage: UIImage(named: "placeHolderSer"),
                                                 options: .refreshCached,
                                                 completed: nil)
                }
                else{
                    cell.imgService?.image = UIImage(named: "placeHolderSer")
                }
                cell.lbeName.text = arrSortedService[indexPath.row].serviceName
                
                
                var listingPrice = ""
                if arrSortedService[indexPath.row].price.truncatingRemainder(dividingBy: 1) == 0 {
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                else{
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                cell.lbeAmount.text = "$" + listingPrice
                
                if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
                    cell.lbeDuration.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes)
                }
                else{
                    cell.lbeDuration.text = "30 mins"
                }
                
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                
                cell.lbeProfessionalName.text = String(format: "%@", self.arrSortedService[indexPath.row].professionalName )
                
                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )
                cell.btnMessage.tag = indexPath.row
                cell.btnMessage.addTarget(self, action: #selector(Message_Connected(sender:)), for: .touchUpInside)
                cell.viewMessage.alpha = 1
                return cell
            }
            else{
                let cell = tableUp.dequeueReusableCell(withIdentifier: "PastUTvCell") as! PastUTvCell
                if let imgUrl = arrSortedService[indexPath.row].image,!imgUrl.isEmpty {
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
                cell.lbeName.text = arrSortedService[indexPath.row].serviceName
                
                
                var listingPrice = ""
                if arrSortedService[indexPath.row].price.truncatingRemainder(dividingBy: 1) == 0 {
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                else{
                    listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].price )
                }
                cell.lbeAmount.text = "$" + listingPrice
                
                if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
                    cell.lbeDuration.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes)
                }
                else{
                    cell.lbeDuration.text = "30 mins"
                }
                
                var dateStr = ""
                dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
                
                cell.lbeTime.text = dateStr
                cell.lbeBookingID.text = String(format: "BOOKING ID: %d", self.arrSortedService[indexPath.row].orderId )

                return cell
            }
        }
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if  pageName == "Upcoming" {
                return 260

            }
            else if pageName == "Completed" {
                return 260
            }
            
            return 210

        
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    
    @objc func Message_Connected(sender: UIButton){
        open_ChatView(sender.tag)
    }
    
    func open_ChatView(_ int:Int){
        
        if arrSortedService.count > int{
            let Model = ["currentUserName": userId(),
                             "targetUserName" :  self.arrSortedService[int].ProfessionalUserId] as [String : AnyObject]
            AddUserToChatRequest.shared.AddUserToChatAPI(requestParams: Model) { (user,message,isStatus) in
                let controller:ChatController =  UIStoryboard(storyboard: .Chat).initVC()
                controller.isNewConversation = false
                controller.otherUserEmail = "Email"
                controller.userName =   self.arrSortedService[int].professionalName
                controller.imgString =  self.arrSortedService[int].professionalImage ?? "No"
                controller.otherUserID =  self.arrSortedService[int].ProfessionalUserId ?? ""
                self.parent?.navigationController?.pushViewController(controller, animated: true)
                
                
                }
            }
    }
    
    //MARK:- Add Button Tap
    @objc func reschedule_Tap(sender:UIButton){
        
        
        let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
        controller.name = self.arrSortedService[sender.tag].professionalName
        if let imgUrl = self.arrSortedService[sender.tag].professionalImage,!imgUrl.isEmpty {
            
            let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            controller.imgUserStr = urlString
        }
        controller.professionalId  = self.arrSortedService[sender.tag].professionalDetailId
        controller.spaServiceId = self.arrSortedService[sender.tag].spaServiceId
        controller.orderId = self.arrSortedService[sender.tag].orderId
        controller.serviceBookingId = self.arrSortedService[sender.tag].serviceBookingId

        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Add Button Tap
    @objc func cancel_Tap(sender:UIButton){
        var str = ""
        str = String(format: "Are you sure you want to cancel Service?")
        let alert = UIAlertController(title: nil, message:str, preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: .default, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: UIAlertAction.Style.destructive, handler: { action in
            
            var array : [Int] = []
            array.append(self.arrSortedService[sender.tag].serviceBookingId)
            
            let paramsNew = ["serviceBookingIds": array,
                             "orderId" :  self.arrSortedService[sender.tag].orderId] as [String : AnyObject]
            
            
            
            self.CancelService(Model: paramsNew, index: 0)
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func CancelService(Model: [String : AnyObject], index:Int){
        CancelOrderServiceRequest.shared.CancelOrderAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                    self.MyAppointmentAPI(false)
                    
                    NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":"CancelService"])

                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
    }
}
    
    
    
    

class UpcomingUTvCell: UITableViewCell {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeProfessionalName: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!
    
    @IBOutlet weak var btn_Reschedule: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnMessage : UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class ConfirmedUTvCell: UITableViewCell {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeProfessionalName: UILabel!
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
class PastUTvCell: UITableViewCell {
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    @IBOutlet weak var lbeDuration: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeProfessionalName: UILabel!
    @IBOutlet weak var lbeBookingID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
