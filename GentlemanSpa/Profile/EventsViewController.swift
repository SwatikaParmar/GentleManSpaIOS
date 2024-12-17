//
//  EventsViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 29/10/24.
//

import UIKit
import MapKit

class EventsViewController: UIViewController {

    @IBOutlet weak var tableViewEvents: UITableView!
    var intIndex : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Close(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }


}
extension EventsViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEvents.dequeueReusableCell(withIdentifier: "EventsTvCell") as! EventsTvCell
        cell.btnLocation.tag = indexPath.row
        cell.btnLocation.addTarget(self, action: #selector(showLocationOn(sender:)), for: .touchUpInside)
        
        cell.btnBooking.tag = indexPath.row
        cell.btnBooking.addTarget(self, action: #selector(bookingEvent(sender:)), for: .touchUpInside)
        
        if intIndex == indexPath.row {
            cell.viewRegistration.backgroundColor = AppColor.AppThemeColor
            cell.viewRegistration.layer.borderColor = UIColor.white.cgColor
            cell.viewRegistration.layer.borderWidth = 1
            cell.lbeRegistration.textColor = AppColor.AppTextColor
            cell.lbeRegistration.text = "Registered"
        }
        else{
            cell.viewRegistration.backgroundColor = UIColor.clear
            cell.viewRegistration.layer.borderColor = UIColor.darkGray.cgColor
            cell.viewRegistration.layer.borderWidth = 1

            cell.lbeRegistration.textColor = UIColor.darkGray
            cell.lbeRegistration.text = "Register"

        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:- Add Button Tap
    @objc func showLocationOn(sender:UIButton){
        
        openAppleMap()
    }
    
    func openAppleMap() {
        
         let  tlatitude = Double(19.185720222330172)
         let  tlongitude = Double(72.95156730489465)
         let center = CLLocationCoordinate2D(latitude:tlatitude, longitude:tlongitude)
         openMapsAppWithDirections(to: center, destinationName: "SWY THAI SPA")
    
}

    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name
      mapItem.openInMaps(launchOptions: options)
    }

    @objc func bookingEvent(sender:UIButton){
        
        if intIndex == sender.tag {
            return
        }
        let alertController = UIAlertController(title: "Success!", message: "You have successfully registered for the event.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.intIndex = sender.tag
            self.tableViewEvents.reloadData()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
    
  

class EventsTvCell: UITableViewCell {
    
    @IBOutlet weak var viewRegistration: UIView!
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeRegistration: UILabel!
    @IBOutlet weak var lbeCount: UILabel!
    
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
