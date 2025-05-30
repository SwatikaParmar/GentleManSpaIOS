//
//  ProfileUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class ProfileUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var titleArray = [String]()
    var imagesArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        titleArray = ["My Profile","Messages","Event","Refer"]
        imagesArray = ["profileEdit","M","E","R"]
        tableview.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

        let uName = UserDefaults.standard.string(forKey: Constants.firstName)
        let lastName = UserDefaults.standard.string(forKey: Constants.lastName)
        
        self.lbeName.text = String(format: "%@ %@", uName ?? "",lastName ?? "")
        self.lbeEmail.text = UserDefaults.standard.string(forKey: Constants.email)
        
        var stringURL = ""
        let imgUser = UserDefaults.standard.string(forKey: Constants.userImg) ?? ""
        if imgUser.contains("http:") {
            stringURL = imgUser
        }
        else{
            stringURL =  GlobalConstants.BASE_IMAGE_URL + imgUser
        }
        
        let urlString = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                             placeholderImage: UIImage(named: "placeholder_Male"),
                             options: .refreshCached,
                             completed: nil)
    }
    
    @IBAction func notification(_ sender: Any) {
        
          let controller:UpdateProfileUserViewController =  UIStoryboard(storyboard: .User).initVC()
          self.navigationController?.pushViewController(controller, animated: true)
    }
    
   
    
    //MARK:-   TableView Function
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return titleArray.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
          cell.lbeName.text = titleArray[indexPath.row]
          cell.imgVw.image = UIImage (named: imagesArray[indexPath.row])
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 100
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            let controller:UpdateProfileUserViewController =  UIStoryboard(storyboard: .User).initVC()
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 1 {
            let controller:MessagesController =  UIStoryboard(storyboard: .Chat).initVC()
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 2 {
            let controller:EventsViewController =  UIStoryboard(storyboard: .Chat).initVC()
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
       
        if indexPath.row == 3 {
            shareData()
        }
        if indexPath.row == 4 {
            let controller:AboutUsViewController =  UIStoryboard(storyboard: .Services).initVC()
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    func shareData(){

            let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/us/app/gentleman-spa/id6695744508")!
            
            let image : UIImage = UIImage(named: "apps") ?? UIImage()
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [secondActivityItem, image], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
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
}


class ProfileCell: UITableViewCell {
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

