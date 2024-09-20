//
//  ProductDetailsViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 26/08/24.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var imgService: UIImageView!

    @IBOutlet var cvHeader: UICollectionView!
    @IBOutlet var myPageCntrl: UIPageControl!
    
    var arrSortedService:ProductDetailModel?
    var productId = 0
    var itemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        ServiceDetailAPI(true)

    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
  
    func ServiceDetailAPI(_ isLoader:Bool){
        let params = [ "id": productId] as [String : Any]
        ProductDetailRequest.shared.ProductDetailRequestAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedService = arrayData
                    
                    if let imgUrl = self.arrSortedService?.serviceIconImage,!imgUrl.isEmpty {
                        let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                        let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        self.imgService?.sd_setImage(with: URL.init(string:(urlString)),
                                                     placeholderImage: UIImage(named: "shopPlace"),
                                                     options: .refreshCached,
                                                     completed: nil)
                    }
                    else{
                        self.imgService?.image = UIImage(named: "shopPlace")
                    }
                    
                    self.cvHeader.reloadData()
                    self.tableViewDetail.reloadData()
                    
                

                }
            }
        }
    }
    

    
}
extension ProductDetailsViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 2

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "ServicesDetailTvCell") as! ServicesDetailTvCell
            
            cell.lbeName.text = arrSortedService?.serviceName
            cell.lbeTime.text = ""

    
            if arrSortedService?.countInCart ?? 0 > 0{
                
                cell.addToCart.isHidden = true
                cell.addView.isHidden = false
                cell.lbeCount.isHidden = false
                cell.lbeCount.text =   String(arrSortedService?.countInCart ?? 0)
            }
            else{
                cell.addView.isHidden = true
                cell.addToCart.isHidden = false
                cell.lbeCount.text =   String(arrSortedService?.countInCart ?? 0)
                cell.lbeCount.isHidden = false

            }
            
            var listingPrice = ""
            if arrSortedService?.listingPrice.truncatingRemainder(dividingBy: 1) == 0 {
                listingPrice = String(format: "%.0f", arrSortedService?.listingPrice ?? 0.00 )
            }
            else{
                listingPrice = String(format: "%.2f", arrSortedService?.listingPrice ?? 0.00 )
            }
            cell.lbeAmount.text = "$" + listingPrice
            
            var basePrice = ""
            if arrSortedService?.basePrice.truncatingRemainder(dividingBy: 1) == 0 {
                basePrice = String(format: "%.0f", arrSortedService?.basePrice ?? 0.00 )
            }
            else{
                basePrice = String(format: "%.2f", arrSortedService?.basePrice ?? 0.00 )
            }
            cell.lbeBasePrice.text = "$" + basePrice
            
            cell.addToCart.tag = indexPath.row
            cell.addToCart.addTarget(self, action: #selector(btnAddTap(sender:)), for: .touchUpInside)
            
            cell.increaseButton.tag = indexPath.row
            cell.increaseButton.addTarget(self, action: #selector(btnIncreaseButtonTap(sender:)), for: .touchUpInside)
            
            cell.decreaseButton.tag = indexPath.row
            cell.decreaseButton.addTarget(self, action: #selector(btnDecreaseButtonTap(sender:)), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "ServicesDescriptionTvCell") as! ServicesDescriptionTvCell
            
            cell.lbeDes.text = arrSortedService?.serviceDescription
            return cell

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 125
            
        }
        else {
            
            let heightSizeLine = arrSortedService?.serviceDescription.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 190) ?? 0

            
            return heightSizeLine
        }
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
    
    
    @objc func btnAddTap(sender:UIButton){
        
        itemCount = arrSortedService?.countInCart ?? 0
        
        if arrSortedService?.inStock == itemCount {
            var stringCount = ""
            stringCount = String(format:"Can't add more than %d items.", arrSortedService?.inStock ?? 10)
            NotificationAlert().NotificationAlert(titles:stringCount)
            return
        }
        
        arrSortedService?.countInCart = 1
        self.tableViewDetail.reloadData()
        
        itemCount = 1
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService?.productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)
        
    }
    
    //MARK:- Add Button Tap
    @objc func btnIncreaseButtonTap(sender:UIButton){
        
        itemCount = arrSortedService?.countInCart ?? 0
        if arrSortedService?.inStock == itemCount {
            var stringCount = ""
            stringCount = String(format:"Can't add more than %d items.", arrSortedService?.inStock ?? 10)
            NotificationAlert().NotificationAlert(titles:stringCount)
            return
        }
        
      
        arrSortedService?.countInCart  =  (arrSortedService?.countInCart ?? 0)  + 1
        
        itemCount = arrSortedService?.countInCart ?? 0
        
        self.tableViewDetail.reloadData()
        
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService?.productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
        arrSortedService?.countInCart  =  (arrSortedService?.countInCart ?? 0)  - 1
        itemCount = arrSortedService?.countInCart ?? 0
        self.tableViewDetail.reloadData()
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService?.productId as AnyObject

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
          
        }
    }
}


