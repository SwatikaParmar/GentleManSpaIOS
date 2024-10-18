//
//  MyLocationVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 07/10/24.
//

import UIKit

class MyLocationVc: UIViewController {
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var btnAddress: UIView!

    var arrayAddressData = [AddressListModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTableView.delegate = self
        selectedTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetAddressAPI(true)
    }
    
    
    
    func GetAddressAPI(_ isLoader: Bool){
        
        GetAddressListRequest.shared.getLocationList(requestParams:[:], isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                    self.arrayAddressData.removeAll()
                    self.arrayAddressData = arrayData!
                    DispatchQueue.main.async {
                             
                    self.selectedTableView.reloadData()
                             
                             var Home = "Home"
                             var Work = "Work"
                             var Other = "Other"

                             for i in 0..<self.arrayAddressData.count
                             {
                                 
                                 if self.arrayAddressData[i].addressType == "Home" {
                                     
                                     Home =  ""
                                     
                                 }
                                 
                                 if self.arrayAddressData[i].addressType == "Work" {
                                     
                                     Work =  ""

                                 }
                                 
                                 if self.arrayAddressData[i].addressType == "Other" {
                                     
                                     Other =  ""

                                 }
                             }

                        self.btnAddress.isHidden = true

                        if Home == "Home"{
                                 self.btnAddress.isHidden = false
                                 return
                             }
                        if Work == "Work"{
                                 self.btnAddress.isHidden = false
                                 return
                             }
                        if Other == "Other"{
                            self.btnAddress.isHidden = false
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- btnEdit Tap
    @objc func btnEditTap(sender:UIButton){
        
        
        let controller:MapsViewController =  UIStoryboard(storyboard: .Address).initVC()
        controller.addressType = arrayAddressData[sender.tag].addressType
        controller.apiUpdate = arrayAddressData[sender.tag].addressType
        controller.apiUpdateID = arrayAddressData[sender.tag].customerAddressId
        self.navigationController?.pushViewController(controller, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add_New(_ sender: Any) {
        var Home = "Home"
        var Work = "Work"
        var Other = "Other"
        DispatchQueue.main.async {
            
            for i in 0..<self.arrayAddressData.count
            {
                
                if self.arrayAddressData[i].addressType == "Home" {
                    Home =  ""
                }
                
                if self.arrayAddressData[i].addressType == "Work" {
                    Work =  ""
                }
                
                if self.arrayAddressData[i].addressType == "Other" {
                    Other =  ""
                }
            }
            
            
            let controller:MapsViewController =  UIStoryboard(storyboard: .Address).initVC()
                if Home == "Home"{
                    controller.addressType = "Home"
                    self.navigationController?.pushViewController(controller, animated: true)
                    return
                }
                if Work == "Work"{
                    controller.addressType = "Work"
                    self.navigationController?.pushViewController(controller, animated: true)
                    return
                }
                if Other == "Other"{
                    controller.addressType = "Other"
                    self.navigationController?.pushViewController(controller, animated: true)
                    return
                }
            }
        }
    
    func ActionSheetDelete(shopId:Int, _ type:String)
    {
        var str = ""
        str = String(format: "Are you sure you want to delete %@ address?", type)
        let alert = UIAlertController(title: nil, message:str, preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: .default, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: UIAlertAction.Style.destructive, handler: { action in
            self.deleteAddress(addressId: shopId)
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func deleteAddress(addressId:Int){
        
        AddressDeleteRequest.shared.addressDelete(id:addressId) { (arrayData,message,isStatus) in
            if isStatus {
                self.GetAddressAPI(false)
            }
        }
    }
}

extension MyLocationVc : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddressData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedAddressTableViewCell", for: indexPath) as! SelectedAddressTableViewCell
        cell.lbeType.text = arrayAddressData[indexPath.row].addressType
        
        var stringN = ""
        if arrayAddressData[indexPath.row].nearbyLandMark != "" {
            stringN  = ", " + arrayAddressData[indexPath.row].nearbyLandMark
            if arrayAddressData[indexPath.row].city != "" {
                stringN  =  stringN + ", " + arrayAddressData[indexPath.row].city
            }
            if arrayAddressData[indexPath.row].state != "" {
                stringN  =  stringN + ", " + arrayAddressData[indexPath.row].state
            }
        }
        else{
            if arrayAddressData[indexPath.row].city != "" {
                stringN  = ", " + arrayAddressData[indexPath.row].city
            }
            if arrayAddressData[indexPath.row].state != "" {
                stringN  =  stringN + ", " + arrayAddressData[indexPath.row].state
            }
        }
        
        cell.lbeName.text = arrayAddressData[indexPath.row].houseNoOrBuildingName + ", " + arrayAddressData[indexPath.row].streetAddresss + stringN
        
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditTap(sender:)), for: .touchUpInside)
        
        
        if self.arrayAddressData[indexPath.row].status != 0 {
            cell.lbePrimary.text = "Primary"
        }
        else{
            cell.lbePrimary.text = ""
            
        }
        
        if self.arrayAddressData[indexPath.row].addressType == "Home"{
           // cell.typeImage.image = UIImage(named: "homeM_ic")
        }
        if self.arrayAddressData[indexPath.row].addressType == "Work"{
           // cell.typeImage.image = UIImage(named: "work_ic")
            
        }
        if self.arrayAddressData[indexPath.row].addressType == "Other"{
          //  cell.typeImage.image = UIImage(named: "other_ic")
            
        }
        
        return cell
       
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ActionSheetDelete(shopId: arrayAddressData[indexPath.row].customerAddressId , arrayAddressData[indexPath.row].addressType)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            var sizeFonts = CGFloat()
            
            var str = ""
            str = arrayAddressData[indexPath.row].houseNoOrBuildingName + ", " + arrayAddressData[indexPath.row].streetAddresss + ", " +  arrayAddressData[indexPath.row].nearbyLandMark + ", " +  arrayAddressData[indexPath.row].city + ", " +  arrayAddressData[indexPath.row].state
            sizeFonts  = str.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: 16.0) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 115)
            
        if  self.arrayAddressData[indexPath.row].status == 1 {
            return sizeFonts + 80

        }
            return sizeFonts + 60
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setDataPrimary(arrayAddressData[indexPath.row].customerAddressId)
    }
    
    func setDataPrimary(_ id: Int) {
                
                var param = [String : AnyObject]()
                param["customerAddressId"] =  id  as AnyObject
                param["status"] = true as AnyObject
                
                SetCustomerAddressRequest.shared.SetCustomerAddressAPI(requestParams: param) { (user,message,isStatus) in
                    if isStatus {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    
    
    
        
    



class SelectedAddressTableViewCell: UITableViewCell {
    @IBOutlet var lbeType: UILabel!
    @IBOutlet var lbeName: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lbePrimary: UILabel!
    @IBOutlet var lbeLine: UILabel!

    @IBOutlet var vwRound: UIView!
    @IBOutlet var typeImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
