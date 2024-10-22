//
//  OrderDetailsViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/10/24.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    
    var arrOrderArray = [OrderDetails]()
    var servicesArray: [OrderService] = []
    var productsArray: [OrderProduct] = []
    @IBOutlet weak var viewPayNow : UIView!
    @IBOutlet weak var imgViewEmpty : UIImageView!
    var orderId = 0
    
    @IBOutlet weak var tableViewOrderDetails : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOrderDetails.isHidden = true
        viewPayNow.isHidden = true
        imgViewEmpty.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        OrderDetailsAPI(true)
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func OrderDetailsAPI(_ isLoader:Bool){
        let params = [ "orderId": orderId
        ] as [String : Any]
        
        
        GetOrderDetailRequest.shared.GetOrderDetail(requestParams:params, isLoader) { [self] (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                    if arrayData?.count ?? 0 > 0 {
                        arrOrderArray = arrayData ?? []
                        servicesArray = arrayData?[0].services ?? []
                        productsArray = arrayData?[0].products ?? []
                        tableViewOrderDetails.isHidden = false
                        tableViewOrderDetails.reloadData()
                    }
                }
            }
        }
    }
}
