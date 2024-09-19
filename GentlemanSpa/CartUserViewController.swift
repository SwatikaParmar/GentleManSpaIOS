//
//  CartUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class CartUserViewController: UIViewController {
    @IBOutlet weak var tableViewMyCart : UITableView!
    @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var payNow : UIView!
    @IBOutlet weak var imgViewEm : UIImageView!

    
    var arrObject : CartDataModel?
    var arrSortedService = [AllCartProducts]()
    var itemCount = 0
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
        payNow.isHidden = true
        imgViewEm.isHidden = false
        tableViewMyCart.isHidden = true
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
        
        
        GetProductCartRequest.shared.GetCartItemsAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    
                    arrObject = arrayData ?? arrObject
                    if arrayData?.allCartServicesArray.count ?? 0 > 0 {
                        payNow.isHidden = false
                        imgViewEm.isHidden = true
                        tableViewMyCart.isHidden = false
                        arrSortedService = (arrayData?.allCartServicesArray)!
                        tableViewMyCart.reloadData()
                    }
                    else{
                        payNow.isHidden = true
                        imgViewEm.isHidden = false
                        tableViewMyCart.isHidden = true
                    }
                }
                    else{
                        payNow.isHidden = true
                        imgViewEm.isHidden = false
                        tableViewMyCart.isHidden = true
                    }
                }
                else{
                    payNow.isHidden = true
                    imgViewEm.isHidden = false
                    tableViewMyCart.isHidden = true
                }
            }
        }
    
}
extension CartUserViewController: UITableViewDataSource,UITableViewDelegate {
   

      func numberOfSections(in tableView: UITableView) -> Int {
          return 2
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
          
          if section == 0 {
              return arrSortedService.count
          }
          return 1

      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          
          if indexPath.section == 0 {
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "MyCartTableViewCell") as! MyCartTableViewCell
          

              
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
          else{
              let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "BillDetailsTvCell") as! BillDetailsTvCell
              
              
              if arrObject != nil {
                  cell.lbetotalSellingPrice.text = String(format: "$%.2f", self.arrObject?.totalSellingPrice ?? 0.00)
                  
                  cell.lbetotalDiscountAmount.text = String(format: "%.2f", self.arrObject?.totalDiscount ?? 0.00)
                  
                  cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrObject?.totalDiscountAmount ?? 0.00)
                  
                  cell.lbetotalMrp.text = String(format: "$%.2f", self.arrObject?.totalMrp ?? 0.00)
              }
              return cell
          }
      }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
          if indexPath.section == 0 {
              
              if Utility.shared.DivceTypeString() == "IPad" {
                  return  210
              }
              
              return  170
          }
         if self.arrSortedService.count > 0{
             return  180
          }
          return  0
      }

      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
   
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
        
        self.tableViewMyCart.reloadData()
        
        var param = [String : AnyObject]()
        param["productId"] = arrSortedService[sender.tag].productId as AnyObject
        param["countInCart"] = Int(itemCount) as AnyObject
        self.addNewProduct(Model: param, index:sender.tag)

    }
    
    //MARK:- Add Button Tap
    @objc func btnDecreaseButtonTap(sender:UIButton){
        
        arrSortedService[sender.tag].productCountInCart = arrSortedService[sender.tag].productCountInCart - 1
        itemCount = arrSortedService[sender.tag].productCountInCart
        self.tableViewMyCart.reloadData()
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
                  //  NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.successMessage)
                    self.myCartAPI(false)
                
                }
            }
            else{
                NotificationAlert().NotificationAlert(titles:message ?? GlobalConstants.serverError)
            }
        }
        
        
    }
    
  
}

class MyCartTableViewCell: UITableViewCell {
    
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
class BillDetailsTvCell: UITableViewCell {

    @IBOutlet var vwRound: UIView!
    
    @IBOutlet weak var lbetotalDiscount: UILabel!
    @IBOutlet weak var lbetotalDiscountAmount: UILabel!
    @IBOutlet weak var lbetotalMrp: UILabel!
    @IBOutlet weak var lbetotalSellingPrice: UILabel!
    @IBOutlet var viewCancelAmount: UIView!
    @IBOutlet weak var lbeCancel: UILabel!
    @IBOutlet weak var lbeCancelAmount: UILabel!
    @IBOutlet weak var cancelVieewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
