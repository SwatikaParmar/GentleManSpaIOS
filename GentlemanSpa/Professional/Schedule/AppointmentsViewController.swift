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
                                            "fromTime": "",
                                            "toTime": "",
                                            "breakFromTime": "",
                                            "breakToTime": "",
                            ]as [String : Any]
                            
                            
                            let dict : SchedulesModel = SchedulesModel.init(fromDictionary: params)
                            homeListObject.append(dict)
                        }
                        for i in 0 ..< self.arrWeekdaysModel.count {
                            
                            let index = self.arrSchedulesModel.firstIndex{ $0.weekdaysId == self.arrWeekdaysModel[i].weekdaysId}
                            
                            if index != nil {
                                homeListObject[i].professionalScheduleId = self.arrSchedulesModel[index ?? 0].professionalScheduleId
                                homeListObject[i].weekdaysId = self.arrSchedulesModel[index ?? 0].weekdaysId
                                homeListObject[i].fromTime = self.arrSchedulesModel[index ?? 0].fromTime
                                homeListObject[i].toTime = self.arrSchedulesModel[index ?? 0].toTime
                                homeListObject[i].breakFromTime = self.arrSchedulesModel[index ?? 0].breakFromTime
                                homeListObject[i].breakToTime = self.arrSchedulesModel[index ?? 0].breakToTime
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
        
        cell.lbeBreakLine.isHidden = true
        cell.lbeBreak.text = ""
        cell.lbeBreakTitle.isHidden = true
        cell.lbeWorkingTitle.isHidden = true
        cell.lbeWorking.text = ""
        cell.lbeBreakTitle.isHidden = true

        if arrSchedulesModel.count > indexPath.row {
            if arrSchedulesModel[indexPath.row].fromTime == "" {
                cell.lbeWorkingTitle.isHidden = true
                cell.lbeWorking.text = ""
            }
            else{
                cell.lbeWorkingTitle.isHidden = false
                cell.lbeWorking.text = String(format: "%@ %@", arrSchedulesModel[indexPath.row].fromTime,arrSchedulesModel[indexPath.row].toTime)
            }
            
            if arrSchedulesModel[indexPath.row].breakFromTime == "" {
                cell.lbeBreakLine.isHidden = true
                cell.lbeBreak.text = ""
                cell.lbeBreakTitle.isHidden = true
                
            }
            else{
                cell.lbeBreakLine.isHidden = false
                cell.lbeBreak.text = String(format: "%@ %@", arrSchedulesModel[indexPath.row].breakFromTime,arrSchedulesModel[indexPath.row].breakToTime)
                cell.lbeBreakTitle.isHidden = false
                
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if arrWeekdaysModel.count > indexPath.row {
            
            let controller:CreateTimeSlotsController =  UIStoryboard(storyboard: .Professional).initVC()
            controller.selectDate_Title = self.arrWeekdaysModel[indexPath.row].weekName ?? ""
            controller.id = self.arrWeekdaysModel[indexPath.row].weekdaysId
            
            if arrSchedulesModel.count > indexPath.row {
                controller.idUpdate = arrSchedulesModel[indexPath.row].professionalScheduleId

            }
            
            self.parent?.navigationController?.pushViewController(controller, animated: true)
            
            
            
        }
    }
    
}



class SchedulesCell: UITableViewCell {

    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeWorking : UILabel!
    @IBOutlet weak var lbeBreak : UILabel!

    @IBOutlet weak var lbeWorkingTitle : UILabel!
    @IBOutlet weak var lbeBreakTitle : UILabel!
    
    @IBOutlet weak var lbeBreakLine : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
