//
//  BookingDoctorViewController.swift
//  AnfasUser
//
//  Created by AbsolveTech on 08/07/24.
//

import UIKit
import EventKit

class BookingDoctorViewController: UIViewController,CalendarViewDataSource,CalendarViewDelegate {
    
    @IBOutlet weak var lbeD : UILabel!
    @IBOutlet weak var lbeSp : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    
    @IBOutlet weak var calenderVw: CalendarView!
    @IBOutlet weak var btnNext_M: UIButton!
    @IBOutlet weak var btnLast_M: UIButton!
    @IBOutlet weak var imgLeftArr: UIImageView!
    @IBOutlet weak var imgRightArr: UIImageView!
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    @IBOutlet weak var timeViewH: NSLayoutConstraint!

    @IBOutlet weak var collectionTime: UICollectionView!
    @IBOutlet weak var lbeSingleDay: UILabel!
    @IBOutlet weak var lbeMultiDays: UILabel!
    @IBOutlet weak var btnSingleDay: UIButton!
    @IBOutlet weak var btnMultiDays: UIButton!
    @IBOutlet weak var lbeSlots: UILabel!
    @IBOutlet var lbeDate: UILabel!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var viewScroll: UIScrollView!

    @IBOutlet weak var lbeNoSlot: UILabel!
    
    var nameMonthArray  = [String] ()
    var arrayData = NSArray()
    var imgUserStr : String?
    var dateSelectArray  = [String] ()
    var selectIndex = Int()
    var isLoadDataOnBack = false
    var strMonth = String()
    var timeIndex = -1
    var singleDays = true
    var serviceId = 0
    var spaServiceId = 0
    var professionalId = 0
    var slotId = 0
    var selectDate = ""
    var selectTime = ""
    var typePackage = ""
    var name = ""
    var arrSortedTime = [TimeListModel]()
    var objectSDetail:ServiceDetailModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbeD.text = name
        
        for i in 0 ..< arrayData.count {
            if i == 0 {
                lbeSp.text = String(format:"%@",arrayData[i] as! CVarArg)
            }
            else{
                lbeSp.text = String(format:"%@, %@", lbeSp.text ?? "", arrayData[i] as! CVarArg)

            }
        }
        
        imgUser?.sd_setImage(with: URL.init(string:(imgUserStr ?? ""))) { (image, error, cache, urls) in
            if (error != nil) {
                self.imgUser.image = UIImage(named: "userProic")
            } else {
                self.imgUser.image = image
                
            }
        }
    
        appendThreeMonthName()
        addCalender()
        
        if singleDays{
            lbeSingleDay.backgroundColor = AppColor.YellowColor
            lbeMultiDays.backgroundColor = UIColor.clear

        }
        else{
            lbeMultiDays.backgroundColor = AppColor.YellowColor
            lbeSingleDay.backgroundColor = UIColor.clear
        }
        lbeMultiDays.textColor = AppColor.BlackColor
        lbeSingleDay.textColor = AppColor.BlackColor

        lbeSingleDay.layer.cornerRadius = 17
        lbeSingleDay.clipsToBounds = true
        lbeSingleDay.layer.masksToBounds = true
        
        lbeMultiDays.layer.cornerRadius = 17
        lbeMultiDays.clipsToBounds = true
        lbeMultiDays.layer.masksToBounds = true
        btnMultiDays.addTarget(self, action: #selector(connected_MultiDays(sender:)), for: .touchUpInside)
        btnSingleDay.addTarget(self, action: #selector(connected_SingleDay(sender:)), for: .touchUpInside)

    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "Deleted")
        
        
        if !InterNetConnection()
        {
            InternetAlert()
            return
        }
    
        if isLoadDataOnBack{
                isLoadDataOnBack = false
                self.selectIndex = 0
                let today = Date()
                self.calenderVw.selectDate(today)
                self.calenderVw.setDisplayDate(today)
            }
        
        self.calenderVw.bookedSlotDate =  self.dateSelectArray
        self.calenderVw.collectionView.reloadData()
        
        }
    
    func changedata(){
        if singleDays{
            lbeSingleDay.backgroundColor = AppColor.YellowColor
            lbeMultiDays.backgroundColor = UIColor.clear

        }
        else{
            lbeMultiDays.backgroundColor = AppColor.YellowColor
            lbeSingleDay.backgroundColor = UIColor.clear
        }
        lbeMultiDays.textColor = AppColor.BlackColor
        lbeSingleDay.textColor = AppColor.BlackColor

        lbeSingleDay.layer.cornerRadius = 17
        lbeSingleDay.clipsToBounds = true
        lbeSingleDay.layer.masksToBounds = true
        
        lbeMultiDays.layer.cornerRadius = 17
        lbeMultiDays.clipsToBounds = true
        lbeMultiDays.layer.masksToBounds = true
   
    }
    
    
    @objc func connected_MultiDays(sender: UIButton){
        singleDays = false
        changedata()
        self.timeGetAPI(false, self.selectDate)
    }
    
    @objc func connected_SingleDay(sender: UIButton){
 
        singleDays = true
        changedata()
        self.timeGetAPI(false, self.selectDate)
    }
    
    @IBAction func Back(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BookingNow(_ sender: Any)
    {
        
        if slotId > 0 {
            var param = [String : AnyObject]()
            param["spaServiceId"] = spaServiceId as AnyObject
            param["spaDetailId"] = 21 as AnyObject
            param["serviceCountInCart"] = 1 as AnyObject
            param["slotId"] = slotId as AnyObject
            
            self.add_Slot(Model: param, index:0)
        }
        else{
            self.MessageAlert(title: "Oops!", message:"Please select time")
        }
    }

    
    
    
    func appendThreeMonthName()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.timeZone = TimeZone.current
        var nameOfMonth = dateFormatter.string(from: Date())
        nameMonthArray.append(nameOfMonth)
        
        var nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        nameOfMonth = dateFormatter.string(from: nextMonth ?? Date())
        nameMonthArray.append(nameOfMonth)
        
        nextMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        nameOfMonth = dateFormatter.string(from: nextMonth ?? Date())
        nameMonthArray.append(nameOfMonth)
    }
    
    
    
    func addCalender(){
        
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.headerTextColor          = UIColor.black
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.black
        CalendarView.Style.cellTextColorWeekend     = AppColor.BlackColor
        CalendarView.Style.cellSelectedColor        = AppColor.BlackColor
        CalendarView.Style.cellSelectedBorderColor  = AppColor.BlackColor
        CalendarView.Style.cellBorderColor          = AppColor.BlackColor
        CalendarView.Style.cellBorderWidth          = 1
        CalendarView.Style.firstWeekday             = .sunday
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        CalendarView.Style.timeZone                 = TimeZone.current
        CalendarView.Style.headerFontName           = FontName.Inter.Regular
        CalendarView.Style.cellEventColor           = UIColor.white
        CalendarView.Style.headerHeight             = 100

        calenderVw.dataSource                       = self
        calenderVw.delegate                         = self
        calenderVw.multipleSelectionEnable          = false
        calenderVw.marksWeekends                    = false
        calenderVw.enableDeslection                 = false
        calenderVw.direction                        = .horizontal

        calenderVw.setDisplayDate(Date())

        btnNext_M.addTarget(self, action: #selector(BookingDoctorViewController.nextMonth), for: .touchUpInside)
        btnLast_M.addTarget(self, action: #selector(BookingDoctorViewController.previousMonth), for: .touchUpInside)
        
        let today = Date()
        self.calenderVw.selectDate(today)
        self.calenderVw.setDisplayDate(today)
        
        DispatchQueue.main.async {
            self.calenderVw.collectionView.reloadData()
        }
        viewScroll.isHidden = true
        
        if InterNetConnection()
        {
            dateGetAPI(true)
        }
        else{
            InternetAlert()
        }
        
    }
    
    
    @objc func nextMonth(sender: UIButton)
    {
        self.calenderVw.goToNextMonth()
    }
    
    @objc func previousMonth(sender: UIButton)
    {
        self.calenderVw.goToPreviousMonth()
    }
    
    
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let today = Date()
        let threeMonthsAgo = self.calenderVw.calendar.date(byAdding: dateComponents, to: today)!
        print(threeMonthsAgo)
        return today
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let today = Date()
        let twoYearsFromNow = self.calenderVw.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
    
   
    
    // MARK : KDCalendarDelegate
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        
    }
    
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.timeZone = TimeZone.current
        let nameOfMonth = dateFormatter.string(from: date)
        
        if nameMonthArray.count > 0 {
            if nameMonthArray[0] == nameOfMonth {
                imgLeftArr.alpha = 0.1
                imgRightArr.alpha = 1
                
                if nameOfMonth == self.strMonth{
                }
                else{
                    self.selectIndex = 0
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone.current
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let monthString = dateFormatter.string(from:Date())
                    //   getData(dateFormatter.date(from:monthString) ?? Date(),true)
                    
                }
            }
        }
        if nameMonthArray.count > 1
        {
            if nameMonthArray[1] == nameOfMonth
            {
                imgLeftArr.alpha = 1
                imgRightArr.alpha = 0.1
                
                if nameOfMonth == self.strMonth
                {
                }
                else
                {
                    self.selectIndex = 1
                    
                    let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone.current
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let monthString = dateFormatter.string(from: nextMonth ?? Date())
                    
                }
            }
        }
        
        if nameMonthArray.count > 2 {
            if nameMonthArray[2] == nameOfMonth {
                imgLeftArr.alpha = 1
                imgRightArr.alpha = 0.1
                
                if nameOfMonth == self.strMonth{
                }
                else
                {
                    self.selectIndex = 2
                    
                    let nextMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone.current
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let monthString = dateFormatter.string(from: nextMonth ?? Date())
                    
                }
            }
        }
    }
    
    
    func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone.current

        let dateStr = formatter.string(from: date)
        let CurrentDate = Date()
        formatter.dateFormat = "dd-MM-yyyy"
        let todayStr = formatter.string(from: CurrentDate)
        if dateSelectArray.contains(dateStr){
            lbeDate.text = dateStr.convertMMDD(date: dateStr)
            if dateStr == todayStr {
                calenderVw.selectDate = dateStr
                DispatchQueue.main.async {
                    self.calenderVw.collectionView.reloadData()
                }
                
                formatter.dateFormat = "yyyy-MM-dd"
                self.selectDate = formatter.string(from: date)
                self.timeGetAPI(false, self.selectDate)

                return true
                
            }
            else if CurrentDate < date {
                calenderVw.selectDate = dateStr
                DispatchQueue.main.async {
                    self.calenderVw.collectionView.reloadData()
                }
                formatter.dateFormat = "yyyy-MM-dd"
                self.selectDate = formatter.string(from: date)
                self.timeGetAPI(false, self.selectDate)
                return true
            }
            
          return false
           
        }
        else{
            return false
        }
    }
    
    
    
    func add_Slot(Model: [String : AnyObject], index:Int){
        AddUpdateCartServiceRequest.shared.AddUpdateCartServiceAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
           
        }
    }
    
    
    
    
    
    //MARK: - date API
    func dateGetAPI(_ isLoader:Bool){
        slotId = 0
        timeIndex = -1
        self.arrSortedTime.removeAll()
        self.collectionTime.reloadData()
        
        let params = [ "SpaServiceIds": spaServiceId,
                       "ProfessionalId": professionalId] as [String : Any]
        AvailableDatesRequest.shared.dateListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData.count > 0{
                    self.dateSelectArray = arrayData
                    self.lbeDate.text =  self.dateSelectArray[0].convertMMDD(date: self.dateSelectArray[0])
                    self.calenderVw.bookedSlotDate = self.dateSelectArray
                    
                    DispatchQueue.main.async {
                        self.calenderVw.collectionView.reloadData()
                    }
                    if self.selectDate == "" {
                        
                        let formatter = DateFormatter()
                        let CurrentDate = self.dateSelectArray[0]
                        formatter.timeZone = TimeZone.current
                        formatter.dateFormat = "dd-MM-yyyy"
                        let currentDateTime = formatter.date(from: CurrentDate)
                        formatter.dateFormat = "yyyy-MM-dd"
                        self.selectDate  = formatter.string(from: currentDateTime ?? Date())
                                                
                        
                        self.calenderVw.selectDate = CurrentDate
                        DispatchQueue.main.async {
                            self.calenderVw.collectionView.reloadData()
                        }
                        self.timeGetAPI(false, self.selectDate)

                    }
                    else{
                        self.timeGetAPI(false,self.selectDate)
                    }
                    self.viewNoData.isHidden = true
                    self.viewScroll.isHidden = false

                }
                else{
                    self.viewNoData.isHidden = false
                    self.viewScroll.isHidden = true

                }
            }
            else{
                self.viewNoData.isHidden = false
                self.viewScroll.isHidden = true

            }
        }
    }
    
    
    //MARK: - Time API
    func timeGetAPI(_ isLoader:Bool, _ dateStr:String){
        let params = [ "SpaServiceIds": spaServiceId,
                       "queryDate":dateStr,
                       "ProfessionalId": professionalId] as [String : Any]
        AvailableTimeRequest.shared.timeListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData?.count ?? 0 > 0{
                    self.arrSortedTime.removeAll()
                    self.lbeNoSlot.isHidden = false

                        for i in 0 ..< (arrayData?.count ?? 0) {
                            let dictionary = ["slotCount": 0]as [String : Any]
                            
                            var from = ""
                            from = arrayData?[i].fromTime  ?? ""
                            
                            if self.singleDays {
                                if from.contains("AM"){
                                    let dict : TimeListModel = TimeListModel.init(fromDictionary: dictionary)
                                    self.arrSortedTime.append(arrayData?[i] ?? dict)
                                    self.lbeNoSlot.isHidden = true

                                }
                            }
                            else{
                                if from.contains("PM"){
                                    let dict : TimeListModel = TimeListModel.init(fromDictionary: dictionary)
                                    self.arrSortedTime.append(arrayData?[i] ?? dict)
                                    self.lbeNoSlot.isHidden = true

                                }
                                
                            }
                        }
                    if self.arrSortedTime.count > 0 {
                        let result = Int(self.arrSortedTime.count) % 4
                        if result == 0 {
                            let count = Int(self.arrSortedTime.count) / 4
                            self.timeViewH.constant =  CGFloat(count * 52)
                        }
                        else{
                            var count = Int(self.arrSortedTime.count) / 4
                            count = count + 1
                            self.timeViewH.constant = CGFloat(count * 52)
                            
                        }
                    }
                    else{
                        self.timeViewH.constant = 52
                        self.arrSortedTime.removeAll()
                        self.lbeNoSlot.isHidden = false
                        self.collectionTime.reloadData()
                    }
                    }
                else{
                    self.arrSortedTime.removeAll()
                    self.lbeNoSlot.isHidden = false
                }
                
                self.collectionTime.reloadData()
                }
            else{
                self.timeViewH.constant = 52
                self.arrSortedTime.removeAll()
                self.lbeNoSlot.isHidden = false
                self.collectionTime.reloadData()

            }
            }
        }
    }
    



