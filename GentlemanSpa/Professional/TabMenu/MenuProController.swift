//
//  MenuProController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 06/08/24.
//

import UIKit

class MenuProController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
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
       
        
        titleArray = ["Home","My Service","Add Product","Request","Refer","Log Out"]
        imagesArray = ["homeTab","servicePro","newProduct","request_ic","ReferPro","logoutic"]
        
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
        
        let st : String = UserDefaults.standard.string(forKey: Constants.stateName) ?? "Bahrain"
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
          let cell = tableView.dequeueReusableCell(withIdentifier: "ProSideMenuCell") as! ProSideMenuCell
          
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
                
                let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "TabBarProVc")
                let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.isNavigationBarHidden = true
                    sideMenuController?.rootViewController = navigationController
                
            }
          else if indexPath.row == 1{
                 
                 let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
                 let controller = storyBoard.instantiateViewController(withIdentifier: "MyServiceViewController")
                 let navigationController = UINavigationController(rootViewController: controller)
                     navigationController.isNavigationBarHidden = true
                     sideMenuController?.rootViewController = navigationController
         }
            else if indexPath.row == 2{
                   
                   let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
                   let controller = storyBoard.instantiateViewController(withIdentifier: "ProProductListVc")
                   let navigationController = UINavigationController(rootViewController: controller)
                       navigationController.isNavigationBarHidden = true
                       sideMenuController?.rootViewController = navigationController
           }
            else if indexPath.row == 3{
                   
                   let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
                   let controller = storyBoard.instantiateViewController(withIdentifier: "RequestsManagementViewController")
                   let navigationController = UINavigationController(rootViewController: controller)
                       navigationController.isNavigationBarHidden = true
                       sideMenuController?.rootViewController = navigationController
           }
            else if indexPath.row == 4 {
                shareData()
            }
                
            }
        }
    
    func shareData(){
        // Setting description
            let firstActivityItem = ""

            // Setting url
            let secondActivityItem : NSURL = NSURL(string: "http://your-url.com/")!
            
            // If you want to use an image
        let image : UIImage = UIImage(named: "login_ic") ?? UIImage()
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
           // activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
            
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Logout Message Action Sheet
    func ActionSheet()
    {
        let alert = UIAlertController(title: nil, message:"Are you sure you want to logout?", preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: .default, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: UIAlertAction.Style.destructive, handler: { action in
            self.callLogOutApi()
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    //MARK: - Call Logout API
    func callLogOutApi(){
        
        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.userId)
        UserDefaults.standard.removeObject(forKey: Constants.userImg)
        UserDefaults.standard.removeObject(forKey: Constants.firstName)
        UserDefaults.standard.removeObject(forKey: Constants.lastName)
        UserDefaults.standard.removeObject(forKey: Constants.email)
        UserDefaults.standard.removeObject(forKey: Constants.phone)
        UserDefaults.standard.set(false, forKey: Constants.login)
        UserDefaults.standard.synchronize()
        
        RootControllerManager().SetRootViewController()

    }
}


class ProSideMenuCell: UITableViewCell {
       @IBOutlet weak var imgVw: UIImageView! = nil
       @IBOutlet weak var lbeName: UILabel! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}






