//
//  MapsViewController.swift
//  SalonApp
//
//  Created by mac on 31/08/23.
//

import UIKit
import GoogleMaps
import CoreLocation
enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}
class MapsViewController: UIViewController{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableviewSearch: UITableView!
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var searchCancelBtn: UIButton!
    @IBOutlet weak var l_TConstraints: NSLayoutConstraint!
    @IBOutlet weak var t_TConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchView_HConst: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    
    var lines = ""
    var thoroughfare = ""
    var subLocality = ""
    var locality = ""
    var administrativeArea = ""
    var postalCode = ""
    var latitude = ""
    var longitude = ""
    var selectedPickUp = false
    var addressType = ""
    var apiUpdate = ""
    var apiUpdateID = 0
    var country = ""
    var city = ""
    var strLong = ""
    var titleString = ""
    var isCurrentlocation = false
    
    let markerPin: GMSMarker = GMSMarker()
    var strSearchText =  ""
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.activityType = .automotiveNavigation
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        _locationManager.distanceFilter = 10.0
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
        return _locationManager
    }()
    
    
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
        if Utility.shared.DivceTypeString() == "IPad" {
          
        }
     
        tableviewSearch.delegate = self
        tableviewSearch.dataSource = self
        textfieldAddress.font = UIFont(name:FontName.Inter.Regular, size:  "".dynamicFontSize(13))
        mapView.delegate = self
        locationManager.startUpdatingLocation()
       
        if isCurrentlocation {
    
            btnAddress.setTitle("Confirm Address", for: .normal)
        }else{
       
            btnAddress.setTitle("Enter Complete Address", for: .normal)
        }
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        hideResults()
        searchCancelBtn.isHidden = true
        
        if apiUpdate == "" {
            titleLabel.text = "Add Address"
        }
        else{
            titleLabel.text = "Update Address"
        }
        var searchPlace = ""
        searchPlace =  String(format: "Search in %@", titleString)
        textfieldAddress.delegate = self
        
        if titleString == "" {
            searchPlace = "Search for area, street name..."

        }
        textfieldAddress.attributedPlaceholder = NSAttributedString(
            string: searchPlace,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
    }
    
    func showResults(string:String){
        
        if self.strSearchText.isEmpty
        {
            self.autocompleteResults.removeAll()
            self.hideResults()
            self.tableviewSearch.reloadData()
            searchCancelBtn.isHidden = true
            return
        }
        
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    
                    if self.strSearchText.isEmpty
                    {
                        self.autocompleteResults.removeAll()
                        self.hideResults()
                        self.searchCancelBtn.isHidden = true
                    }
                    self.tableviewSearch.reloadData()
                }
            } else {
                print(response.error ?? "ERROR") }
        }
    }
    func hideResults(){
        searchView.isHidden = true
        autocompleteResults.removeAll()
        tableviewSearch.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
       // let manager = CLLocationManager()
        let locationManager = CLLocationManager()
            var locationAuthorizationStatus : CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                locationAuthorizationStatus =  locationManager.authorizationStatus
            } else {
                // Fallback on earlier versions
                locationAuthorizationStatus = CLLocationManager.authorizationStatus()
            }
        
        
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                
                switch(locationAuthorizationStatus) {
                case .restricted, .denied:
                    print("No access")
                    DispatchQueue.main.async {
                        
                        let accessAlert = UIAlertController(title: "Location Services Disabled", message: "You need to enable location services in settings.", preferredStyle: UIAlertController.Style.alert)
                        
                        accessAlert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { (action: UIAlertAction!) in UIApplication.shared.open(URL(string: "\(UIApplication.openSettingsURLString)")!)
                        }))
                        
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .compactMap({$0 as? UIWindowScene})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        
                        keyWindow?.rootViewController?.present(accessAlert, animated: true, completion: nil)
                    }
                    //check if services are allowed for this app
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access! We're good to go!")
                    //check if we need to ask for access
                case .notDetermined:
                    print("asking for access...")
                    
                @unknown default: break
                    
                }
            } else {
                DispatchQueue.main.async {
                    
                    let accessAlert = UIAlertController(title: "", message: "GPS access is restricted. In order to use Pay and Checking, Please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertController.Style.alert)
                    accessAlert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                        UIApplication.shared.open(URL(string: "\(UIApplication.openSettingsURLString)")!)
                        
                    }))
                    
                    let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                    
                    keyWindow?.rootViewController?.present(accessAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func Add(_ sender: Any) {
        if latitude == "" {
            NotificationAlert().NotificationAlert(titles:"Please select address on map.")
            return
        }
//        else if country != "India" {
//            NotificationAlert().NotificationAlert(titles:"Please select address in india.")
//            return
//        }
        
        if isCurrentlocation  {
            
             print(self.lines)
             print(self.subLocality)
             print(self.administrativeArea)
             print(self.country)
            
             
            
            NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["address": self.thoroughfare,
                                                                                                                 "search":"Yes",
                                                                                                                 "city" : locality])
            
            self.navigationController?.popViewController(animated: true)
        }else {
            let controller:EditAddressVc =  UIStoryboard(storyboard: .Address).initVC()
            controller.lines = lines
            controller.thoroughfare = thoroughfare
            controller.subLocality = subLocality
            controller.locality = locality
            controller.administrativeArea = administrativeArea
            controller.postalCode = postalCode
            controller.latitude = latitude
            controller.longitude = longitude
            controller.addressType = addressType
            controller.apiUpdate = apiUpdate
            controller.apiUpdateID = apiUpdateID
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SearchCancelTap(_ sender: UIButton) {
        searchView.isHidden = true
        textfieldAddress.text = ""
        searchCancelBtn.isHidden = true
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelView(_ sender: Any) {
       
    }
    
}
// MARK: - CLLocationManagerDelegate

extension MapsViewController: CLLocationManagerDelegate, GMSMapViewDelegate{
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.startUpdatingLocation()
    mapView.settings.compassButton = true
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
      
  }
  
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
          
            return
        }
    
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        textfieldAddress.text = ""
        searchCancelBtn.isHidden = true
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        print(position.target)
     
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        if selectedPickUp == true
        {
            selectedPickUp = false
        }
        else
        {
            selectedPickUp = false
            markerPin.position = position.target
            reverseGeocoding(marker: markerPin)
        }
        
    }


    
    func reverseGeocoding(marker: GMSMarker)
    {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                
                guard let address = response?.firstResult(), let lines = address.lines else {
                  return
                }
                            
                self.lines = address.lines?[0] ?? ""
                self.thoroughfare = address.thoroughfare ?? ""
                self.subLocality = address.subLocality ?? ""
                self.locality = address.locality ?? ""
                self.postalCode = address.postalCode ?? ""
                self.administrativeArea = address.administrativeArea ?? ""
                self.country = address.country ?? ""
                let location:CLLocationCoordinate2D = address.coordinate
                self.latitude  = String(location.latitude)
                self.longitude  = String(location.longitude)
                print(address)
                print(self.administrativeArea)
                print(self.subLocality)
                print(self.locality)

              //  if self.country == "India"{
                
                    self.addressLabel.text = lines.joined(separator: "\n")
                    UIView.animate(withDuration: 0.25) {
                      self.view.layoutIfNeeded()
                    }
                    
                    if self.strLong == self.longitude {
                        
                    }
                    else{
                        self.strLong = self.longitude
                        DispatchQueue.main.async {
                            self.getAddressForLatLng(latitude: self.latitude, longitude: self.longitude)
                        }
                    }
                    
                }
//                else{
//                    self.addressLabel.text = "Beauty-Hub not available at this location at the moment. please select a different location."
//                    UIView.animate(withDuration: 0.25) {
//                      self.view.layoutIfNeeded()
//                    }
//                }
            }
        }
    
    
    
    func getAddressForLatLng(latitude: String, longitude: String) {
        var apiKeyStr = GlobalConstants.GoogleWebAPIKey
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(apiKeyStr)")
        else {
                return
            }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)  as! [String: Any]
                if let result = jsonResponse["results"] as? [[String: Any]] {
                    if result.count > 0 {
                        if let address = result[0]["formatted_address"] as? String {
                        print(result[0])
                            let fullNameArr = address.components(separatedBy: ",")
                            if fullNameArr.count > 0 {
                                self.lines = address
                                DispatchQueue.main.async {
                                    self.addressLabel.text = address
                                    UIView.animate(withDuration: 0.25) {
                                        self.view.layoutIfNeeded()
                                    }
                                }
                                    self.thoroughfare = fullNameArr[0]
                                    if fullNameArr.count > 1 {
                                        let trimmedString = fullNameArr[1].trimmingCharacters(in: .whitespaces)
                                        if self.subLocality !=  trimmedString{
                                            self.thoroughfare = fullNameArr[0] + ", " + trimmedString
                                        }
                                }
                            }
                        }
                    }
                }
            } catch {
               
            }
        }
        task.resume()
    }
}
extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
extension MapsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
         return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let fullText = text.replacingCharacters(in: range, with: string)
        strSearchText = fullText
        if fullText.count > 0 {
            showResults(string:fullText)
            searchCancelBtn.isHidden = false
        }else{
            hideResults()
            searchCancelBtn.isHidden = true
        }
        return true
    }
}
extension MapsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewSearch.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        var strFirst = ""
        let fullAddressArr = autocompleteResults[indexPath.row].formattedAddress.components(separatedBy: ",")
        if fullAddressArr.count > 0 {
            strFirst = fullAddressArr[0] + ", "
            cell.lbeAddressFirst.text = fullAddressArr[0]
        }
        if fullAddressArr.count > 1{
            let lastString:String = autocompleteResults[indexPath.row].formattedAddress
            cell.lbeAddress.text = lastString.replacingOccurrences(of: strFirst, with: "")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        textfieldAddress.text = autocompleteResults[indexPath.row].formattedAddress
        textfieldAddress.resignFirstResponder()
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = true
                    if let lat = place.latitude, let lng = place.longitude{
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        self.mapView.camera = GMSCameraPosition.camera(withLatitude:lat, longitude: lng , zoom: 18.00)
                    }
                    self.tableviewSearch.reloadData()
                }
            } else {
                print(response.error ?? "ERROR") }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var sizeFonts = CGFloat()
        var mainFonts = CGFloat()

    var str = ""
    let fullAddressArr = autocompleteResults[indexPath.row].formattedAddress.components(separatedBy: ",")
    if fullAddressArr.count > 0 {
        str = fullAddressArr[0]
        mainFonts  = str.heightForView(text: "", font: UIFont(name:FontName.Inter.Medium, size: 16.0) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 100)
    }
        
    if fullAddressArr.count > 1{
            let lastString:String = autocompleteResults[indexPath.row].formattedAddress
            str = lastString.replacingOccurrences(of: str, with: "")
    }
        
        sizeFonts  = str.heightForView(text: "", font: UIFont(name:FontName.Inter.Medium, size: 16.0) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 100)
        
        
        
        if sizeFonts < 42 {
            return 74 + mainFonts
        }else {
            print(sizeFonts)
            return sizeFonts + 30 + mainFonts
        }
       
    }
}



class SearchResultCell: UITableViewCell {
    @IBOutlet var lbeAddress: UILabel!
    @IBOutlet weak var lbeAddressFirst: UILabel!

}
