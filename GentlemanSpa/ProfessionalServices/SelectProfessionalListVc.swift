//
//  SelectProfessionalListVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 01/10/24.
//

import UIKit

class SelectProfessionalListVc: UIViewController {
    @IBOutlet weak var tableViewPro: UITableView!
    @IBOutlet weak var lbeServiceName: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!

    var arrGetProfessionalList = [GetProfessionalObject]()
    var spaServiceId = 0
    var serviceName = ""
    var isReschedule = false
    var isMyCart = false
    var searchQuery = ""

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
        searchTxtField.delegate = self
        lbeServiceName.text = serviceName
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        GetProfessionalListAPI(true, true)
    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectProPreessed(_ sender: Any){
       
        
    }
    
    //MARK: - GetProfessionalList API
    func GetProfessionalListAPI(_ isLoader:Bool, _ isAppend: Bool){
        
        let params = [ "spaDetailId": 21,
                       "spaServiceId":spaServiceId,
                       "searchQuery" : searchQuery
        ] as [String : Any]
        
        GetProfessionalListRequest.shared.GetProfessionalListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrGetProfessionalList = arrayData ?? self.arrGetProfessionalList
                    if self.arrGetProfessionalList.count > 0 {
                        self.tableViewPro.reloadData()
                    }
                }
                else{
                    self.arrGetProfessionalList.removeAll()
                    self.tableViewPro.reloadData()
                }
            }
            else{
                self.arrGetProfessionalList.removeAll()
                
                self.tableViewPro.reloadData()
            }
        }
    }
}



extension SelectProfessionalListVc: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrGetProfessionalList.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewPro.dequeueReusableCell(withIdentifier: "ProfessionalTvCell") as! ProfessionalTvCell
        
           
           let actionTitleFont = UIFont(name: FontName.Inter.SemiBold, size: CGFloat("".dynamicFontSize(16))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
           cell.nameLabel.font = actionTitleFont
           
           cell.nameLabel.text = (arrGetProfessionalList[indexPath.row].firstName ?? "") + " " + (arrGetProfessionalList[indexPath.row].lastName ?? "")
           
             
           if let imgUrl = arrGetProfessionalList[indexPath.row].profilepic,!imgUrl.isEmpty {
               
               let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
               let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
               cell.imageV?.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                   if (error != nil) {
                       cell.imageV.image = UIImage(named: "placeholder_Male")
                   } else {
                       cell.imageV.image = image
                      
                   }
               }
               
           } else {
                   cell.imageV.image = UIImage(named: "placeholder_Male")
           }
        
        for i in 0 ..< (arrGetProfessionalList[indexPath.row].object?.arrayData.count ?? 0) {
            if i == 0 {
                cell.nameSpe.text = String(format:"%@",arrGetProfessionalList[indexPath.row].object?.arrayData[i] as! CVarArg)
            }
            else{
                cell.nameSpe.text = String(format:"%@, %@", cell.nameSpe.text ?? "", arrGetProfessionalList[indexPath.row].object?.arrayData[i] as! CVarArg)

            }
        }
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130 + 22

        
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
            controller.name = (arrGetProfessionalList[indexPath.row].firstName ?? "") + " " + (arrGetProfessionalList[indexPath.row].lastName ?? "")
            if let imgUrl = arrGetProfessionalList[indexPath.row].profilepic,!imgUrl.isEmpty {
                
                let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                controller.imgUserStr = urlString
            }
            controller.arrayData  = arrGetProfessionalList[indexPath.row].object?.arrayData ?? NSArray()
            controller.professionalId  = arrGetProfessionalList[indexPath.row].object?.professionalDetailId ?? 0
            controller.spaServiceId = spaServiceId
            controller.isReschedule = self.isReschedule
            controller.isMyCart = self.isMyCart

            self.navigationController?.pushViewController(controller, animated: true)

        }
    
    
//    let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
//    controller.professionalId  = arrGetProfessionalList[indexPath.row].object?.professionalDetailId ?? 0
//    self.navigationController?.pushViewController(controller, animated: true)

    
}
    
//MARK: TextField Delegate
extension SelectProfessionalListVc : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text == "" && string == " "{
            return false
        }
        
        if string != "\n" {
            searchQuery = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        }
        
        if !searchQuery.isEmpty
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in

                GetProfessionalListAPI(false, true)


            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                searchQuery = ""
                GetProfessionalListAPI(false, true)
            }
        }
        return true
    }
}
    
    
    

class ProfessionalTvCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameSpe: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
