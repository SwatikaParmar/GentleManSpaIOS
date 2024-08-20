//
//  FindPViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 31/07/24.
//

import UIKit

class FindPViewController: UIViewController {
    @IBOutlet weak var tableViewDoctor: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
   
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}



extension FindPViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 5

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableViewDoctor.dequeueReusableCell(withIdentifier: "DoctorTvCell") as! DoctorTvCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130 + 22

        
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller:BookingDoctorViewController =  UIStoryboard(storyboard: .User).initVC()
            self.navigationController?.pushViewController(controller, animated: true)
        }
}
    
    
    
    

class DoctorTvCell: UITableViewCell {
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
