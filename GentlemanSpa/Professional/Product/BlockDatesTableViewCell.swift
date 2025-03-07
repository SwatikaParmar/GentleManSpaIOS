//
//  BlockDatesTableViewCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 04/03/25.
//


import UIKit

class BlockDatesTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewBlock : UITableView!
    
    var dateBlockArray  = [String] ()
    var lastClass = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func btnRemoveDateTap(sender:UIButton){
    
        let paramsNew = ["date": dateBlockArray[sender.tag],
                         "status" :  true,
                         "professionalDetailId": professionalDetailId()] as [String : AnyObject]
        
        BlockDate(Model: paramsNew, index: 0)
        
    }
    func BlockDate(Model: [String : AnyObject], index:Int){
        SetSlotStatusRequest.shared.SetSlotStatusAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                    NotificationCenter.default.post(name: Notification.Name("BlockTable_Refresh"), object: nil, userInfo: nil)

                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
    }
    
}

extension BlockDatesTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dateBlockArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableViewBlock.dequeueReusableCell(withIdentifier: "ListBlockDatesTableViewCell") as! ListBlockDatesTableViewCell
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnRemoveDateTap(sender:)), for: .touchUpInside)
        cell.lbeDate.text = dateBlockArray[indexPath.row]
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
      
    }
      
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
}
class ListBlockDatesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var btnRemove: UIButton!

    
}




class AvailableDatesTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewAvailable : UITableView!
    
    var dateSelectArray  = [String] ()
    var lastClass = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 
    
}

extension AvailableDatesTableViewCell: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dateSelectArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableViewAvailable.dequeueReusableCell(withIdentifier: "ListAvailableDatesTableViewCell") as! ListAvailableDatesTableViewCell
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnBlockTap(sender:)), for: .touchUpInside)
        cell.lbeDate.text = dateSelectArray[indexPath.row]
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
      
    }
      
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    
    @objc func btnBlockTap(sender:UIButton){
    
        
        
        let paramsNew = ["date": dateSelectArray[sender.tag],
                         "status" :  false,
                         "professionalDetailId": professionalDetailId()] as [String : AnyObject]
        
        BlockDate(Model: paramsNew, index: 0)
        
    }
    
    func BlockDate(Model: [String : AnyObject], index:Int){
        SetSlotStatusRequest.shared.SetSlotStatusAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                    NotificationCenter.default.post(name: Notification.Name("BlockTable_Refresh"), object: nil, userInfo: nil)


                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
    }
    
}
class ListAvailableDatesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var btnRemove: UIButton!

    
}
