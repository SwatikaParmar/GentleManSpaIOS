//
//  ProfessionalDetailViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 22/10/24.
//

import UIKit

class ProfessionalDetailViewController: UIViewController {

    @IBOutlet weak var lbeSpe : UILabel!
    @IBOutlet weak var lbeName : UILabel!

    @IBOutlet weak var imgUserProfile : UIImageView!
    @IBOutlet weak var specialityConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProfileAPI()
    }
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - get Profile API
    func getProfileAPI(){
    
        GetProfileProRequest.shared.proProfileAPI(requestParams:[:], true) { (user,message,isStatus) in
                if isStatus {
                    if user != nil{
                        let urlString = user?.profilePic.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        self.imgUserProfile?.sd_setImage(with: URL.init(string:(urlString)),
                                               placeholderImage: UIImage(named: "placeholder_Male"),
                                               options: .refreshCached,
                                               completed: nil)
                        
                        self.lbeSpe.text = ""
                        if let array = user?.objectPro?.speciality as? NSMutableArray {
                            
                            for i in 0 ..< array.count {
                                if i == 0 {
                                    self.lbeSpe.text = String(format:"%@",array[i] as! CVarArg)
                                }
                                else{
                                    self.lbeSpe.text = String(format:"%@, %@", self.lbeSpe.text ?? "", array[i] as! CVarArg)

                                }
                                self.lbeSpe.textColor = UIColor.black
                            }
                        }
                        
                        let heightSizeLine = self.lbeSpe.text?.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 100)
                        self.specialityConst.constant = CGFloat((heightSizeLine ?? 32) + 6)
                      
                }
            }
        }
    }
}
