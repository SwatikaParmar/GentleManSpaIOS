//
//  MenuUserController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit
import LGSideMenuController
class MenuUserController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeSp: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
                        
    var titleArray = [String]()
    var imagesArray = [String]()

    @IBOutlet weak var viewFooter: UIView!
    
    @IBOutlet weak var versionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLbl.text = Utility.shared.appVersion() + "(\(Utility.shared.appBuildVersion()))"
        titleArray = ["Home","My Orders","Privacy Policy","About Us","Log Out"]
        imagesArray = ["homeTab","Blogs","aboutUsic","privacyic","logoutic"]
        tableview.contentInsetAdjustmentBehavior = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SideMenuUpdate), name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let uName = UserDefaults.standard.string(forKey: Constants.firstName) ?? "Guest User"
        self.lbeName.text = uName
         
        let st : String = UserDefaults.standard.string(forKey: Constants.stateName) ?? "USA"
        self.lbeSp.text = ""
        
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
        self.tableview.reloadData()
        
    }
    
    
    @objc func SideMenuUpdate(_ notification: NSNotification) {
        
       let uName = UserDefaults.standard.string(forKey: Constants.firstName) ?? "Guest User"
       self.lbeName.text = uName
        
        let st : String = UserDefaults.standard.string(forKey: Constants.stateName) ?? ""
        self.lbeSp.text = ""
        
        
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
        

        self.tableview.reloadData()
    }
    
    //MARK:-   TableView Function
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

          return titleArray.count
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
          
          cell.lbeName.text = titleArray[indexPath.row]
          cell.imgVw.image = UIImage (named: imagesArray[indexPath.row])
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 55
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           tableview.deselectRow(at: indexPath, animated: false)
           sideMenuController?.hideLeftView(animated: true)
    
        if titleArray.count == indexPath.row + 1 {
            ActionSheet()
        }
        else{
            if indexPath.row == 0 {
                let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "TabBarUserVc")
                let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    sideMenuController?.rootViewController = navigationController
            }
            else if indexPath.row == 1{
                let storyBoard = UIStoryboard.init(name: "Cart", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "MyOrderVc")
                let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    sideMenuController?.rootViewController = navigationController
            }
            else if indexPath.row == 2{
                let storyBoard = UIStoryboard.init(name: "Services", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "PrivacyViewController")
                let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    sideMenuController?.rootViewController = navigationController
            }
            else if indexPath.row == 3{
                let storyBoard = UIStoryboard.init(name: "Services", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController")
                let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    sideMenuController?.rootViewController = navigationController
            }
            else{
                    NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":String(indexPath.row)])

                }
            }
        }
    
    //MARK: - Logout Message Action Sheet
    func ActionSheet()
    {
        let alert = UIAlertController(title: nil, message:"Are you sure you want to logout?", preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: .default, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: UIAlertAction.Style.destructive, handler: { action in
            
            NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":"Logout"])
         
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
  
}


class SideMenuCell: UITableViewCell {
       @IBOutlet weak var imgVw: UIImageView! = nil
       @IBOutlet weak var lbeName: UILabel! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}





