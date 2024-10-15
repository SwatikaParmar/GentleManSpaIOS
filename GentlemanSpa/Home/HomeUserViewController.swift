//
//  HomeUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class HomeUserViewController: UIViewController {
    @IBOutlet weak var tableViewHome : UITableView!
    var arrayHomeBannerModel = [HomeBannerModel]()
    var arrSortedCategory = [dashboardCategoryObject]()
    var arrSortedProductCategories = [ProductCategoriesObject]()
    var arrGetProfessionalList = [GetProfessionalObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        BannerAPI()
        categoryAPI(true, true, 1)
        ProductCategoriesAPI(true, true, 1)
        GetProfessionalListAPI(true, true, 1)
    }
    
    
    
    @IBAction func sideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    
    @IBAction func notification(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "UserNotificationViewController") as?  UserNotificationViewController)!
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Category API
    func categoryAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "categoryType": type,
        ] as [String : Any]
        
        HomeListRequest.shared.homeListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedCategory = arrayData ?? self.arrSortedCategory
                    if self.arrSortedCategory.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrSortedCategory.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrSortedCategory.removeAll()
                self.tableViewHome.reloadData()
            }
        }
    }
    
    //MARK: - Banner
    func BannerAPI(){
        BannerRequest.shared.getBannerListAPI(requestParams:[:], true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrayHomeBannerModel.removeAll()
                    self.arrayHomeBannerModel = arrayData ?? self.arrayHomeBannerModel
                    self.tableViewHome.reloadData()
 
                }
            }
        }
    }
    
    
    //MARK: - ProductCategories API
    func ProductCategoriesAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "categoryType": type,
        ] as [String : Any]
        
        ProductCategoriesRequest.shared.ProductCategoriesRequestAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedProductCategories = arrayData ?? self.arrSortedProductCategories
                    if self.arrSortedProductCategories.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrSortedProductCategories.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrSortedProductCategories.removeAll()
                
                self.tableViewHome.reloadData()
            }
        }
    }
    
    
    //MARK: - GetProfessionalList API
    func GetProfessionalListAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
        ] as [String : Any]
        
        TeamsProfessionalListRequest.shared.TeamsProfessionalListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrGetProfessionalList = arrayData ?? self.arrGetProfessionalList
                    if self.arrGetProfessionalList.count > 0 {
                        self.tableViewHome.reloadData()
                    }
                }
                else{
                    self.arrGetProfessionalList.removeAll()
                    self.tableViewHome.reloadData()
                }
            }
            else{
                self.arrGetProfessionalList.removeAll()
                
                self.tableViewHome.reloadData()
            }
        }
    }
    
}
