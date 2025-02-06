//
//  AppointmentsViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/08/24.
//

import UIKit

class AppointmentsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
  
    
    @IBOutlet weak var tblCate : UITableView!
    var arrWeekdaysModel = [WeekdaysModel]()
    
    var arrSchedulesModel = [SchedulesModel]()
    let timeArray = NSMutableArray()

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
        topViewLayout()
       
    }
    @IBAction func MyProfile(_ sender: Any) {
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        GetWeekdaysAPI()
    }
    
    //MARK: - Get Weekdays API
    func  GetWeekdaysAPI(){
        
        let params = [ "": ""
        ] as [String : Any]
        
        GetWeekdaysRequest.shared.GetWeekdaysRequestAPI(requestParams:params, true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrWeekdaysModel = arrayData ?? self.arrWeekdaysModel
                 
                    
                    if self.arrWeekdaysModel.count > 0 {
                        self.GetProfessionalSched()
                        self.tblCate.reloadData()
                    }
                }
                else{
                    self.arrWeekdaysModel.removeAll()
                    self.tblCate.reloadData()
                }
            }
            else{
                self.arrWeekdaysModel.removeAll()
                
                self.tblCate.reloadData()
            }
        }
    }
    
    //MARK: - Category API
    func GetProfessionalSched(){
        
        let params = [ "": ""
        ] as [String : Any]
        
        GetProfessionalSchedulesRequest.shared.GetProfessionalSchedAPI(requestParams:params, true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSchedulesModel = arrayData ?? self.arrSchedulesModel
                 
                    var homeListObject : [SchedulesModel] = []

                    if self.arrSchedulesModel.count > 0 {
            
                        for i in 0 ..< self.arrWeekdaysModel.count {
                            
                            let params = [  "professionalScheduleId": 0,
                                            "professionalDetailId": 0,
                                            "weekdaysId": self.arrWeekdaysModel[i].weekdaysId,
                                            
                            ]as [String : Any]
                            
                            
                            let dict : SchedulesModel = SchedulesModel.init(fromDictionary: params)
                            homeListObject.append(dict)
                        }
                        for i in 0 ..< self.arrWeekdaysModel.count {
                            
                            let index = self.arrSchedulesModel.firstIndex{ $0.weekdaysId == self.arrWeekdaysModel[i].weekdaysId}
                            
                            if index != nil {
                                homeListObject[i].professionalScheduleId = self.arrSchedulesModel[index ?? 0].professionalScheduleId
                                homeListObject[i].weekdaysId = self.arrSchedulesModel[index ?? 0].weekdaysId
                                homeListObject[i].workingTime = self.arrSchedulesModel[index ?? 0].workingTime
                                
                            }
                        }
                    }
                        self.arrSchedulesModel = homeListObject
                        self.tblCate.reloadData()
                    }
                }
                else{
                    self.arrSchedulesModel.removeAll()
                    self.tblCate.reloadData()
                }
            }
        }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.arrWeekdaysModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulesCell") as! SchedulesCell
        
        cell.lbeName.text = arrWeekdaysModel[indexPath.row].weekName
        cell.viewOne.isHidden = true
        cell.viewTwo.isHidden = true
        cell.viewAdd.isHidden = false

        if arrSchedulesModel.count > indexPath.row {
            if arrSchedulesModel[indexPath.row].workingTime.count > 0 {
                var dict = NSDictionary()
                dict = arrSchedulesModel[indexPath.row].workingTime[0] as NSDictionary
                cell.lbeWorking.text = String(format: "%@ - %@", dict["fromTime"] as? String ?? "",dict["toTime"] as? String ?? "")
                
                cell.viewOne.isHidden = false
                cell.viewAdd.isHidden = false

            }
            if arrSchedulesModel[indexPath.row].workingTime.count > 1 {
                var dict = NSDictionary()
                dict = arrSchedulesModel[indexPath.row].workingTime[1] as NSDictionary
                cell.lbeWorking1.text = String(format: "%@ - %@", dict["fromTime"] as? String ?? "",dict["toTime"] as? String ?? "")
                
                cell.viewTwo.isHidden = false
                cell.viewAdd.isHidden = true


            }
            
        }
        
    
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit1.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete1.tag = indexPath.row

        cell.btnEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
        cell.btnEdit1.addTarget(self, action: #selector(editAction1(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        cell.btnDelete1.addTarget(self, action: #selector(deleteAction1(sender:)), for: .touchUpInside)


        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 70
        if arrSchedulesModel.count > indexPath.row {
            if arrSchedulesModel[indexPath.row].workingTime.count > 0 {
                height = 118
            }
            if arrSchedulesModel[indexPath.row].workingTime.count > 1 {
                height = 165

            }
            
        }
        return height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        var oldTo = ""
        var oldFrom = ""
        
        
        if arrWeekdaysModel.count > indexPath.row {
            if arrSchedulesModel.count > indexPath.row {
                
                if arrSchedulesModel[indexPath.row].workingTime.count > 0 {
                    var dict = NSDictionary()
                    dict = arrSchedulesModel[indexPath.row].workingTime[0] as NSDictionary
                    oldFrom = dict["fromTime"]  as? String ?? ""
                    oldTo = dict["toTime"]  as? String ?? ""
                    
                }
                if arrSchedulesModel[indexPath.row].workingTime.count > 1 {
                    
                }
                else if arrSchedulesModel[indexPath.row].workingTime.count > 2 {
                }
                else{
                    let controller:CreateTimeSlotsController =  UIStoryboard(storyboard: .Professional).initVC()
                    controller.selectDate_Title = self.arrWeekdaysModel[indexPath.row].weekName ?? ""
                    controller.id = self.arrWeekdaysModel[indexPath.row].weekdaysId
                    controller.oldToTime = oldTo
                    controller.oldFromTime = oldFrom
                    controller.isUpdate = false
                    if arrSchedulesModel.count > indexPath.row {
                        controller.idUpdate = arrSchedulesModel[indexPath.row].professionalScheduleId
                    }
                    self.parent?.navigationController?.pushViewController(controller, animated: true)
                    
                }
            }
            else{
                let controller:CreateTimeSlotsController =  UIStoryboard(storyboard: .Professional).initVC()
                controller.selectDate_Title = self.arrWeekdaysModel[indexPath.row].weekName ?? ""
                controller.id = self.arrWeekdaysModel[indexPath.row].weekdaysId
                controller.oldToTime = oldTo
                controller.oldFromTime = oldFrom
                controller.isUpdate = false
                if arrSchedulesModel.count > indexPath.row {
                    controller.idUpdate = arrSchedulesModel[indexPath.row].professionalScheduleId
                }
                self.parent?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }


    
    @objc func editAction(sender: UIButton){
        let buttonTag = sender.tag
        var oldTo = ""
        var oldFrom = ""
    
        if arrWeekdaysModel.count > buttonTag {
            if arrSchedulesModel[buttonTag].workingTime.count > 1 {
                var dict = NSDictionary()
                dict = arrSchedulesModel[buttonTag].workingTime[1] as NSDictionary
                oldFrom = dict["fromTime"]  as? String ?? ""
                oldTo = dict["toTime"]  as? String ?? ""
            }
          
                let controller:CreateTimeSlotsController =  UIStoryboard(storyboard: .Professional).initVC()
                controller.selectDate_Title = self.arrWeekdaysModel[buttonTag].weekName ?? ""
                controller.id = self.arrWeekdaysModel[buttonTag].weekdaysId
                controller.oldToTime = oldTo
                controller.oldFromTime = oldFrom
                controller.isUpdate = true
                if arrSchedulesModel.count > buttonTag {
                    controller.idUpdate = arrSchedulesModel[buttonTag].professionalScheduleId
                }
                self.parent?.navigationController?.pushViewController(controller, animated: true)
                
            }
    }
    
    @objc func editAction1(sender: UIButton){
        let buttonTag = sender.tag
        var oldTo = ""
        var oldFrom = ""
        if arrWeekdaysModel.count > buttonTag {
            if arrSchedulesModel[buttonTag].workingTime.count > 0 {
                var dict = NSDictionary()
                dict = arrSchedulesModel[buttonTag].workingTime[0] as NSDictionary
                oldFrom = dict["fromTime"]  as? String ?? ""
                oldTo = dict["toTime"]  as? String ?? ""

            }
                let controller:CreateTimeSlotsController =  UIStoryboard(storyboard: .Professional).initVC()
                controller.selectDate_Title = self.arrWeekdaysModel[buttonTag].weekName ?? ""
                controller.id = self.arrWeekdaysModel[buttonTag].weekdaysId
                controller.oldToTime = oldTo
                controller.oldFromTime = oldFrom
                controller.isUpdate = true
                if arrSchedulesModel.count > buttonTag {
                    controller.idUpdate = arrSchedulesModel[buttonTag].professionalScheduleId
                }
                self.parent?.navigationController?.pushViewController(controller, animated: true)
            }
    }
    
    @objc func deleteAction(sender: UIButton){
        let buttonTag = sender.tag
        var oldTo = ""
        var oldFrom = ""
        var timeSlotsDict = Dictionary<String, Any> ()
        timeArray.removeAllObjects()
        
        if arrWeekdaysModel.count > buttonTag {
            if arrSchedulesModel[buttonTag].workingTime.count > 1 {
                var dict = NSDictionary()
                dict = arrSchedulesModel[buttonTag].workingTime[1] as NSDictionary
                oldFrom = dict["fromTime"]  as? String ?? ""
                oldTo = dict["toTime"]  as? String ?? ""
                
                timeSlotsDict.updateValue(oldFrom, forKey: "fromTime")
                timeSlotsDict.updateValue(oldTo, forKey: "toTime")
                timeArray.add(timeSlotsDict)
                
            }
            
            if arrSchedulesModel.count > buttonTag {
                deleteScheduleAPI(idUpdate:self.arrSchedulesModel[buttonTag].professionalScheduleId,id:self.arrWeekdaysModel[buttonTag].weekdaysId)
            }

        }
    }
    
    @objc func deleteAction1(sender: UIButton){
        let buttonTag = sender.tag
        var oldTo = ""
        var oldFrom = ""
        var timeSlotsDict = Dictionary<String, Any> ()
        timeArray.removeAllObjects()
        
        if arrWeekdaysModel.count > buttonTag {
            
            if arrSchedulesModel[buttonTag].workingTime.count > 0 {
                
                var dict = NSDictionary()
                dict = arrSchedulesModel[buttonTag].workingTime[0] as NSDictionary
                oldFrom = dict["fromTime"]  as? String ?? ""
                oldTo = dict["toTime"]  as? String ?? ""
                
                timeSlotsDict.updateValue(oldFrom, forKey: "fromTime")
                timeSlotsDict.updateValue(oldTo, forKey: "toTime")
                timeArray.add(timeSlotsDict)
            }
           
            if arrSchedulesModel.count > buttonTag {
                
                deleteScheduleAPI(idUpdate:self.arrSchedulesModel[buttonTag].professionalScheduleId,id:self.arrWeekdaysModel[buttonTag].weekdaysId)
            }
        }
       
        
    }
    
    func deleteScheduleAPI(idUpdate: Int, id: Int){
        let params = ["professionalScheduleId": idUpdate,
                      "professionalDetailId":professionalDetailId() ,
                      "weekdaysId": id,
                      "workingTime": timeArray
        ] as [String : Any]
        
        print(params)
        
        CreateScheduleAPIRequest.shared.CreateSche(requestParams: params) { (obj, msg, success,Verification) in
            
            if success == false {
                self.MessageAlert(title: "Alert", message: msg!)
            }
            else
            {
                self.successAlert(title: "Alert", message: msg!)
            }
        }
    }
    
    func successAlert(title:String,message:String)
    {
        let alert = UIAlertController(title:"Alert", message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            self.GetWeekdaysAPI()
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
}



class SchedulesCell: UITableViewCell {

    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeWorking : UILabel!
    @IBOutlet weak var lbeWorking1 : UILabel!
    
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnEdit1 : UIButton!
    @IBOutlet weak var btnDelete1 : UIButton!

    @IBOutlet weak var viewOne : UIView!
    @IBOutlet weak var viewTwo : UIView!
    @IBOutlet weak var viewAdd : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
