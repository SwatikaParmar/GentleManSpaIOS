//
//  SpaLocationVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 30/07/24.
//

import UIKit

class SpaLocationVc: UIViewController {
    
    var arrSortedLocation = [LocationListingModel]()
    
    @IBOutlet weak var tblCate : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAPI()
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    //MARK: - location API
    func locationAPI(){
        LocationListRequest.shared.locationListAPI(requestParams:[:], true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedLocation = arrayData ?? self.arrSortedLocation
                    self.tblCate.reloadData()
                    
                }
            }
            else{
                
            }
        }
    }
}
extension SpaLocationVc: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
   
        return arrSortedLocation.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell") as! LocationTableCell
        
        cell.lbeName.text = arrSortedLocation[indexPath.row].name
        
        var adStr = ""
        adStr = String(format: "%@, %@, %@, %@, %@, %@", arrSortedLocation[indexPath.row].address1, arrSortedLocation[indexPath.row].landmark, arrSortedLocation[indexPath.row].city, arrSortedLocation[indexPath.row].state, arrSortedLocation[indexPath.row].country, arrSortedLocation[indexPath.row].pincode)
        
        cell.lbeAddress.text = adStr
        cell.lbePhone.text = String(arrSortedLocation[indexPath.row].phoneNumber1)
        cell.lbePhoneTwo.text = String(arrSortedLocation[indexPath.row].phoneNumber2)

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeFont = CGFloat()
           
        if arrSortedLocation.count > indexPath.row {
            
            sizeFont  = arrSortedLocation[indexPath.row].name.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(18)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.frame.size.width - 41)
            
            var adStr = ""
            adStr = String(format: "%@, %@, %@, %@, %@, %d", arrSortedLocation[indexPath.row].address1, arrSortedLocation[indexPath.row].landmark, arrSortedLocation[indexPath.row].city, arrSortedLocation[indexPath.row].state, arrSortedLocation[indexPath.row].country, arrSortedLocation[indexPath.row].pincode)
            
            sizeFont  = adStr.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.frame.size.width - 60) + sizeFont
            
        }
        return sizeFont * 30 + 100
           
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
}
class LocationTableCell: UITableViewCell {

    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeAddress : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var imgViewTwo : UIImageView!

    @IBOutlet weak var lbePhone : UILabel!
    @IBOutlet weak var lbePhoneTwo : UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class LocationListRequest: NSObject {

    static let shared = LocationListRequest()
    
    func locationListAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: [LocationListingModel]?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = "BaseURL".GetSpas
        

            print("URL---->> ",apiURL)
            print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                                 var homeListObject : [LocationListingModel] = []
                                    if let dataList = data?["data"] as? NSArray{
                                        for list in dataList{
                                            let dict : LocationListingModel = LocationListingModel.init(fromDictionary: list as! [String : Any])
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



class LocationListingModel: NSObject {
    
    var address1 = ""
    var address2 = ""
    var pincode = ""
    var spaDetailId = 0
    var city = ""
    var country = ""
    var email = ""
    var landmark = ""
    var name = ""
    var phoneNumber1 = ""
    var phoneNumber2 = ""
    var state = ""

    

    
    init(fromDictionary dictionary: [String:Any]){
        address1 = dictionary["address1"] as? String ?? ""
        address2 = dictionary["address2"] as? String ?? ""
        pincode = dictionary["pincode"] as? String ?? ""
        spaDetailId = dictionary["spaDetailId"] as? Int ?? 0

        city = dictionary["city"] as? String ?? ""
        country = dictionary["country"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        landmark = dictionary["landmark"] as? String ?? ""
        name = dictionary["address1"] as? String ?? ""
        phoneNumber1 = dictionary["phoneNumber1"] as? String ?? ""
        phoneNumber2 = dictionary["phoneNumber2"] as? String ?? ""
        state = dictionary["state"] as? String ?? ""

    }
}
