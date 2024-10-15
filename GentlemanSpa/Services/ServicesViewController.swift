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
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var view_H_Const: NSLayoutConstraint!
    @IBOutlet weak var viewNoData: UIView!

    @IBOutlet weak var amountLbe: UILabel!
    @IBOutlet weak var countLbe: UILabel!
    
    var arrSortedCategory = [dashboardCategoryObject]()
    var indexInt = 0
    var categoryId = 0
    var genderPreferences = "Male"
    var searchQuery = ""
    var itemCount = 0
    
    var arrSortedService = [ServiceListModel]()
    var arrSortedPackage = [ServiceListModel]()
    var arrSortedTopService = [ServiceListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxtField.delegate = self
        viewNoData.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        categoryAPI(true, true, 1)
        myCartAPI(false)
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
                       "genderPreferences": genderPreferences,
                       "searchQuery" : searchQuery
        ] as [String : Any]
        
        GetServiceListRequest.shared.serviceListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedService.removeAll()
                    self.arrSortedService = arrayData ?? self.arrSortedService
                    DispatchQueue.main.async {
                        if self.arrSortedService.count > 0 {
                            self.viewNoData.isHidden = true
                        }
                        else{
                            self.viewNoData.isHidden = false
                        }
                        self.tableViewMale.reloadData()
                    }
                }
                else{
                    self.arrSortedService.removeAll()
                    self.arrSortedPackage.removeAll()
                    self.tableViewMale.reloadData()
                    self.viewNoData.isHidden = false
                }
            }
            else{
                self.arrSortedService.removeAll()
                self.arrSortedPackage.removeAll()
                self.tableViewMale.reloadData()
                self.viewNoData.isHidden = false
            }
        }
    }
    
    //MARK:- Add Button Tap
    @objc func btnAddTap(sender:UIButton){
        

        arrSortedService[sender.tag].serviceCountInCart = 1
        self.tableViewMale.reloadData()
        
        itemCount = 1
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
        let params = [ "availableService": ""
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus,totalAmount) in
            if isStatus {
                if arrayData != nil{
                    if arrayService?.allServicesArray.count ?? 0 > 0 {
                        totalView.isHidden = false
                        view_H_Const.constant = 70
                        amountLbe.text =  String(format: "$%.2f", arrayService?.totalSellingPrice ?? 0.00)
                        countLbe.text = String(format: "%d services . %@", arrayService?.allServicesArray.count ?? 0,formatDuration(durationInMinutes: arrayService?.durationInMinutes ?? 0))

                        
                        if arrayData?.allCartServicesArray.count == 1 {
                            countLbe.text = String(format: "%d service . %@", arrayService?.allServicesArray.count ?? 0,formatDuration(durationInMinutes: arrayService?.durationInMinutes ?? 0))
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



extension ServicesViewController: UITableViewDataSource,UITableViewDelegate {
    
    
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
            cell.addToCartImage.isHidden = true
        }
        else{
            cell.addView.isHidden = true
            cell.addToCart.isHidden = false
            cell.addToCartImage.isHidden = false

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
      //  let heightSizeLine = arrSortedService[indexPath.row].serviceName.heightForView(text: "", font: UIFont(name:FontName.Inter.Medium, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 52)
        return 100 + 60
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
            let controller:ServiceDetailViewController =  UIStoryboard(storyboard: .User).initVC()
            controller.serviceId = self.arrSortedService[indexPath.row].serviceId
            self.navigationController?.pushViewController(controller, animated: true)
        }
}
    
//MARK: TextField Delegate
extension ServicesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text == "" && string == " "{
            return false
        }
        
        if string != "\n" {
            searchQuery = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        }
        
        if !searchQuery.isEmpty
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in

                self.serviceAPI(false, true, "",self.arrSortedCategory[self.indexInt].mainCategoryId,self.genderPreferences, 0)

            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                searchQuery = ""
                self.serviceAPI(false, true, "",self.arrSortedCategory[self.indexInt].mainCategoryId,self.genderPreferences, 0)

            }
        }
        return true
    }
}
    
    

class ServicesTvCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var addToCartImage: UIImageView!

    @IBOutlet weak var removeCart: UIButton!

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
