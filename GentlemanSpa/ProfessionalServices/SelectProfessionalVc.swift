//
//  SelectProfessionalVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/10/24.
//

import UIKit

class SelectProfessionalVc: UIViewController {
    @IBOutlet weak var tableViewSelectProfessional : UITableView!
    @IBOutlet weak var lbeTitle: UILabel!

    
    var arrObjectServices : cartServicesDataModel?
    var arrSortedService = [AllCartServices]()

    var isProfessionalSelectes : Bool = false
    var professionalId : Int = 0
    var professionalName : String = ""
    var professionalImage : String?
    var intArrayId: [Int] = []
    var arrayDataSpeciality = NSArray()

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
        self.navigationController?.navigationBar.isHidden = true
        if isProfessionalSelectes {
            lbeTitle.text = professionalName
        }
        else {
            lbeTitle.text = "Select Professional"

        }
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        myCartAPI(true)
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func myCartAPI(_ isLoader:Bool){
        var params = [ "availableService": ""
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus,totalAmount) in
            if isStatus {
                if arrayService != nil{
                    if arrayService?.allServicesArray.count ?? 0 > 0 {
                        arrObjectServices = arrayService ?? arrObjectServices
                        arrSortedService = arrayService?.allServicesArray ?? arrSortedService
                       
                        if isProfessionalSelectes {
                            let array1 = arrSortedService
            
                            let array2IDs = Set(intArrayId)
                            let matchingUsers = array1.filter { array2IDs.contains($0.serviceId) }
                            
                            print("Has Match: \(matchingUsers)")
                            arrSortedService = matchingUsers
                           
                        }
                        tableViewSelectProfessional.reloadData()
                    }
                    else{
                        arrSortedService.removeAll()
                        tableViewSelectProfessional.reloadData()

                    }
                }
            }
        }
    }
}
extension SelectProfessionalVc: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrSortedService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableViewSelectProfessional.dequeueReusableCell(withIdentifier: "SelectProTableViewCell") as! SelectProTableViewCell
        
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
        cell.lbeName.text = arrSortedService[indexPath.row].serviceName
        
        
        
        if self.arrSortedService[indexPath.row].fromTime == "" {
            cell.lbeTime.text = ""
        }
        else{
            var dateStr = ""
            dateStr =  String(format: "%@, %@ at %@", "".getTodayWeekDay("".dateFromString(self.arrSortedService[indexPath.row].slotDate)),"".convertToDDMMYYYY("".dateFromString(arrSortedService[indexPath.row].slotDate)), self.arrSortedService[indexPath.row].fromTime)
            
            cell.lbeTime.text = dateStr
        }
        if isProfessionalSelectes {
            if arrSortedService[indexPath.row].professionalName == "" {
                cell.lbeProName.text = "Select date and time"
                cell.imgPro?.isHidden = false
            }
            else{
                cell.imgPro?.isHidden = false
                cell.lbeProName.text = arrSortedService[indexPath.row].professionalName
            }
    
            if let imgUrl = self.professionalImage,!imgUrl.isEmpty {
                
                let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell.imgPro?.sd_setImage(with: URL.init(string:(urlString)),
                                         placeholderImage: UIImage(named: "shopPlace"),
                                         options: .refreshCached,
                                         completed: nil)
            }
            else{
                cell.imgPro?.image = UIImage(named: "shopPlace")
            }

        }
        else{
            if arrSortedService[indexPath.row].professionalName == "" {
                cell.lbeProName.text = "Any professional"
                cell.imgPro?.isHidden = true
                
            }
            else{
                cell.imgPro?.isHidden = false
                cell.lbeProName.text = arrSortedService[indexPath.row].professionalName
                
                
                if let imgUrl = arrSortedService[indexPath.row].professionalImage,!imgUrl.isEmpty {
                    let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imgPro?.sd_setImage(with: URL.init(string:(urlString)),
                                             placeholderImage: UIImage(named: "shopPlace"),
                                             options: .refreshCached,
                                             completed: nil)
                }
                else{
                    cell.imgPro?.image = UIImage(named: "shopPlace")
                }
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let heightSizeLine = arrSortedService[indexPath.row].serviceName.heightForView(text: "", font: UIFont(name:FontName.Inter.Medium, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 52)
        return heightSizeLine + 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isProfessionalSelectes {
            let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
            
            controller.name = self.professionalName
            controller.imgUserStr = professionalImage
            controller.arrayData  = arrayDataSpeciality
            controller.professionalId  = professionalId
            controller.spaServiceId = arrSortedService[indexPath.row].spaServiceId
            if arrSortedService[indexPath.row].professionalName != ""{
                controller.isReschedule = true
                controller.isMyCart = false
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            
            let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
            controller.spaServiceId = arrSortedService[indexPath.row].spaServiceId
            controller.serviceName = arrSortedService[indexPath.row].serviceName
            if arrSortedService[indexPath.row].professionalName != ""{
                controller.isReschedule = true
                controller.isMyCart = false
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
 

    }
    
    
    @objc func btnAddTap(sender:UIButton){
        if isProfessionalSelectes {
            let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
            
            controller.name = self.professionalName
            controller.imgUserStr = professionalImage
            controller.arrayData  = arrayDataSpeciality
            controller.professionalId  = professionalId
            controller.spaServiceId = arrSortedService[sender.tag].spaServiceId
            if arrSortedService[sender.tag].professionalName != ""{
                controller.isReschedule = true
                controller.isMyCart = false
                
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
            controller.spaServiceId = arrSortedService[sender.tag].spaServiceId
            controller.serviceName = arrSortedService[sender.tag].serviceName
            if arrSortedService[sender.tag].professionalName != ""{
                controller.isReschedule = true
                controller.isMyCart = false
                
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
