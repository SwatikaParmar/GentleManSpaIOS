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
        if HomeViewController.hasSafeArea{
            if navigationViewConstraint != nil {
                navigationViewConstraint.constant = 70
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        topViewLayout()
        
        myCartAPI(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        if arrSortedService[indexPath.row].serviceCountInCart == 0 {
            
            
        }
        else{
            
        }
        
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
        cell.lbeName.text = arrSortedService[indexPath.row].serviceName
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 111
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        controller.serviceId = arrSortedService[indexPath.row].spaServiceId
        controller.serviceName = arrSortedService[indexPath.row].serviceName
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    
    @objc func btnAddTap(sender:UIButton){
        
        let controller:SelectProfessionalListVc =  UIStoryboard(storyboard: .Services).initVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
