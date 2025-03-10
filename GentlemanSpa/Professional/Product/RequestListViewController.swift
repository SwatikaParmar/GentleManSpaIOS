//
//  RequestListViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 10/03/25.
//

import UIKit

class RequestListViewController: UIViewController {

    @IBOutlet weak var tableViewRequest : UITableView!
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    var notificationArr = [GetProfessionalListObject]()

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
       
        notificationAPI(true, true, "")

       
    }
    
    func notificationAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:String){
        
        let params = [ "pageNumber": 1
        ] as [String : Any]
        
        ProListRequest.shared.requestProData(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.notificationArr = arrayData ?? self.notificationArr
                    self.tableViewRequest.reloadData()

                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

}
extension RequestListViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return notificationArr.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewRequest.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.notificationTittle.text = notificationArr[indexPath.row].requestType
        cell.notificationDescription.text = notificationArr[indexPath.row].descriptionStr
        let data = notificationArr[indexPath.row]
        //cell.notificationDate.text = self.timeGapBetweenDates(previousDate: data.createDate)
        cell.notificationDate.text = data.status
        
        if data.status == "Approved" {
            cell.notificationDate.textColor = AppColor.GreenTextColor
        }
        else if data.status == "Pending" {
            cell.notificationDate.textColor = .black

        }
        else{
            cell.notificationDate.textColor = .red
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeFont = CGFloat()
        var sizeFontA = CGFloat()
        var sizeFontB = CGFloat()
        if notificationArr.count > indexPath.row {
    
            sizeFont  = notificationArr[indexPath.row].requestType.lineCount(text: "", font: UIFont(name:FontName.Inter.Medium, size: "".dynamicFontSize(16)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.bounds.size.width - 45)
    
            sizeFontA  = notificationArr[indexPath.row].descriptionStr.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.bounds.size.width - 45)
    
        }
        sizeFontB = sizeFont * 20 + 60 + sizeFontA * 20
       
        if sizeFontB > 110{
            return sizeFontB + 30
        }
        return 110

        
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    func timeGapBetweenDates(previousDate : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: previousDate)
        dateFormatter.timeZone = TimeZone.current

        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter.string(from: dt ?? Date())
    }
}
    
    
    
    
class ProListRequest: NSObject {
    
    static let shared = ProListRequest()
    func requestProData(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [GetProfessionalListObject]?,_ message : String?, _ isStatus : Bool) -> Void) {
        
        var apiURL = String("".GetProfessionalRequests)
        apiURL = String(format:"%@?ProfessionalDetailId=%d&SpaDetailId=21",apiURL,professionalDetailId())
        
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
                       
                        var homeListObject : [GetProfessionalListObject] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                
                                let dict : GetProfessionalListObject = GetProfessionalListObject.init(fromDictionary: list as! [String : Any])
                                
                                homeListObject.append(dict)
                                
                                
                            }
                        }
                            completion(homeListObject ,messageString,true)
                        } else{
                            completion(nil,messageString,true)
                        }

                    }else{
                        NotificationAlert().NotificationAlert(titles: messageString)
                        completion(nil,messageString,false)
                    }
                }
                else
                {
                    completion(nil,"",false)
                }
            }
        }
    }


class GetProfessionalListObject : NSObject {
    var requestType =  "" ;
    var status =  "" ;
    var descriptionStr =  "" ;


init(fromDictionary dictionary: [String: Any]) {
    requestType = dictionary["requestType"] as? String ?? ""
    status = dictionary["status"] as? String ?? ""
    descriptionStr = dictionary["description"] as? String ?? ""

    
}

}
