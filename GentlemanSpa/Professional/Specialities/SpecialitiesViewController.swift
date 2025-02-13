//
//  SpecialitiesViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 22/07/24.
//

import UIKit

class SpecialitiesViewController: UIViewController,  UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    var arrSortedCategory = [CategoryListingModel]()
    var arrSortedCategoryMore = [CategoryListingModel]()
    var selectArray = NSMutableArray()
    var selectName = NSMutableArray()

    @IBOutlet weak var tblCate : UITableView!

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()

        categoryAPI()

    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        if selectName.count > 0 {
            NotificationCenter.default.post(name: Notification.Name("Category_Push_Action"), object: nil, userInfo: ["name":selectName,
                                                                                                            "array": selectArray])
            dismiss(animated: true)
        }
        else{
            MessageAlert(title:"Alert",message: "Please select Specialities")
            return
        }
      

    }
    
    //MARK: - Category API
    func categoryAPI(){
        GetCategoryListRequest.shared.categoryListAPI(requestParams:[:], true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedCategory = arrayData ?? self.arrSortedCategory
                    if self.arrSortedCategory.count > 0 {
                        for i in 0 ..< self.arrSortedCategory.count {
                            if self.selectArray.contains(String(self.arrSortedCategory[i].specialityId)){
                                self.arrSortedCategory[i].isSelect = true
                                self.selectName.add(String(self.arrSortedCategory[i].categoryName ?? ""))
                            }
                        }
                        self.arrSortedCategoryMore =  self.arrSortedCategory
                        self.tblCate.reloadData()
                    }
                }
            }
            else{
               
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
   
        return arrSortedCategoryMore.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableCell") as! CountriesTableCell
        
        cell.lbeName.text = arrSortedCategoryMore[indexPath.row].categoryName
        
        if arrSortedCategoryMore[indexPath.row].isSelect {
            cell.imgView.image = UIImage(named: "checkic")
        }
        else{
            cell.imgView.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeFont = CGFloat()
           
        if arrSortedCategoryMore.count > indexPath.row {
            
            sizeFont  = arrSortedCategoryMore[indexPath.row].categoryName?.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.frame.size.width - 30) ?? 10
            
            
        }
        return sizeFont * 20 + 40
           
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)

        if self.selectArray.contains(String(self.arrSortedCategory[indexPath.row].specialityId)){
            selectArray.remove(String(self.arrSortedCategoryMore[indexPath.row].specialityId))
            self.selectName.remove(String(self.arrSortedCategoryMore[indexPath.row].categoryName ?? ""))
        }
        else{
            selectArray.add(String(self.arrSortedCategoryMore[indexPath.row].specialityId))
            self.selectName.add(String(self.arrSortedCategoryMore[indexPath.row].categoryName ?? ""))
        }
        if self.arrSortedCategoryMore.count > 0 {
            
            for i in 0 ..< self.arrSortedCategoryMore.count {
                
                if self.selectArray.contains(String(self.arrSortedCategoryMore[i].specialityId)){
                    self.arrSortedCategoryMore[i].isSelect = true
                }
                else{
                    self.arrSortedCategoryMore[i].isSelect = false
                }
            }
            
            self.tblCate.reloadData()
        }
    }
}
class CountriesTableCell: UITableViewCell {

    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeLine : UILabel!
    @IBOutlet weak var imgView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class GetCategoryListRequest: NSObject {

    static let shared = GetCategoryListRequest()
    
    func categoryListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [CategoryListingModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = "BaseURL".GetAllSpecialities
        

            print("URL---->> ",apiURL)
            print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError 
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 var homeListObject : [CategoryListingModel] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : CategoryListingModel = CategoryListingModel.init(fromDictionary: list as! [String : Any])
                                            homeListObject.append(dict)
                                        }
                                        completion(homeListObject,messageString,true)
                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }
                         else
                         {
                             completion(nil,"",false)
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,"",false)
                    }
                }
            }
        }



class CategoryListingModel: NSObject {
    
    var categoryName: String?
    var categoryImage: String?
    var specialityId = 0
    var isSelect = false
    
    init(fromDictionary dictionary: [String:Any]){
        categoryName = dictionary["speciality"] as? String ?? ""
        categoryImage = dictionary["categoryImage"] as? String ?? ""
        specialityId = dictionary["specialityId"] as? Int ?? 0
        isSelect = dictionary["isSelect"] as? Bool ?? false

        
    }
}
