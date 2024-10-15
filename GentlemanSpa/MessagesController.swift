//
//  MessagesController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 10/10/24.
//

import UIKit

class MessagesController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var noUserView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noUserView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        cell.imgView.layer.masksToBounds = true
        cell.imgView.layer.cornerRadius = 35
        cell.imgView.layer.borderWidth = 0.5
        cell.imgView.layer.backgroundColor = UIColor.darkGray.cgColor
        cell.lbeOnline.layer.cornerRadius = 8
        cell.lbeOnline.clipsToBounds = true
        
        if indexPath.row == 0{
            cell.lbeOnline.isHidden = false
        }
        else{
            cell.lbeOnline.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            if 0 > indexPath.row {

            let conversationId = 0
            let alertController = UIAlertController(title: "", message: "Are you sure you want to delete all chat with this user?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
                UIAlertAction in

            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            }
    
        }
    }
}
    
class MessagesCell: UITableViewCell {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeLastMessage : UILabel!
    @IBOutlet weak var lbeTime : UILabel!
    @IBOutlet weak var lbeOnline : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


