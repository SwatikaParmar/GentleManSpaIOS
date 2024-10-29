//
//  CreateTimeSlotsController.swift
//  DoctorPet
//
//  Created by Apple on 10/06/21.
//

import UIKit
import DropDown
class CreateTimeSlotsController:UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var selectDate_Title = ""
    var currentDate = ""
    var updateTimeTitle = ""
    var  id  = 0
    var  idUpdate  = 0

    @IBOutlet weak var lbeTitle: UILabel!
    @IBOutlet weak var lbeDateTitle: UILabel!

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endTimeM: UILabel!
    @IBOutlet weak var endTimeAM: UILabel!

    @IBOutlet weak var beginTime: UILabel!
    @IBOutlet weak var beginTimeM: UILabel!
    @IBOutlet weak var beginTimeAM: UILabel!
    @IBOutlet weak var lbeTimeDuration: UILabel!

    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnTimeDuration: UIButton!

    
    
    @IBOutlet weak var startPickerView: UIPickerView!
    @IBOutlet weak var startView: UIView!
    
    @IBOutlet weak var endPickerView: UIPickerView!
    @IBOutlet weak var endView: UIView!
    
    @IBOutlet weak var shView: UIView!
    @IBOutlet weak var endBottomConst: NSLayoutConstraint!
    @IBOutlet weak var startBottomConst: NSLayoutConstraint!
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!

    var DatePassSloat : ((_ startTime : String ,_ endTime : String) -> ())?
    let dropDownTime = DropDown()

    var arrayStart = [String]()
    var arrayEnd = [String]()
    
    var arrayEndPending = [String]()
    var arrayStartPending = [String]()

    var beginTimeS = ""
    var endTimeS = ""
    var startIndex = 0
    var endIndex = 0
    var updateS = ""
    var updateE = ""
    var intTimeDuration = 30

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    
    func topViewLayout(){
           if !CreateTimeSlotsController.hasSafeArea{
               if view_NavConst != nil {
                   view_NavConst.constant = 77
               }
           }
    }
    
    func colorForDropDown(){

       
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        topViewLayout()
        colorForDropDown()

        lbeDateTitle.text = selectDate_Title
        
        if idUpdate != 0 {
            btnCreate.setTitle("Update", for: .normal)
        }
        shView.isHidden = true
        CreateTimeSlot_Array()
    }
    
    
    func CreateTimeSlot_Array(){
     
        var arraySlot: [String] = []
        let startDateString = "14-06-2021 08:00:00"
        let endDateString = "14-06-2021 17:00:00"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateS = formatter.date(from: startDateString)
        let dateE = formatter.date(from: endDateString)
        
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm"

        var i = 0
        while true {
            let date = dateS?.addingTimeInterval(TimeInterval(i*intTimeDuration*60))
            let string = formatterTime.string(from: date!)
            if date! > dateE! {
               // arraySlot.append("23:59")
                break;
            }
            if i == 0{
                arraySlot.append(string)
            }
            i += 1
            if string != "08:00"{
                arraySlot.append(string)
            }
        }
        
        if intTimeDuration == 50 {
            arrayStart = arraySlot
            arrayStart.removeLast()
            arrayStart.removeLast()
            
            arrayEnd = arraySlot
            arrayEnd.removeLast()
        }
        else{
            arrayStart = arraySlot
            arrayStart.removeLast()
            arrayEnd = arraySlot
        }
        setTimeOnPicker()
    }
    
    
    func setTimeOnPicker(){
        
        arrayEndPending.removeAll()
        arrayStartPending.removeAll()

         beginTimeS = ""
         endTimeS = ""
         startIndex = 0
         endIndex = 0
         updateS = ""
         updateE = ""
        
        let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
        let todayStr = formatter.string(from: Date())
    
    
          if currentDate == todayStr {
            if updateTimeTitle == "" {
                
                formatter.dateFormat = "hh:mm a"
                let roundedDateTo = Date().rounded(on:intTimeDuration, .minute)
                print(roundedDateTo)
                
                updateS = formatter.string(from: roundedDateTo)
                
                let calendar = Calendar.current
                let date = calendar.date(byAdding: .minute, value: intTimeDuration, to: roundedDateTo)
            
                updateE = formatter.string(from: date ?? Date())
            }
          }
 

            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeZone = TimeZone.current
            dateFormatter1.dateFormat = "HH:mm"
    
            if updateS != "" {
                let timeArr = updateS.components(separatedBy: ":")
                if timeArr.count > 0 {
                    self.beginTime.text = timeArr[0]
                }
                
                let timeSpaArr = timeArr[1].components(separatedBy: " ")

                self.beginTimeM.text = timeSpaArr[0]
                self.beginTimeAM.text = timeSpaArr[1]
                
                let dateAsString = self.beginTime.text! + ":" + self.beginTimeM.text! + " " +  self.beginTimeAM.text! ?? "AM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let date = dateFormatter.date(from: dateAsString)

                dateFormatter.dateFormat = "HH:mm"
                let date24 = dateFormatter.string(from: date!)
                beginTimeS = date24

                let timeEArr = updateE.components(separatedBy: ":")
                
                if timeEArr.count > 0 {
                    self.endTime.text = timeEArr[0]
                }
                
                let timeSpaEArr = timeEArr[1].components(separatedBy: " ")
                self.endTimeM.text = timeSpaEArr[0]
                self.endTimeAM.text = timeSpaEArr[1]
                
                endTimeS = self.endTime.text! + ":" + self.endTimeM.text!
                
                let dateEndString = self.endTime.text! + ":" + self.endTimeM.text! + " " +  self.endTimeAM.text! ?? "AM"
                
                let dateFormatterE = DateFormatter()
                dateFormatterE.dateFormat = "hh:mm a"
                let dateE = dateFormatterE.date(from: dateEndString)

                dateFormatterE.dateFormat = "HH:mm"
                let dateE24 = dateFormatterE.string(from: dateE!)
                endTimeS = dateE24

        }
                
            if beginTimeS == "" {
                beginTimeS = "08:00"
                self.beginTime.text = "08"
                self.beginTimeM.text = "00"
                self.beginTimeAM.text = "AM"
            }
            if endTimeS == "" {
                if intTimeDuration == 60 {
                    self.endTime.text = "01"
                    self.endTimeM.text = "00"
                    endTimeS = "01:00"
                }
                else{
                    self.endTime.text = "08"
                    self.endTimeM.text = String(intTimeDuration)
                    endTimeS = "08:" + String(intTimeDuration)
                }
                self.endTimeAM.text = "AM"
            }

            
    if currentDate == todayStr {
      if updateTimeTitle == "" {
        var row = Int()
        var isBool = false
        for i in 0..<arrayStart.count
        {
            if beginTimeS == arrayStart[i] {
                 row = i
                 startIndex  = 0
                 isBool = true
                 arrayStartPending.append(arrayStart[i])

            }
            if isBool{
                if row < i {
                    arrayStartPending.append(arrayStart[i])
                }
            }
        }
        
        if  arrayStartPending.count > 0 {
            arrayStart = arrayStartPending
        }
        
        
        var rowe = Int()
        var isBoole = false
        for i in 0..<arrayEnd.count
        {
            if beginTimeS == arrayEnd[i] {
                 rowe = i
                 isBoole = true

            }
            if isBoole{
                if rowe < i {
                    arrayEndPending.append(arrayEnd[i])
                }
            }
        }
        
        if  arrayEndPending.count > 0 {
            arrayEnd = arrayEndPending
        }
        
      }
      else{
        var row = Int()
        var isBool = false
        for i in 0..<arrayEnd.count
        {
            if beginTimeS == arrayEnd[i] {
                 row = i
                 startIndex  = i
                 isBool = true
            }
            if isBool{
                if row < i {
                    arrayEndPending.append(arrayEnd[i])
                }
            }
        }
      }
    }
    else{
        var row = Int()
        var isBool = false
        for i in 0..<arrayEnd.count
        {
            if beginTimeS == arrayEnd[i] {
                 row = i
                 startIndex  = i
                 isBool = true
            }
            if isBool{
                if row < i {
                    arrayEndPending.append(arrayEnd[i])
                }
            }
        }
    
    }
            
        
        self.startPickerView.dataSource = self
        self.startPickerView.delegate = self
            
        self.endPickerView.dataSource = self
        self.endPickerView.delegate = self
            
        startPickerView.selectRow(startIndex, inComponent: 0, animated: false)
        endPickerView.selectRow(endIndex, inComponent: 0, animated: false)
    }
    
    
    @IBAction func TimeDuration(_ sender: Any) {
            dropDownTime.show()
    }

    @IBAction func Close(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    
    @IBAction func Create(_ sender: Any) {
        
        if self.endTime.text == "-"{
                self.MessageAlertEndTime(title: "Oops!", message:"Please select Schedule End Time")
                   }
                   else{
                         CreateSchedule()
                   }
    }
    
    
     func CreateSchedule()
    {

        let timeArray = NSMutableArray()
        let scheduleArray = NSMutableArray()
        var timeShift = Dictionary<String, Any> ()
        
        let strS = currentDate + " " + beginTimeS + ":00"
        let strE = currentDate + " " + endTimeS + ":00"
        
        
        var hh = ""
        var mm = ""
        var a = ""

        var hhE = ""
        var mmE = ""
        var aE = ""
        
        let dateF = DateFormatter()
        dateF.dateFormat = "HH:mm"

        dateF.timeZone = TimeZone.current
        let dt = dateF.date(from: beginTimeS)
        
        dateF.dateFormat = "hh"

        hh = dateF.string(from: dt ?? Date())
        
        if Int(hh) ?? 01  > 12 {
            hh = String((Int(hh) ?? 13) - 12)
        }
        dateF.dateFormat = "mm"
        mm = dateF.string(from: dt ?? Date())
        
        dateF.dateFormat = "a"
        a = dateF.string(from: dt ?? Date())
        
        let startDateGet = hh + ":" + mm + " " + a
        print("12 hour formatted Date:",startDateGet)
        
        dateF.dateFormat = "HH:mm"

        dateF.timeZone = TimeZone.current
        let dtE = dateF.date(from: endTimeS)
        
        dateF.dateFormat = "hh"

        hhE = dateF.string(from: dtE ?? Date())
        
        if Int(hhE) ?? 01  > 12 {
            hhE = String((Int(hhE) ?? 13) - 12)
        }

        dateF.dateFormat = "mm"
        mmE = dateF.string(from: dtE ?? Date())
        
        dateF.dateFormat = "a"
        aE = dateF.string(from: dtE ?? Date())
        
        let startDateEnd = hhE + ":" + mmE + " " + aE
        print("12 hour formatted Date:",startDateEnd)
      
 
      
        
     //   let startDateGet = strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "hh:mm a")
        
    //    let startDateEnd = strE.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "hh:mm a")

//        var startDate = strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//
//        var endDate = strE.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//        
//        
//        var array: [String] = []
//
//        let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//
//        let formatter2 = DateFormatter()
//            formatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
//        let date1 = formatter.date(from: startDate)
//        let date2 = formatter.date(from: endDate)
//        var timeSlotsDict = Dictionary<String, Any> ()
//
//        var startTime = ""
//        var  dict3 = Dictionary<String, Any> ()
//
//  
//        if startDateGet == startDateEnd {
//             startDate = strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//
//             endDate = strE.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//            
//            timeShift.updateValue(startDate, forKey: "fromTime")
//            timeShift.updateValue(endDate, forKey: "toTime")
//            
//            var i = 0
//            while true {
//                let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
//                let string = formatter2.string(from: date!)
//
//                if date! > date2! {
//                    break;
//                }
//                
//                if i == 0{
//                    startTime = string
//                }
//                else{
//                    
//                    timeSlotsDict.updateValue(startTime, forKey: "slotStart")
//                    timeSlotsDict.updateValue(string, forKey: "slotEnd")
//                    
//                    timeArray.add(timeSlotsDict)
//                    startTime = string
//                    timeSlotsDict.removeAll()
//                }
//                
//                i += 1
//                array.append(string)
//
//            }
//            
//            dict3.updateValue(timeArray, forKey: "timeSlots")
//            dict3.updateValue(timeShift, forKey: "timeShift")
//        }
//        else{
//            if updateTimeTitle == "" {
//
//            var timeSlotsDict = Dictionary<String, Any> ()
//
//            if strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "HH:mm:ss") != "23:30:00"
//            {
//                let startDateCutFirst = strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//                
//                let endDateCutFirst = startDateGet + " " + "23:30:00"
//                
//                startDate = startDateCutFirst
//                endDate = endDateCutFirst
//                
//                timeShift.updateValue(startDate, forKey: "fromTime")
//                timeShift.updateValue(endDate, forKey: "toTime")
//                
//                var array: [String] = []
//
//                let formatter = DateFormatter()
//                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//
//                let formatter2 = DateFormatter()
//                    formatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
//                let date1 = formatter.date(from: startDate)
//                let date2 = formatter.date(from: endDate)
//                
//                var i = 0
//                while true {
//                    let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
//                    let string = formatter2.string(from: date!)
//
//                    if date! > date2! {
//                        break;
//                    }
//                    
//                    if i == 0{
//                        startTime = string
//                    }
//                    else{
//                        
//                        timeSlotsDict.updateValue(startTime, forKey: "slotStart")
//                        timeSlotsDict.updateValue(string, forKey: "slotEnd")
//                        
//                        timeArray.add(timeSlotsDict)
//                        startTime = string
//                        timeSlotsDict.removeAll()
//                    }
//                    
//                    i += 1
//                    array.append(string)
//
//                }
//                
//                dict3.updateValue(timeArray, forKey: "timeSlots")
//                dict3.updateValue(timeShift, forKey: "timeShift")
//            }
//
//            
//            timeSlotsDict.removeAll()
//
//            let startDateCutSecond = startDateEnd + " " + "00:00:00"
//            
//            let endDateCutSecond  = endDate
//            
//            startDate = startDateCutSecond
//            endDate = strE.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//            
//            
//            var timeShiftNew = Dictionary<String, Any> ()
//
//            timeShiftNew.updateValue(startDate, forKey: "fromTime")
//            timeShiftNew.updateValue(endDate, forKey: "toTime")
//            
//            var arrayNew: [String] = []
//
//            let formatterEnd = DateFormatter()
//            formatterEnd.dateFormat = "dd-MM-yyyy HH:mm:ss"
//
//            let formatter2End = DateFormatter()
//                formatter2End.dateFormat = "dd-MM-yyyy HH:mm:ss"
//            let date1End = formatterEnd.date(from: startDate)
//            let date2End = formatterEnd.date(from: endDate)
//            let timeArrayNew = NSMutableArray()
//
//            var ii = 0
//            while true {
//                let date = date1End?.addingTimeInterval(TimeInterval(ii*30*60))
//                let string = formatter2End.string(from: date!)
//
//                if date! > date2End! {
//                    break;
//                }
//                
//                if ii == 0{
//                    startTime = string
//                }
//                else{
//                    
//                    timeSlotsDict.updateValue(startTime, forKey: "slotStart")
//                    timeSlotsDict.updateValue(string, forKey: "slotEnd")
//                    
//                    timeArrayNew.add(timeSlotsDict)
//                    startTime = string
//                    timeSlotsDict.removeAll()
//                }
//                
//                ii += 1
//                arrayNew.append(string)
//
//            }
//            
//            var  dict3New = Dictionary<String, Any> ()
//
//            dict3New.updateValue(timeArrayNew, forKey: "timeSlots")
//            dict3New.updateValue(timeShiftNew, forKey: "timeShift")
//            scheduleArray.add(dict3New)
//
//        if timeArrayNew.count > 0 {
//            
//        }
//        else{
//            if dict3.count > 0 {
//    
//            }
//            else{
//                let from = beginTimeS
//                
//                let to = endTimeS
//
//                self.showErrorMSg(text: "You can't create a time shift from " + from + " am to " + to + " am! There was an error connecting to server.")
//                return
//
//            }
//        }
//    }
//            else{
//                startDate = strS.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//
//                endDate = strE.localToUTC(incomingFormat: "dd-MM-yyyy HH:mm:ss", outGoingFormat: "dd-MM-yyyy HH:mm:ss")
//               
//               timeShift.updateValue(startDate, forKey: "fromTime")
//               timeShift.updateValue(endDate, forKey: "toTime")
//               
//               var i = 0
//               while true {
//                   let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
//                   let string = formatter2.string(from: date!)
//
//                   if date! > date2! {
//                       break;
//                   }
//                   
//                   if i == 0{
//                       startTime = string
//                   }
//                   else{
//                       
//                       timeSlotsDict.updateValue(startTime, forKey: "slotStart")
//                       timeSlotsDict.updateValue(string, forKey: "slotEnd")
//                       
//                       timeArray.add(timeSlotsDict)
//                       startTime = string
//                       timeSlotsDict.removeAll()
//                   }
//                   
//                   i += 1
//                   array.append(string)
//
//               }
//               
//               dict3.updateValue(timeArray, forKey: "timeSlots")
//               dict3.updateValue(timeShift, forKey: "timeShift")
//            }
//        
//        }
//        
//        var param = [String : AnyObject]()

        if updateTimeTitle == "" {
//            if dict3.count > 0 {
//                scheduleArray.add(dict3)
//            }
//            param["schedule"] = scheduleArray
//            
//            if !InterNetConnection()
//            {
//                InternetAlert()
//                return
//            }
        
            
            let params = ["professionalScheduleId": idUpdate,
                          "professionalDetailId":professionalDetailId() ,
                          "weekdaysId": id,
                          "fromTime": startDateGet,
                          "toTime": startDateEnd,
                          "breakFromTime":"",
                          "breakToTime" : ""
            ] as [String : Any]


            CreateScheduleAPIRequest.shared.CreateSche(requestParams: params) { (obj, msg, success,Verification) in
                
                if success == false {
                    
                    self.MessageAlert(title: "Alert", message: msg!)
                    
                }
                else
                {
                    self.popMessageAlert(title: "Alert", message: msg!)

                }
            }
        }
    }

    
    
    func alertViewSuccess(title:String,isBool:Bool){
           let alert = UIAlertController(title: "Success!", message:title, preferredStyle: .alert)
           
           let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)

           })
           alert.addAction(ok)
           
           DispatchQueue.main.async(execute: {
               self.present(alert, animated: true)
           })
       }
    
    // MARK: - Error Message Alert -----

    func showErrorMSg(text : String)
       {
            MessageAlert(title:"Oops!",message: text)
       }
    
    func serverToLocal(date:String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.date(from: date)
            return localDate
        }
        
        
    func MessageAlertEndTime(title:String,message:String)
           {
               let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
                   
               }))
               self.present(alert, animated: true, completion: {
                   
               })
           }
        
        @IBAction fileprivate func startBtn(_ sender : UIButton)
        {
            startBottomConst.constant = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.shView.isHidden = false
            })
        }
        
        @IBAction fileprivate func endBtn(_ sender : UIButton)
        {
            endBottomConst.constant = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.shView.isHidden = false
            })
        }
        
        @IBAction fileprivate func endBtnDone(_ sender : UIButton)
        {
            
            endBottomConst.constant = -250
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.shView.isHidden = true
            })
            
            if arrayEndPending.count > 0 {
                let dateF = DateFormatter()
                dateF.dateFormat = "HH:mm"
                dateF.timeZone = TimeZone.current
                let dt = dateF.date(from: arrayEndPending[endIndex])
                dateF.dateFormat = "hh"

                self.endTime.text = dateF.string(from: dt ?? Date())
              
                          dateF.dateFormat = "mm"
                          self.endTimeM.text = dateF.string(from: dt ?? Date())
                          
                          dateF.dateFormat = "a"
                          self.endTimeAM.text = dateF.string(from: dt ?? Date())

                endTimeS = arrayEndPending[endIndex]
            }
            
        }
        
        @IBAction fileprivate func startBtnDone(_ sender : UIButton)
        {
            startBottomConst.constant = -250
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.shView.isHidden = true
            })
        }
        
        //MARK: - Pickerview method
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            if startPickerView == pickerView {
                return arrayStart.count
            }
            else{
                 return arrayEndPending.count
                
            }
        }
        
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label: UILabel
            if startPickerView == pickerView {
            if let view = view {
                label = view as! UILabel
            }
            else {
                label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 40))
            }
                var fonts = UIFont()
                fonts = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(20)) ?? UIFont.systemFont(ofSize: 15)

            var title = arrayStart[row]
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font: fonts]
                
            title = timeConversion12(time24:title)
            label.attributedText = NSAttributedString(string: title, attributes: attributes)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            
            return label
            }
            else{
                if let view = view {
                    label = view as! UILabel
                }
                else {
                    label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 40))
                }
                var fonts = UIFont()
                    fonts = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(20)) ?? UIFont.systemFont(ofSize: 15)
                var title = arrayEndPending[row]
                let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                  NSAttributedString.Key.font: fonts]
                title = timeConversion12(time24:title)
                label.attributedText = NSAttributedString(string: title, attributes: attributes)
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
                label.sizeToFit()
                
                return label
            }
        }
        
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 42
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if startPickerView == pickerView {
                return arrayStart[row]
            }
            else{
                return arrayEndPending[row]
                
            }
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if startPickerView == pickerView {
                arrayEndPending.removeAll()
                let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                let todayStr = formatter.string(from: Date())
                for i in 0..<arrayEnd.count
                {
                    if currentDate == todayStr {
                      if updateTimeTitle == "" {
                        if row <= i {
                          arrayEndPending.append(arrayEnd[i])
                        }
                      }
                      else{
                        if row < i {
                           arrayEndPending.append(arrayEnd[i])
                        }
                      }
                    }
                    else{
                        if row < i {
                           arrayEndPending.append(arrayEnd[i])
                        }
                    }
                }
                endPickerView.reloadAllComponents()
                endPickerView.selectRow(0, inComponent: 0, animated: false)

                let dateF = DateFormatter()
                dateF.dateFormat = "HH:mm"

                dateF.timeZone = TimeZone.current
                let dt = dateF.date(from: arrayStart[row])
                
                dateF.dateFormat = "hh"

                self.beginTime.text = dateF.string(from: dt ?? Date())
    
                dateF.dateFormat = "mm"
                self.beginTimeM.text = dateF.string(from: dt ?? Date())
                
                dateF.dateFormat = "a"
                self.beginTimeAM.text = dateF.string(from: dt ?? Date())

                self.endTime.text = "-"
                self.endTimeM.text = "-"
                self.endTimeAM.text = "-"

                beginTimeS = arrayStart[row]
                startIndex  = row
                endIndex = 0
                 
            }
            else{
                let dateF = DateFormatter()
                dateF.dateFormat = "HH:mm"
                dateF.timeZone = TimeZone.current
                let dt = dateF.date(from: arrayEndPending[row])
                
                dateF.dateFormat = "hh"

                             self.endTime.text = dateF.string(from: dt ?? Date())
                 
                             dateF.dateFormat = "mm"
                             self.endTimeM.text = dateF.string(from: dt ?? Date())
                             
                             dateF.dateFormat = "a"
                             self.endTimeAM.text = dateF.string(from: dt ?? Date())
                endTimeS = arrayEndPending[row]
                endIndex  = row
            }
        }
        
    
    func timeConversion12(time24: String) -> String {
           
           let locale = NSLocale.current
           let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
           if formatter.contains("a") {
               let dateAsString = time24
               let df = DateFormatter()
               df.dateFormat = "HH:mm"
               let date = df.date(from: dateAsString) ?? Date()
               df.dateFormat = "hh:mm a"
               let time12 = df.string(from: date)
               return time12
               
           } else {
               
               return time24
           }
       }
}
extension Date {
    
    func rounded(on amount: Int, _ component: Calendar.Component) -> Date {
        let cal = Calendar.current
        let value = cal.component(component, from: self)
        
        // Compute nearest multiple of amount:
        let roundedValue = lrint(Double(value) / Double(amount)) * amount
        let newDate = cal.date(byAdding: component, value: roundedValue - value, to: self)!
        
        return newDate.floorAllComponents(before: component)
    }
    
    func floorAllComponents(before component: Calendar.Component) -> Date {
        // All components to round ordered by length
        let components = [Calendar.Component.year, .month, .day, .hour, .minute, .second, .nanosecond]
        
        guard let index = components.index(of: component) else {
            fatalError("Wrong component")
        }
        
        let cal = Calendar.current
        var date = self
        
        components.suffix(from: index + 1).forEach { roundComponent in
            let value = cal.component(roundComponent, from: date) * -1
            date = cal.date(byAdding: roundComponent, value: value, to: date)!
        }
        
        return date
}
}

extension String {
    //MARK:- Convert UTC To Local Date by passing date formats value

    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = incomingFormat
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

       let dt = dateFormatter.date(from: self)
       dateFormatter.timeZone = TimeZone.current
      
       dateFormatter.dateFormat = outGoingFormat

       return dateFormatter.string(from: dt ?? Date())
     }


    
    //MARK:- Convert Local To UTC Date by passing date formats value
     func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = incomingFormat
       dateFormatter.calendar = NSCalendar.current
       dateFormatter.timeZone = TimeZone.current

       let dt = dateFormatter.date(from: self)
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
       dateFormatter.dateFormat = outGoingFormat

       return dateFormatter.string(from: dt ?? Date())
     }

}



