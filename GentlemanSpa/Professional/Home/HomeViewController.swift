//
//  HomeViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/08/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableUp: UITableView!
    var pageName = "Upcoming"
    let refreshControlUp = UIRefreshControl()
    
    
    @IBOutlet weak var lbeTitlePending: UILabel!
    @IBOutlet weak var lbeLinePending: UIView!
    
    @IBOutlet weak var lbeTitleConfirmed: UILabel!
    @IBOutlet weak var lbeLineConfirmed: UIView!

    @IBOutlet weak var lbeTitlePast: UILabel!
    @IBOutlet weak var lbeLinePast: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControlUp.addTarget(self, action:  #selector(RefreshScreenUp), for: .valueChanged)
        refreshControlUp.tintColor = UIColor.white
        tableUp.refreshControl = refreshControlUp
        
        lbeTitlePending.textColor = UIColor.white
        lbeLinePending.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor = UIColor.clear

        pageName = "Upcoming"
        self.tableUp.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
        var stringURL = ""
        let urli : String = UserDefaults.standard.string(forKey: Constants.userImg) ?? ""

        if urli.contains("http:") {
            stringURL = urli
        }
        else{
            stringURL =  GlobalConstants.BASE_IMAGE_URL + urli
        }
        
        let urlString = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
             imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "placeholder_Male"),
                               options: .refreshCached,
                               completed: nil)
    }
    
    @objc func RefreshScreenUp() {
      
                refreshControlUp.endRefreshing()
            
        }
    
    
    @IBAction func MyProfile(_ sender: Any) {
       
       
       
    }
    
    @IBAction func sideMenu(_ sender: Any) {
        
        var stringURL = ""
        let urli : String = UserDefaults.standard.string(forKey: Constants.userImg) ?? ""

        if urli.contains("http:") {
            stringURL = urli
        }
        else{
            stringURL =  GlobalConstants.BASE_IMAGE_URL + urli
        }
        
        let urlString = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
             imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "placeholder_Male"),
                               options: .refreshCached,
                               completed: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }

    @IBAction func PendingAction(_ sender: Any) {
        
      
 
        lbeTitlePending.textColor = UIColor.white
        lbeLinePending.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor = UIColor.clear

        pageName = "Upcoming"
        self.tableUp.reloadData()
    }
 
    @IBAction func ConfirmedAction(_ sender: Any) {
        
        var stringURL = ""
        let urli : String = UserDefaults.standard.string(forKey: Constants.userImg) ?? ""

        if urli.contains("http:") {
            stringURL = urli
        }
        else{
            stringURL =  GlobalConstants.BASE_IMAGE_URL + urli
        }
        
        let urlString = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
             imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "placeholder_Male"),
                               options: .refreshCached,
                               completed: nil)
        
        lbeTitleConfirmed.textColor = UIColor.white
        lbeLineConfirmed.backgroundColor = UIColor.white
        
        lbeTitlePast.textColor = AppColor.AppThemeColorPro
        lbeLinePast.backgroundColor = UIColor.clear
        
        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor =  UIColor.clear
        
   
        pageName = "Confirmed"
        self.tableUp.reloadData()

    }
    @IBAction func PastAction(_ sender: Any) {
        
        
      
        
        lbeTitlePast.textColor = UIColor.white
        lbeLinePast.backgroundColor = UIColor.white

        lbeTitleConfirmed.textColor = AppColor.AppThemeColorPro
        lbeLineConfirmed.backgroundColor =  UIColor.clear

        lbeTitlePending.textColor = AppColor.AppThemeColorPro
        lbeLinePending.backgroundColor = UIColor.clear
        
        
        pageName = "Past"
        self.tableUp.reloadData()

    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1

        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return 11

        }
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if  pageName == "Upcoming" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "UpcomingTvCell") as! UpcomingTvCell
                return cell
            }
            else if pageName == "Confirmed" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "ConfirmedTvCell") as! ConfirmedTvCell
                return cell
            }
            else{
                let cell = tableUp.dequeueReusableCell(withIdentifier: "PastTvCell") as! PastTvCell
                return cell
            }

           
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if  pageName == "Upcoming" {
                return 250

            }
            else if pageName == "Confirmed" {
                return 200
            }
            
            return 200

        
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
}
    
    
    
    

class UpcomingTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class ConfirmedTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class PastTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
