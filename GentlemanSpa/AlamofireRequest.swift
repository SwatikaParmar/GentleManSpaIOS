//
//  AlamofireRequest.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 15/07/24.
//

import Foundation
import Alamofire
import Reachability
import NVActivityIndicatorView



class AlamofireRequest: NSObject {
    static let shared = AlamofireRequest()
    var StatusCodeValue = 0
    
    
    
    // MARK: - PostBodyForRawData
    func PostBodyForRawData(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            
            if isLoader{
                Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
            }
            
            if let urL = URL(string: urlString) {
                if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                    
                    var request = URLRequest(url: urL)
                    request.httpMethod = HTTPMethod.post.rawValue
                    
                    if authToken != nil && authToken != ""{
                        let bearer : String = "Bearer \(authToken!)"
                        print(bearer)
                        request.addValue(bearer, forHTTPHeaderField: "Authorization")
                    }
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonString.data(using: .utf8)
                    
                    AF.request(request).responseData { response in
                        debugPrint(response)
                        if isLoader{
                            Indicator.shared.stopAnimating()
                        }
                        if let statusCode = response.response?.statusCode
                        {
                            self.StatusCodeValue = statusCode
                            self.SessionEnd(code: self.StatusCodeValue)
                        }
                        switch response.result {
                        case .success(let data):
                            do {
                                let asJSON = try JSONSerialization.jsonObject(with: data)
                                Indicator.shared.stopAnimating()
                                if let responseDictionary = asJSON as? [String: AnyObject] {
                                    completion(responseDictionary, nil)
                                }
                                else{
                                    Indicator.shared.stopAnimating()
                                    completion(nil , response.error)
                                }
                            } catch {
                                Indicator.shared.stopAnimating()
                                completion(nil,response.error)
                            }
                        case .failure(let error):
                            Indicator.shared.stopAnimating()
                            completion(nil,error)
                            break
                        }
                    }
                }
                else{
                    Indicator.shared.stopAnimating()
                    completion(nil,nil)
                }
            }
            else
            {
                Indicator.shared.stopAnimating()
                completion(nil,nil)
                
            }
        }
        else
        {
            Indicator.shared.stopAnimating()
            InternetConnectionAlert()
        }
    }
    
    
    // MARK: - GetBodyFrom
    func GetBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
         let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
               Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
             //   print(bearer)
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    // MARK: - postBodyFrom
    func GetPostBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
        let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
            Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
                print(bearer)
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    // MARK: - LivePostBodyForRawData
    func LivePostBodyForRawData(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            
            if isLoader{
                Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
            }
            
            if let urL = URL(string: urlString) {
                if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                    
                    var request = URLRequest(url: urL)
                    request.httpMethod = HTTPMethod.post.rawValue
                    
                    if authToken != nil && authToken != ""{
                        let bearer : String = "Bearer \(authToken!)"
                        request.addValue(bearer, forHTTPHeaderField: "Authorization")
                    }
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonString.data(using: .utf8)
                    
                    AF.request(request).responseData { response in
                        debugPrint(response)
                        if isLoader{
                            Indicator.shared.stopAnimating()
                        }
                        if let statusCode = response.response?.statusCode
                        {
                            self.StatusCodeValue = statusCode
                            self.SessionEnd(code: self.StatusCodeValue)
                        }
                        switch response.result {
                        case .success(let data):
                            do {
                                let asJSON = try JSONSerialization.jsonObject(with: data)
                                if let responseDictionary = asJSON as? [String: AnyObject] {
                                    completion(responseDictionary, nil)
                                }
                                else{
                                    Indicator.shared.stopAnimating()
                                    completion(nil , response.error)
                                }
                            } catch {
                                Indicator.shared.stopAnimating()
                                completion(nil,response.error)
                            }
                        case .failure(let error):
                            Indicator.shared.stopAnimating()
                            completion(nil,error)
                            break
                        }
                    }
                }
                else{
                    Indicator.shared.stopAnimating()
                    completion(nil,nil)
                }
            }
            else
            {
                Indicator.shared.stopAnimating()
                completion(nil,nil)
                
            }
        }
        else
        {
            Indicator.shared.stopAnimating()
        }
    }
    
    
    
    // MARK: - DeleteBodyFrom
    func DeleteBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
         let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
                 Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.delete.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
              
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    func uploadImageRemote(urlString : String, image:UIImage,name:String,userID:String, callback:@escaping (_ data: String?, _ error: NSError? ) -> Void){
        
        
        
        let data = image.jpegData(compressionQuality: 0.1)
        if data == nil{
            print("data return nil")
            return
        }
        
        let token = accessToken()
        
        let bearer : String = "Bearer \(token )"
        
        let parameters = ["id": userID]
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization": bearer]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
            multipartFormData.append(data!, withName: "profilePic", fileName:name, mimeType: "image/jpeg")
            
            
            
            
        },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                  method: .post,
                  headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        let dataImage = parsedData["data"] as! String
                        callback(dataImage , nil )
                        
                    }
                }catch{
                    print("error message")
                    callback("failure",nil)

                }
            }
            else{
                print(response.error ?? "")
                callback("failure",nil)

            }
        }
    }
    
    
    func uploadImageArray(urlString : String, pictures: [UIImage],name:String,userID:String, callback:@escaping (_ data: String?, _ error: NSError? ) -> Void){
        
        
        let token = accessToken()
        
        let bearer : String = "Bearer \(token )"
        
        let parameters = ["ProductId": userID]
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization": bearer]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for i in 0..<pictures.count {
                if let imageData = pictures[i].jpegData(compressionQuality: 1) {
                            multipartFormData.append(imageData, withName: "Images", fileName: name, mimeType: "image/jpeg")
                        }
                    }

            
        },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                  method: .post,
                  headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        let dataImage = "successfully"
                        Indicator.shared.stopAnimating()

                        callback(dataImage , nil )
                        
                    }
                }catch{
                    Indicator.shared.stopAnimating()

                    print("error message")
                    callback("failure",nil)

                }
            }
            else{
                Indicator.shared.stopAnimating()

                print(response.error ?? "")
                callback("failure",nil)

            }
        }
    }
    // MARK: - SessionEnd

    func SessionEnd(code:Int)
    {
        if code == 401
        {
            if let token = UserDefaults.standard.string(forKey: Constants.accessToken), !token.isEmpty {
                
                    let alert = UIAlertController(title: "Session Expired", message: "Please login again.", preferredStyle: .alert)
                    
                    let No = UIAlertAction(title: "OK", style: .default, handler: { action in
                       
                        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
                        UserDefaults.standard.removeObject(forKey: Constants.login)
                        UserDefaults.standard.removeObject(forKey: Constants.userImg)
                        UserDefaults.standard.removeObject(forKey: Constants.firstName)
                        UserDefaults.standard.removeObject(forKey: Constants.lastName)
                        UserDefaults.standard.removeObject(forKey: Constants.email)
                        UserDefaults.standard.removeObject(forKey: Constants.phone)
                        UserDefaults.standard.removeObject(forKey: Constants.userImg)
                        RootControllerManager().SetRootViewController()
                        
                    })
                    alert.addAction(No)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            return
        }
    }
    
    // MARK: - InternetConnectionAlert

    func InternetConnectionAlert()
        {
            NotificationAlert().NotificationAlert(titles: "Oops, No Internet connection!")
        }
}





class Indicator: NSObject , NVActivityIndicatorViewable {
        var activityData = ActivityData()
        static let shared = Indicator()
    
        func startAnimating(withMessage : String, colorType : UIColor, colorText : UIColor) {
        
        var colorBg = UIColor()
        colorBg = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20)
        activityData = ActivityData(size: CGSize(width: 60, height: 60),
                                    message: withMessage,
                                    messageFont: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                    type: NVActivityIndicatorType.ballClipRotateMultiple,
                                    color: AppColor.TabSelectColor,
                                    padding: 0,
                                    displayTimeThreshold: NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD,
                                    minimumDisplayTime: NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME,
                                    backgroundColor: colorBg,
                                    textColor: UIColor.white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData, nil)
    }
        func stopAnimating(){
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
