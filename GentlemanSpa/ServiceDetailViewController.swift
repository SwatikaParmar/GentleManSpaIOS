//
//  ServiceDetailViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/08/24.
//

import UIKit

class ServiceDetailViewController: UIViewController {
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var imgService: UIImageView!

    @IBOutlet var cvHeader: UICollectionView!
    @IBOutlet var myPageCntrl: UIPageControl!
    
    var arrSortedService:ServiceDetailModel?
    var serviceId = 0
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
        let params = [ "serviceId": serviceId,
                       "spaDetailId":  21] as [String : Any]
        ServiceDetailRequest.shared.serviceDetailAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
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
extension ServiceDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    
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
            
            if self.arrSortedService?.durationInMinutes ?? 0 > 0 {
                
                cell.lbeTime.text = String(format: "%d mins", self.arrSortedService?.durationInMinutes ?? 10)

            }
            else{
                cell.lbeTime.text = "30 mins"

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
}
    
    
    
    

class ServicesDetailTvCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeBasePrice: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class ServicesDescriptionTvCell: UITableViewCell {
    
   
    @IBOutlet weak var lbeDes: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
