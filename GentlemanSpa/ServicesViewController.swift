//
//  ServicesViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 31/07/24.
//

import UIKit

class ServicesViewController: UIViewController {
    @IBOutlet weak var tableViewMale: UITableView!
    @IBOutlet var cvHeader: UICollectionView!
    var arrSortedCategory = [dashboardCategoryObject]()
    var indexInt = 0
    var categoryId = 0
    var genderPreferences = "Male"

    
    var arrSortedService = [ServiceListModel]()
    var arrSortedPackage = [ServiceListModel]()
    var arrSortedTopService = [ServiceListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        categoryAPI(true, true, 1)

    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPreessed(_ sender: Any){
        
        let controller:FindPViewController =  UIStoryboard(storyboard: .User).initVC()
        self.navigationController?.pushViewController(controller, animated: true)
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
                 
                    
                    if self.arrSortedCategory.count > self.indexInt {
                        self.cvHeader.reloadData()
                        
                        self.serviceAPI(false, true, "",self.arrSortedCategory[self.indexInt].mainCategoryId,self.genderPreferences, 0)
                        if self.arrSortedCategory.count > self.indexInt{
                            self.cvHeader.scrollToItem(at: IndexPath(row: self.indexInt, section: 0), at: .centeredHorizontally, animated: true)
                        }
                        self.cvHeader.reloadData()
                    }
                }
                else{
                    self.arrSortedCategory.removeAll()
                    self.cvHeader.reloadData()
                }
            }
            else{
                self.arrSortedCategory.removeAll()
                
                self.cvHeader.reloadData()
            }
        }
    }
    
    
    
    //MARK: - Service API
    func serviceAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:String, _ categoryId:Int, _ genderPreferences: String, _ subCategoryId:Int){
        
        let params = [ "salonId": 21,
                       "mainCategoryId": categoryId,
                       "subCategoryId": subCategoryId,
                       "genderPreferences": genderPreferences
        ] as [String : Any]
        
        GetServiceListRequest.shared.serviceListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
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
                    self.arrSortedPackage.removeAll()
                    self.tableViewMale.reloadData()
                }
            }
            else{
                self.arrSortedService.removeAll()
                self.arrSortedPackage.removeAll()
                self.tableViewMale.reloadData()
            }
        }
    }
    
    
}



extension ServicesViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrSortedService.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewMale.dequeueReusableCell(withIdentifier: "ServicesTvCell") as! ServicesTvCell
        
        if indexPath.row == 0 {
            cell.addView.isHidden = false
            cell.addToCart.isHidden = true

        }
        else if indexPath.row == 2 {
            cell.addView.isHidden = false
            cell.addToCart.isHidden = true

        }
        else{
            cell.addView.isHidden = true
            cell.addToCart.isHidden = false

        }
        
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
    
    
    
    

class ServicesTvCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeBasePrice: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
