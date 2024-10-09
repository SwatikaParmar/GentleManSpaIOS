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
