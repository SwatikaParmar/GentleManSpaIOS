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

    @IBOutlet weak var txt_Name : CocoaTextField!
    @IBOutlet weak var txt_View : IQTextView!
    @IBOutlet weak var btn_Type : UIButton!

    var typeStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDropDowns()
        
        txt_View.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0)
        applyStyle(to: txt_Name)
        txt_Name.placeholder = "Title"
        
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
            "Maintenance",
            "Business",
            "Personal"
            ]
        
        dropGender.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                self!.typeStr = "Maintenance"
            }
            else if (index == 1){
                 self!.typeStr = "Business"
            }
            else{
                self!.typeStr = "Personal"
            }
            self!.txt_Type.text = item
        }
    }
    
    
    
    @IBAction func Back(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true)
    }
    
    @IBAction func Request(_ sender: Any) {
       
    }
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
        dropGender.show()
    }

}
