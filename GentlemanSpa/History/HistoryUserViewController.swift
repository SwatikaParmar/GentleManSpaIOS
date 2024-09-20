//
//  HistoryUserViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/07/24.
//

import UIKit

class HistoryUserViewController: UIViewController {
    @IBOutlet weak var lbeUPCOMING: UILabel!
    @IBOutlet weak var lbeCONFIRMED: UILabel!
    @IBOutlet weak var lbePAST: UILabel!
    @IBOutlet weak var tableUp: UITableView!
    var pageName = "Upcoming"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbeUPCOMING.textColor = AppColor.BlackColor
        lbePAST.textColor = AppColor.BlackColor
        lbeCONFIRMED.textColor = AppColor.BlackColor
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
    }
    
    @IBAction func btn_Up(_ sender: Any) {
      
        lbeUPCOMING.backgroundColor = AppColor.BrownColor
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        lbeUPCOMING.clipsToBounds = true
        lbeUPCOMING.layer.masksToBounds = true
        lbeCONFIRMED.clipsToBounds = true
        lbeCONFIRMED.layer.masksToBounds = true
        lbePAST.clipsToBounds = true
        lbePAST.layer.masksToBounds = true
        pageName = "Upcoming"
        self.tableUp.reloadData()
    }
    
    @IBAction func btn_Co(_ sender: Any) {
        
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = AppColor.BrownColor
        lbePAST.backgroundColor = UIColor.clear
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Confirmed"
        self.tableUp.reloadData()
    }
    
    @IBAction func btn_Past(_ sender: Any) {
        lbeUPCOMING.backgroundColor = UIColor.clear
        lbeCONFIRMED.backgroundColor = UIColor.clear
        lbePAST.backgroundColor = AppColor.BrownColor
        
        lbeUPCOMING.layer.cornerRadius = 17
        lbeCONFIRMED.layer.cornerRadius = 17
        lbePAST.layer.cornerRadius = 17
        pageName = "Past"
        self.tableUp.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
  

extension HistoryUserViewController: UITableViewDataSource,UITableViewDelegate {
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1

        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return 11

        }
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if  pageName == "Upcoming" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "UpcomingUTvCell") as! UpcomingUTvCell
                return cell
            }
            else if pageName == "Confirmed" {
                let cell = tableUp.dequeueReusableCell(withIdentifier: "ConfirmedUTvCell") as! ConfirmedUTvCell
                return cell
            }
            else{
                let cell = tableUp.dequeueReusableCell(withIdentifier: "PastUTvCell") as! PastUTvCell
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
    
    
    
    

class UpcomingUTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class ConfirmedUTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class PastUTvCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
