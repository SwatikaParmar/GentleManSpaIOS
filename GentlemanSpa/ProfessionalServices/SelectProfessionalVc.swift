//
//  SelectProfessionalVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/10/24.
//

import UIKit

class SelectProfessionalVc: UIViewController {
    @IBOutlet weak var tableViewSelectProfessional : UITableView!
    @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
    var arrObjectServices : cartServicesDataModel?
    var arrSortedService = [AllCartServices]()
    func topViewLayout(){
        if !HomeViewController.hasSafeArea{
            if navigationViewConstraint != nil {
               // navigationViewConstraint.constant = 70
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        topViewLayout()
        
       
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
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let heightSizeLine = arrSortedService[indexPath.row].serviceName.heightForView(text: "", font: UIFont(name:FontName.Inter.Medium, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 52)
        return heightSizeLine + 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        controller.spaServiceId = arrSortedService[indexPath.row].spaServiceId
        controller.serviceName = arrSortedService[indexPath.row].serviceName
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
    @objc func btnAddTap(sender:UIButton){
        
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        controller.spaServiceId = arrSortedService[sender.tag].spaServiceId
        controller.serviceName = arrSortedService[sender.tag].serviceName
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
