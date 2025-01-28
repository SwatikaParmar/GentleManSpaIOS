//
//  ProProductListVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 21/08/24.
//

import UIKit

class ProProductListVc: UIViewController {
    @IBOutlet weak var tableViewProduct: UITableView!
    var arrSortedService = [ProProductListModel]()
    
    @IBOutlet weak var searchTxtField: UITextField!
    var searchQuery = ""

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()

        searchTxtField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        GetProductAPI(true)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdatePro"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    
    @IBAction func add(_ sender: Any) {
        let controller:ProAddProductVc =  UIStoryboard(storyboard: .Professional).initVC()
        controller.productId = 0
        self.navigationController?.pushViewController(controller, animated: true)
        
    }


//MARK: - productAPI API
func GetProductAPI(_ isLoader:Bool){
    
    let params = [ "SearchQuery": searchQuery,
    ] as [String : Any]
    
    ProGetProductListRequest.shared.productListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
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
                self.tableViewProduct.reloadData()
            }
        }
        else{
            self.arrSortedService.removeAll()
            self.tableViewProduct.reloadData()
        }
    }
}

    func DeleteProductAPI(_ id:Int){
        ProDeleteProductRequest.shared.deleteProductRequest(requestParams: id) { (productId, msg, success,Verification) in
            
            if success == false {
                self.MessageAlert(title: "Alert", message: msg!)
            }
            else
            {
                self.GetProductAPI(false)
            }
        }
    }
}



extension ProProductListVc: UITableViewDataSource,UITableViewDelegate {


func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1

}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
    return self.arrSortedService.count

}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    

        let cell = tableViewProduct.dequeueReusableCell(withIdentifier: "ProProductLstTvCell") as! ProProductLstTvCell

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
        cell.lbeTime.text = ""
        cell.lbeStock.text = String(format: "In Stock: %d", arrSortedService[indexPath.row].stock )
    
    
    
    
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 160
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller:ProAddProductVc =  UIStoryboard(storyboard: .Professional).initVC()
        controller.productId = arrSortedService[indexPath.row].productId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          ActionSheetDelete(id: arrSortedService[indexPath.row].productId , "")
      }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func ActionSheetDelete(id:Int, _ type:String)
    {
        var str = ""
        str = String(format: "Are you sure you want to delete this product?", type)
        let alert = UIAlertController(title: nil, message:str, preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: .default, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: UIAlertAction.Style.destructive, handler: { action in
            self.DeleteProductAPI(id)
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}


//MARK: TextField Delegate
extension ProProductListVc : UITextFieldDelegate {
    
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
                GetProductAPI(false)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                searchQuery = ""
                GetProductAPI(false)
            }
        }
        return true
    }
}
    
    



class ProProductLstTvCell: UITableViewCell {

@IBOutlet weak var addView: UIView!
@IBOutlet weak var addToCart: UIButton!

@IBOutlet weak var imgService: UIImageView!
@IBOutlet weak var lbeName: UILabel!
@IBOutlet weak var lbeAmount: UILabel!

@IBOutlet weak var lbeBasePrice: UILabel!
@IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeStock: UILabel!

override func awakeFromNib() {
    super.awakeFromNib()
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
}

}
