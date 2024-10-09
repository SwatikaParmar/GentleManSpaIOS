//
//  UserNotificationViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 20/09/24.
//

import UIKit

class UserNotificationViewController: UIViewController {

    @IBOutlet weak var tableViewNotification : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

}
extension UserNotificationViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 3

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewNotification.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
}
    
    
    

class NotificationCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
