//
//  AlertViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 09/10/24.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       
    }
    
    @IBAction func goPreessed(_ sender: Any){
        
        RootControllerManager().SetRootViewController()
    }
}


class AddAlertController: UIViewController {

    @IBOutlet weak var addTextLbe : UILabel!

    var addtextString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addTextLbe .text = addtextString
    }
    
    @IBAction func goPreessed(_ sender: Any){
        dismiss(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GoToLast"), object: nil)
    }
}

class OrderPlaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func goPreessed(_ sender: Any){
        RootControllerManager().SetRootViewController()
    }
}

class ServiceBookingAlertController: UIViewController {

    @IBOutlet weak var addTextLbe : UILabel!
    @IBOutlet weak var lbeTitle : UILabel!

    @IBOutlet weak var btnGoToCart : UIButton!
    @IBOutlet weak var btnGoToCartConst: NSLayoutConstraint!

    var addTextString = ""
    var titleTextString = ""
    var isGoToCart = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addTextLbe .text = addTextString
        lbeTitle.text = titleTextString
        if isGoToCart {
            btnGoToCart.isHidden = true
            btnGoToCartConst.constant = 0
        }
    }
    
    @IBAction func goPreessed(_ sender: Any){
        dismiss(animated: false)
        
        let classDataDict:[String:String] = ["class": "Back"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go_To_Last_Class"), object: nil, userInfo: classDataDict)


    }
    
    @IBAction func goToCart(_ sender: Any){
        dismiss(animated: false)
        let classDataDict:[String:String] = ["class": "Home"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go_To_Last_Class"), object: nil, userInfo: classDataDict)

    }
}
