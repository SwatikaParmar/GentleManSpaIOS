//
//  MyServiceViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 06/08/24.
//

import UIKit

class MyServiceViewController: UIViewController {
    var arrSortedService = [ServiceListModel]()
    @IBOutlet weak var tableViewMale: UITableView!

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

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        serviceAPI(true)
    }
   
    

    @IBAction func sideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdatePro"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    //MARK: - Service API
    func serviceAPI(_ isLoader:Bool){
        
        let params = [ "professionalDetailId": professionalDetailId()] as [String : Any]
        
        MyServiceListRequest.shared.MyServiceAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
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
                    self.tableViewMale.reloadData()
                }
            }
            else{
                self.arrSortedService.removeAll()
                self.tableViewMale.reloadData()
            }
        }
    }

}

extension MyServiceViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrSortedService.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewMale.dequeueReusableCell(withIdentifier: "MyServicesTvCell") as! MyServicesTvCell
        
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
    
        if self.arrSortedService[indexPath.row].durationInMinutes > 0 {
            cell.lbeTime.text = String(format: "%d mins", self.arrSortedService[indexPath.row].durationInMinutes )
        }
        else{
            cell.lbeTime.text = ""
        }
        
        cell.lbeDes.text = arrSortedService[indexPath.row].serviceDescription
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightSizeTitle = arrSortedService[indexPath.row].serviceName.heightForView(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 161)

        let heightSizeLine = arrSortedService[indexPath.row].serviceDescription.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 161)

        if heightSizeLine > 3 {
            return heightSizeTitle + 113
        }
        
        
        return 160
        
        

        
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
}
class MyServicesTvCell: UITableViewCell {
    
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeTime: UILabel!
    @IBOutlet weak var lbeDes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
