//
//  RequestsManagementViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 29/10/24.
//

import UIKit
import UIKit
import CocoaTextField
import DropDown
import IQKeyboardManagerSwift
class RequestsManagementViewController: UIViewController {

    let dropGender = DropDown()
    @IBOutlet weak var txt_Type : CocoaTextField!

    @IBOutlet weak var txt_View : IQTextView!
    @IBOutlet weak var btn_Type : UIButton!

    var typeStr = ""
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

        setupDropDowns()
        
        txt_View.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0)
    
        applyStyle(to: txt_Type)
        txt_Type.placeholder = "Type"
    }
    
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view .endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupDropDowns() {
        
        let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat(16)) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor =  UIColor.white
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont =  actionTitleFont
        setupGenderDropDown()
    }
    
    

    
    func setupGenderDropDown() {
        dropGender.anchorView = btn_Type
        dropGender.bottomOffset = CGPoint(x: 5, y: btn_Type.bounds.height - 10)
        dropGender.direction = .bottom

        dropGender.dataSource = [
            "Shift Change Request",
            "Workplace Complaint",
            "Uniform Replacement Request",
            "Training Session Request",
            "Equipment Request",

            ]
        
        dropGender.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                self!.typeStr = "ShiftChangeRequest"
            }
            else if (index == 1){
                 self!.typeStr = "WorkplaceComplaint"
            }
            else if (index == 2){
                self!.typeStr = "UniformReplacementRequest"
            }
            else if (index == 3){
                self!.typeStr = "TrainingSessionRequest"
            }
            else if (index == 4){
                self!.typeStr = "EquipmentRequest"
            }
           
            self!.txt_Type.text = item
        }
    }
    
    
    
    @IBAction func Back(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true)
    }
    
    @IBAction func History(_ sender: Any) {
        let controller:RequestListViewController =  UIStoryboard(storyboard: .Professional).initVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func Request(_ sender: Any) {
        
        
        self.view .endEditing(true)
        
        let trimmedEmailName = txt_Type.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = txt_View.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
                      
        if (trimmedEmailName?.isEmpty)!{
            MessageAlert(title:"",message: "Please enter request type")
            return
        }
        if (trimmedPassword?.isEmpty)!{
            MessageAlert(title:"",message: "Please enter description of the request")
            return
        }
        
    
       
        var param = [String : AnyObject]()
        param["requestId"] = 0 as AnyObject
        param["professionalDetailId"] = professionalDetailId() as AnyObject
        param["requestType"] = self.typeStr  as AnyObject
        param["description"] = self.txt_View.text  as AnyObject

        self.SendRequests(Model: param, index:0)
        
    }
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
        dropGender.show()
    }
    
    func SendRequests(Model: [String : AnyObject], index:Int){
        AddUpdateProfessionalRequests.shared.AddUpdateProfessionalAPI(requestParams: Model) { (user,message,isStatus) in
            if isStatus {
                NotificationAlert().NotificationAlert(titles: message ?? "Request Send Successfully")
                self.txt_View.text = ""
                self.txt_Type.text = ""
            }
        }
    }

}
class AddUpdateProfessionalRequests: NSObject {

    static let shared = AddUpdateProfessionalRequests()
    
    func AddUpdateProfessionalAPI(requestParams : [String:Any], completion: @escaping (_ objectData: LoginObject?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("Base".AddProfessionalRequests)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = GlobalConstants.serverError
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(nil,messageString,true)

                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }else{
                             NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                             completion(nil,"",false)
                         }
                     }else{
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                            completion(nil,"",false)
                    }
                }
            }
        }


