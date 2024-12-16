//
//  FindPViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 31/07/24.
//

import UIKit

class FindPViewController: UIViewController {
    @IBOutlet weak var tableViewDoctor: UITableView!
    var arrGetProfessionalList = [GetProfessionalObject]()
    var serviceId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        GetProfessionalListAPI(true, true, 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectProPreessed(_ sender: Any){
        let controller:SelectProfessionalVc =  UIStoryboard(storyboard: .Services).initVC()
    
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK: - GetProfessionalList API
    func GetProfessionalListAPI(_ isLoader:Bool, _ isAppend: Bool, _ type:Int){
        
        let params = [ "spaDetailId": 21,
                       "serviceId":serviceId
        ] as [String : Any]
        
        GetProfessionalListRequest.shared.GetProfessionalListAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrGetProfessionalList = arrayData ?? self.arrGetProfessionalList
                    if self.arrGetProfessionalList.count > 0 {
                        self.tableViewDoctor.reloadData()
                    }
                }
                else{
                    self.arrGetProfessionalList.removeAll()
                    self.tableViewDoctor.reloadData()
                }
            }
            else{
                self.arrGetProfessionalList.removeAll()
                
                self.tableViewDoctor.reloadData()
            }
        }
    }
}



extension FindPViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrGetProfessionalList.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewDoctor.dequeueReusableCell(withIdentifier: "DoctorTvCell") as! DoctorTvCell
        
           
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
            
            self.navigationController?.pushViewController(controller, animated: true)

        }
}
    
    
    
    

class DoctorTvCell: UITableViewCell {
    
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
