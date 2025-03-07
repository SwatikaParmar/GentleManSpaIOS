//
//  BlockDatesViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 04/03/25.
//

import UIKit

class BlockDatesViewController: UIViewController {

    var dateSelectArray  = [String] ()
    var dateBlockArray  = [String] ()


    @IBOutlet weak var tableViewDate : UITableView!
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
        dateGetAPI(true)
        availabilityStateAPI(false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.BlockTable_Refresh), name: NSNotification.Name(rawValue: "BlockTable_Refresh"), object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
      
    }
    @objc func BlockTable_Refresh(_ notification: NSNotification) {
        dateGetAPI(true)
        availabilityStateAPI(true)
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - date API
    func dateGetAPI(_ isLoader:Bool){
      
        let params = [ "availabilityState":""] as [String : Any]
        UnAvailableDatesRequest.shared.dateList(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData.count > 0{
                    self.dateSelectArray = arrayData
                    DispatchQueue.main.async {
                        self.tableViewDate.reloadData()
                    }
                }
                else{
                    self.dateSelectArray = arrayData
                    DispatchQueue.main.async {
                        self.tableViewDate.reloadData()
                    }
                }
            }
            else{
                self.dateSelectArray = arrayData
                DispatchQueue.main.async {
                    self.tableViewDate.reloadData()
                }
            }
        }
    }
    
    //MARK: - availabilityState API
    func availabilityStateAPI(_ isLoader:Bool){
      
        let params = [ "availabilityState":"unavailable"] as [String : Any]
        UnAvailableDatesRequest.shared.dateList(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData.count > 0{
                    self.dateBlockArray = arrayData
                    
                    DispatchQueue.main.async {
                        self.tableViewDate.reloadData()
                    }
                }
                else{
                    self.dateBlockArray.removeAll()
                    DispatchQueue.main.async {
                        self.tableViewDate.reloadData()
                    }
                }
            }
            else{
                self.dateBlockArray.removeAll()
                DispatchQueue.main.async {
                    self.tableViewDate.reloadData()
                }
            }
        }
    }
    
    
    


}
extension BlockDatesViewController : UITableViewDataSource,UITableViewDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.dateBlockArray.count > 0{
                return 1

           }
            return 0
        }
        if section == 1 {
            if self.dateSelectArray.count > 0{
                return 1

           }
            return 0
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlockDatesTableViewCell") as! BlockDatesTableViewCell
            
     
            cell.dateBlockArray = dateBlockArray
            cell.tableViewBlock.reloadData()
            cell.lastClass = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableDatesTableViewCell") as! AvailableDatesTableViewCell
            cell.dateSelectArray = dateSelectArray
            cell.tableViewAvailable.reloadData()
                
    
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return CGFloat(70 * dateBlockArray.count) + 35
        }
        else{
            return CGFloat(70 * dateSelectArray.count) + 35

        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if self.dateBlockArray.count > 0{
                return 30
                
            }
            return 0.1
        case 1:
            if self.dateSelectArray.count > 0{
                return 30
                
            }
            return 0.1
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView {
        case tableViewDate:
            let cell = tableViewDate.dequeueReusableCell(withIdentifier: "DashSectionTableViewCell") as! DashSectionTableViewCell
            switch section {
            case 0:
                cell.titleLabel.text = "Block Dates"
                
            case 1:
                cell.titleLabel.text = "Available Dates"
            default:
                return nil
            }
            return cell
    
        default:
            return nil
        }
    }



      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
   
      }
    
    
}


class UnAvailableDatesRequest: NSObject {

    static let shared = UnAvailableDatesRequest()
    
    func dateList(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData:[String],_ message : String?, _ isStatus : Bool) -> Void) {

        var apiURL = "b".getAvailableDates
        apiURL = String(format:"%@?ProfessionalId=%d&availabilityState=%@",apiURL,professionalDetailId(),requestParams["availabilityState"] as? String ?? "")

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
                                 var dateArray = [String]()
                                 if let dataList = data?["data"] as? NSArray{
                                     let formatter = DateFormatter()
                                     let CurrentDate = Date()
                                     formatter.timeZone = TimeZone.current
                                     formatter.dateFormat = "dd-MM-yyyy"
                                     var todayStr = formatter.string(from: CurrentDate)
                                     formatter.timeZone = TimeZone.current
                                     let currentDateTime = formatter.date(from: todayStr)
                                        for list in dataList{
                                            formatter.timeZone = TimeZone.current
                                            formatter.dateFormat = "yyyy-MM-dd"

                                            let dateList = formatter.date(from: list as? String ?? "30-12-2023")
                                   
                                            if currentDateTime ?? Date() <= dateList ?? Date() {
                                                formatter.timeZone = TimeZone.current
                                                formatter.dateFormat = "yyyy-MM-dd"
                                                dateArray.append(formatter.string(from: dateList ?? Date()))
                                            }
                                        }
                                        completion(dateArray,messageString,true)
                                 }
                                 else{
                                     completion([],messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                             }
                         }
                         else
                         {
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                           
                    }
                }
            }
        }



class SetSlotStatusRequest: NSObject {

    static let shared = SetSlotStatusRequest()
    
    func SetSlotStatusAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".SetSlotStatus)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(nil,messageString,true)

                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }else{
                             NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                             completion(nil,"",false)
                         }
                     }else{
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,"",false)
                    }
                }
            }
        }





