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
    var arrAllEvents = [EventData]()

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

        MyEventsAPI(true)
    }
    
    func MyEventsAPI(_ isLoader:Bool){
        arrAllEvents.removeAll()
        let params = [ "Type": 0
        ] as [String : Any]
        GetEventsListRequest.shared.GetEventRequest(requestParams:params, isLoader) { [self] (arrayData,message,isStatus) in
            if isStatus {
                arrAllEvents = arrayData ?? arrAllEvents
                self.tableViewEvents.reloadData()
            }
        }
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
        
        
        return arrAllEvents.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewEvents.dequeueReusableCell(withIdentifier: "EventsTvCell") as! EventsTvCell
        cell.btnLocation.tag = indexPath.row
        cell.btnLocation.addTarget(self, action: #selector(showLocationOn(sender:)), for: .touchUpInside)
        
        cell.btnBooking.tag = indexPath.row
        cell.btnBooking.addTarget(self, action: #selector(bookingEvent(sender:)), for: .touchUpInside)
        
        if arrAllEvents[indexPath.row].isRegistered {
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
        
        cell.lbeName.text = arrAllEvents[indexPath.row].title
        cell.lbeAddress.text = arrAllEvents[indexPath.row].location
        cell.lbeDate.text = "".formatDateStringMMM(arrAllEvents[indexPath.row].startDate)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightSizeLine   = arrAllEvents[indexPath.row].title.heightForView(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: 16.0) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 157)
        
        print(arrAllEvents[indexPath.row].title)
        print(heightSizeLine)

        let heightSizeAddress   = arrAllEvents[indexPath.row].location.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: 12.0) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 155)
        
        if  heightSizeLine  +  heightSizeAddress + 102 + 20 > 150 {
            return heightSizeLine + 102 + heightSizeAddress
        }
        return 102 + heightSizeAddress
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let currentDate = dateFormatter.string(from: Date())
        
        if arrAllEvents[sender.tag].isRegistered {
            let alertController = UIAlertController(title: "Cancel Event?", message: "Are you sure you want to cancel your registration for this event?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                var param = [String : AnyObject]()
                param["userId"] = userId() as AnyObject
                param["eventId"] = self.arrAllEvents[sender.tag].eventId as AnyObject
                param["isRegistered"] = false as AnyObject
                param["registeredAt"] = currentDate as AnyObject
                
                self.addEvent(Model: param, index:1)
            }
            let cancel = UIAlertAction(title: "No", style: UIAlertAction.Style.destructive) {
                UIAlertAction in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancel)

            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
           
            
            var param = [String : AnyObject]()
            param["userId"] = userId() as AnyObject
            param["eventId"] = arrAllEvents[sender.tag].eventId as AnyObject
            param["isRegistered"] = true as AnyObject
            param["registeredAt"] = currentDate as AnyObject
            
            self.addEvent(Model: param, index:0)
        }
    }
    
    func addEvent(Model: [String : AnyObject], index:Int){
        AddOrUpdateEventRegistrationRequest.shared.AddOrUpdateEventRegistrationAPI(requestParams: Model) { (user,message,isStatus) in
         
                if isStatus {
                    if index == 1 {
                        let alertController = UIAlertController(title: "Success!", message: "Event successfully cancelled.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.MyEventsAPI(false)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        let alertController = UIAlertController(title: "Success!", message: "You have successfully registered for the event.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.MyEventsAPI(false)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            
        }
    }
}
    
  

class EventsTvCell: UITableViewCell {
    
    @IBOutlet weak var viewRegistration: UIView!
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var lbeAddress: UILabel!
    @IBOutlet weak var lbeRegistration: UILabel!
    
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

