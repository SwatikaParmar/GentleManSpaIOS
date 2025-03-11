//
//  NotificationViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/08/24.
//


import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableViewNotification : UITableView!
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    var notificationArr = [NotificationDataList]()

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
        
        NotifiactionListRequest.shared.notificationData(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.notificationArr = arrayData?.notificationList ?? self.notificationArr
                    self.tableViewNotification.reloadData()

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
extension NotificationViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return notificationArr.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewNotification.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.notificationTittle.text = notificationArr[indexPath.row].title
        cell.notificationDescription.text = notificationArr[indexPath.row].descriptionStr
        let data = notificationArr[indexPath.row]
        cell.notificationDate.text = self.timeGapBetweenDates(previousDate: data.createDate)
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeFont = CGFloat()
        var sizeFontA = CGFloat()
        var sizeFontB = CGFloat()
        if notificationArr.count > indexPath.row {
    
            sizeFont  = notificationArr[indexPath.row].title.lineCount(text: "", font: UIFont(name:FontName.Inter.Medium, size: "".dynamicFontSize(13)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.bounds.size.width - 115)
    
            sizeFontA  = notificationArr[indexPath.row].descriptionStr.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(13)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.bounds.size.width - 115)
    
        }
        sizeFontB = sizeFont * 20 + 60 + sizeFontA * 20
       
        if sizeFontB > 110{
            return sizeFontB + 5
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
    
    
    
    
