//
//  ProfessionalServicesVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/09/24.
//

import UIKit

class ProfessionalServicesVc: UIViewController {

    var arrSortedService = [ServiceListModel]()
    var professionalDetailId = 0
    var name = ""
    var arrayData = NSArray()
    var imgUser : String?
    @IBOutlet weak var tableViewMale: UITableView!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var view_H_Const: NSLayoutConstraint!

    @IBOutlet weak var amountLbe: UILabel!
    @IBOutlet weak var countLbe: UILabel!

    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbeSpe: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalView.isHidden = true
        view_H_Const.constant = 0
        lbeName.text = name
        
        for i in 0 ..< arrayData.count {
            if i == 0 {
                lbeSpe.text = String(format:"%@",arrayData[i] as! CVarArg)
            }
            else{
                lbeSpe.text = String(format:"%@, %@", lbeSpe.text ?? "", arrayData[i] as! CVarArg)

            }
        }
        
        imgView?.sd_setImage(with: URL.init(string:(imgUser ?? ""))) { (image, error, cache, urls) in
            if (error != nil) {
                self.imgView.image = UIImage(named: "userProic")
            } else {
                self.imgView.image = image
                
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        serviceAPI(true)
        self.myCartAPI(false)

    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPreessed(_ sender: Any){
        
        let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
        
        controller.name = self.name
        
            controller.imgUserStr = imgUser
        
        controller.arrayData  = arrayData
        controller.professionalDetailId  = professionalDetailId
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    //MARK: - Service API
    func serviceAPI(_ isLoader:Bool){
        
        let params = [ "professionalDetailId":  professionalDetailId
        ] as [String : Any]
        
        GetProfessionalServicesRequest.shared.GetProfessionalServicesListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedService.removeAll()
                    self.arrSortedService = arrayData ?? self.arrSortedService
                    DispatchQueue.main.async {
                        self.tableViewMale.reloadData()
                    }
                }
                else{
                    self.arrSortedService.removeAll()
                    self.tableViewMale.reloadData()
                }
            }
            else{
                self.arrSortedService.removeAll()
                self.tableViewMale.reloadData()
            }
        }
    }
    //MARK:- Add Button Tap
    @objc func btnAddTap(sender:UIButton){
        

        arrSortedService[sender.tag].serviceCountInCart = 1
        self.tableViewMale.reloadData()
        
       
        var param = [String : AnyObject]()
        param["spaServiceId"] = arrSortedService[sender.tag].spaServiceId as AnyObject
        param["spaDetailId"] = 21 as AnyObject
        param["serviceCountInCart"] = 1 as AnyObject
        param["slotId"] = 0 as AnyObject

        
        self.addNewProduct(Model: param, index:sender.tag)
        
    }
    
    //MARK:- Add Button Tap
    @objc func btnremoveCartTap(sender:UIButton){
        

        arrSortedService[sender.tag].serviceCountInCart = 0
        self.tableViewMale.reloadData()
        
        var param = [String : AnyObject]()
        param["spaServiceId"] = arrSortedService[sender.tag].spaServiceId as AnyObject
        param["spaDetailId"] = 21 as AnyObject
        param["serviceCountInCart"] = 0 as AnyObject
        param["slotId"] = 0 as AnyObject

        self.addNewProduct(Model: param, index:sender.tag)
        
    }
    
    
    
    
    func addNewProduct(Model: [String : AnyObject], index:Int){
        AddUpdateCartServiceRequest.shared.AddUpdateCartServiceAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                if isStatus {
                    NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
            self.myCartAPI(false)
        }
    }
    
    
    func myCartAPI(_ isLoader:Bool){
        var params = [ "availableService": ""
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                   
                    if arrayService?.allServicesArray.count ?? 0 > 0 {
                        totalView.isHidden = false
                        view_H_Const.constant = 70
                        amountLbe.text =  String(format: "$%.2f", arrayService?.totalSellingPrice ?? 0.00)
                        countLbe.text = String(format: "%d services . %d mins", arrayService?.allServicesArray.count ?? 0,arrayService?.durationInMinutes ?? 0)
                        
                        if arrayData?.allCartServicesArray.count == 1 {
                            countLbe.text = String(format: "%d service . %d mins", arrayService?.allServicesArray.count ?? 0,arrayService?.durationInMinutes ?? 0)

                        }
                    }
                    else{
                        totalView.isHidden = true
                        view_H_Const.constant = 0
                    }
                }
                    else{
                        totalView.isHidden = true
                        view_H_Const.constant = 0
                    }
                }
                else{
                    totalView.isHidden = true
                    view_H_Const.constant = 0
                }
            }
        }
}



extension ProfessionalServicesVc: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrSortedService.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewMale.dequeueReusableCell(withIdentifier: "ServicesTvCell") as! ServicesTvCell
        
        if arrSortedService[indexPath.row].serviceCountInCart == 1 {
            cell.addView.isHidden = false
            cell.addToCart.isHidden = true

        }
        else{
            cell.addView.isHidden = true
            cell.addToCart.isHidden = false

        }
        
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
        
        cell.removeCart.tag = indexPath.row
        cell.removeCart.addTarget(self, action: #selector(btnremoveCartTap(sender:)), for: .touchUpInside)
        
        if let imgUrl = arrSortedService[indexPath.row].serviceImage,!imgUrl.isEmpty {
            let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                         placeholderImage: UIImage(named: "shopPlace"),
                                         options: .refreshCached,
                                         completed: nil)
        }
        else{
            cell.imgService?.image = UIImage(named: "shopPlace")
        }
        cell.lbeName.text = arrSortedService[indexPath.row].serviceName
        
        
        var listingPrice = ""
        if arrSortedService[indexPath.row].listingPrice.truncatingRemainder(dividingBy: 1) == 0 {
            listingPrice = String(format: "%.0f", arrSortedService[indexPath.row].listingPrice )
        }
        else{
            listingPrice = String(format: "%.2f", arrSortedService[indexPath.row].listingPrice )
        }
        cell.lbeAmount.text = "$" + listingPrice
        
        
        var basePrice = ""
        if arrSortedService[indexPath.row].basePrice.truncatingRemainder(dividingBy: 1) == 0 {
            basePrice = String(format: "%.0f", arrSortedService[indexPath.row].basePrice )
        }
        else{
            basePrice = String(format: "%.2f", arrSortedService[indexPath.row].basePrice )
        }
        cell.lbeBasePrice.text = "$" + basePrice
        if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
            cell.lbeTime.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes )
            
        }
        else{
            cell.lbeTime.text = "30 mins"
        }
        
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller:ServiceDetailViewController =  UIStoryboard(storyboard: .User).initVC()
            controller.serviceId = self.arrSortedService[indexPath.row].serviceId
            self.navigationController?.pushViewController(controller, animated: true)
        }
}
    
