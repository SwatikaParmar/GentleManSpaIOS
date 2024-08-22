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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        GetProductAPI(true)
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    
    @IBAction func add(_ sender: Any) {
        let controller:ProAddProductVc =  UIStoryboard(storyboard: .Professional).initVC()
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }


//MARK: - productAPI API
func GetProductAPI(_ isLoader:Bool){
    
    let params = [ "salonId": 0,
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
    cell.lbeTime.text = arrSortedService[indexPath.row].serviceDescription
    cell.lbeStock.text = String(format: "In Stock: %d", arrSortedService[indexPath.row].stock )
    
    
    
    
    return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 160

    
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
