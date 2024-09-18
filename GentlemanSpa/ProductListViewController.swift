//
//  ProductListViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 12/08/24.
//

import UIKit

class ProductListViewController:  UIViewController {
    @IBOutlet weak var tableViewProduct: UITableView!
    @IBOutlet var cvHeader: UICollectionView!
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var view_H_Const: NSLayoutConstraint!

    @IBOutlet weak var amountLbe: UILabel!
    @IBOutlet weak var countLbe: UILabel!

    
    var arrSortedCategory = [ProductCategoriesObject]()
    var indexInt = 0
    var categoryId = 0
    var genderPreferences = "Male"
    var itemCount:Int = 1

    
    var arrSortedService = [ProductListModel]()
    var arrSortedPackage = [ProductListModel]()
    var arrSortedTopService = [ProductListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalView.isHidden = true
        view_H_Const.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        categoryAPI(true, true, 1)
        myCartAPI(false)
    }
    
    func myCartAPI(_ isLoader:Bool){
        var params = [ "availableService": ""
        ] as [String : Any]
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                   
                    if arrayData?.allCartServicesArray.count ?? 0 > 0 {
                        totalView.isHidden = false
                        view_H_Const.constant = 70
                        amountLbe.text =  String(format: "$%.2f", arrayData?.totalSellingPrice ?? 0.00)
                        countLbe.text = String(format: "%d products added", arrayData?.allCartServicesArray.count ?? 0)
                        
                        if arrayData?.allCartServicesArray.count == 1 {
                            countLbe.text = String(format: "%d product added", arrayData?.allCartServicesArray.count ?? 0)

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
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPreessed(_ sender: Any){
        
       
    }
    
    //MARK: - Category API
    func categoryAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "categoryType": type,
        ] as [String : Any]
        
        ProductCategoriesRequest.shared.ProductCategoriesRequestAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedCategory = arrayData ?? self.arrSortedCategory
                 
                    
                    if self.arrSortedCategory.count > 0 {
                    
                        self.tableViewProduct.reloadData()
                        if self.arrSortedCategory.count > self.indexInt {
                            self.cvHeader.reloadData()
                            
                            self.productAPI(false, true, "",self.arrSortedCategory[self.indexInt].mainCategoryId,self.genderPreferences, 0)
                            if self.arrSortedCategory.count > self.indexInt{
                                self.cvHeader.scrollToItem(at: IndexPath(row: self.indexInt, section: 0), at: .centeredHorizontally, animated: true)
                            }
                            self.cvHeader.reloadData()
                        }
                    }
                }
                else{
                    self.arrSortedCategory.removeAll()
                    self.tableViewProduct.reloadData()
                }
            }
            else{
                self.arrSortedCategory.removeAll()
                
                self.tableViewProduct.reloadData()
            }
        }
    }
    
    
    
    //MARK: - productAPI API
    func productAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:String, _ categoryId:Int, _ genderPreferences: String, _ subCategoryId:Int){
        
        let params = [ "salonId": 0,
                       "mainCategoryId": categoryId,
                       "subCategoryId": subCategoryId,
                       "genderPreferences": genderPreferences
        ] as [String : Any]
        
        GetProductListRequest.shared.productListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedService.removeAll()
                    self.arrSortedService = arrayData ?? self.arrSortedService
                    DispatchQueue.main.async {
                        self.tableViewProduct.reloadData()
                    }
                }
                else{
                    self.arrSortedService.removeAll()
                    self.arrSortedPackage.removeAll()
                    self.tableViewProduct.reloadData()
                }
            }
            else{
                self.arrSortedService.removeAll()
                self.arrSortedPackage.removeAll()
                self.tableViewProduct.reloadData()
            }
        }
    }
    
    
}



extension ProductListViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrSortedService.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableViewProduct.dequeueReusableCell(withIdentifier: "ProductLstTvCell") as! ProductLstTvCell
        
     
        if arrSortedService[indexPath.row].productCountInCart > 0{
            
            cell.addToCart.isHidden = true
            cell.addView.isHidden = false
            cell.lbeCount.isHidden = false
            cell.lbeCount.text =   String(arrSortedService[indexPath.row].productCountInCart)
        }
        else{
            cell.addView.isHidden = true
            cell.addToCart.isHidden = false
            cell.lbeCount.text =   String(arrSortedService[indexPath.row].productCountInCart)
            cell.lbeCount.isHidden = false

        }
        
  
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
        
        cell.increaseButton.tag = indexPath.row
        cell.increaseButton.addTarget(self, action: #selector(btnIncreaseButtonTap(sender:)), for: .touchUpInside)
        
        cell.decreaseButton.tag = indexPath.row
        cell.decreaseButton.addTarget(self, action: #selector(btnDecreaseButtonTap(sender:)), for: .touchUpInside)
        
        
        if let imgUrl = arrSortedService[indexPath.row].serviceImage,!imgUrl.isEmpty {
            let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                         placeholderImage: UIImage(named: "productNo"),
                                         options: .refreshCached,
                                         completed: nil)
        }
        else{
            cell.imgService?.image = UIImage(named: "productNo")
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
        
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return 160
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller:ProductDetailsViewController =  UIStoryboard(storyboard: .User).initVC()
        controller.productId = self.arrSortedService[indexPath.row].productId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    //MARK:- Add Button Tap
    @objc func btnAddTap(sender:UIButton){
        
        itemCount = arrSortedService[sender.tag].productCountInCart
        
        if self.arrSortedService[sender.tag].inStock == itemCount {
            var stringCount = ""
            stringCount = String(format:"Can't add more than %d items.", self.arrSortedService[sender.tag].inStock)
            NotificationAlert().NotificationAlert(titles:stringCount)
            return
        }
        
        arrSortedService[sender.tag].productCountInCart = 1
        self.tableViewProduct.reloadData()
        
        itemCount = 1
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService[sender.tag].productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)
        
    }
    
    //MARK:- Add Button Tap
    @objc func btnIncreaseButtonTap(sender:UIButton){
        
        itemCount = arrSortedService[sender.tag].productCountInCart

        
        if self.arrSortedService[sender.tag].inStock == itemCount {
            
            var stringCount = ""
            stringCount = String(format:"Can't add more than %d items.", self.arrSortedService[sender.tag].inStock)
            NotificationAlert().NotificationAlert(titles:stringCount)
            return
        }
        arrSortedService[sender.tag].productCountInCart = arrSortedService[sender.tag].productCountInCart + 1
        
        itemCount = arrSortedService[sender.tag].productCountInCart
        
        self.tableViewProduct.reloadData()
        
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService[sender.tag].productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
        arrSortedService[sender.tag].productCountInCart = arrSortedService[sender.tag].productCountInCart - 1
        itemCount = arrSortedService[sender.tag].productCountInCart
        self.tableViewProduct.reloadData()
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService[sender.tag].productId as AnyObject

        if  itemCount == 0 {
            param["countInCart"] = Int(0) as AnyObject
        }
        else if itemCount < 0 {
            param["countInCart"] = Int(0) as AnyObject
        }
        else{
            param["countInCart"] = Int(itemCount) as AnyObject
        }
        self.addNewProduct(Model: param, index:sender.tag)

    }

    
    func addNewProduct(Model: [String : AnyObject], index:Int){
        AddOrUpdateProductInCartRequest.shared.addProductAPI(requestParams: Model) { (user,message,isStatus) in
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
}

class ProductLstTvCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeBasePrice: UILabel!
    @IBOutlet weak var lbeCount: UILabel!
    
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
