//
//  Constants.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 12/07/24.
//

import Foundation
import UIKit


struct Constants {
    
    static let deviceToken = "deviceToken"
    static let accessToken = "accessToken"
    static let userId = "userId"
    static let userType = "userType"
    static let professionalDetailId = "professionalDetailId"

    static let enterpriseId = "enterpriseId"
    static let phone = "phone"
    static let email = "email"
    static let name = "name"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let userImg = "userImg"
    static let fcmToken = "fcmToken"
    static let status = "status"
    static let ProfileImg = "ProfileImg"
    static let NotificationOnOff = "NotificationOnOff"
    static let otp = "otp"
    static let phoneOtp = "phoneOtp"
    static let userModel = "userModel"
    static let percentageProfileComplete = "percentageProfileComplete"
    static let city = "city"
    static let guestUser = "guestUser"
    static let gender = "gender"
    static let login = "LoginBool"
    static let stateName = "stateName"

}

public func accessToken() -> String
{
    return UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
}

public func userId() -> String
{
    return UserDefaults.standard.string(forKey: Constants.userId) ?? ""
}

public func professionalDetailId() -> Int
{
    return UserDefaults.standard.integer(forKey: Constants.professionalDetailId) 
}


class AppColor: NSObject {
    
    static let AppThemeColorCG : CGColor = UIColor(red: 0 / 255.0, green: 166.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0).cgColor
    static let AppThemeColor : UIColor =  UIColor(red: 0 / 255.0, green: 166.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    static let BrownColor : UIColor =  UIColor(red: 183.0 / 255.0, green: 137.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
    static let BlackColor : UIColor =  UIColor(red: 38.0 / 255.0, green: 50.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
    
    static let AppTealishRGB : UIColor =  UIColor(red: 197.0 / 255.0, green: 154.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
    static let Timebg : UIColor =  UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)

    static let YellowColor : UIColor = UIColor( red: CGFloat(197/255.0), green: CGFloat(154/255.0), blue: CGFloat(86/255.0), alpha: CGFloat(1.0) )
    
    static let AppThemeColorPro : UIColor =  UIColor(red: 183 / 255.0, green: 137.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)

}

enum Language : String{
    case English = "en"
    
}

enum UserType : String{
    case customer = "customer"
    case professional = "professional"

}
struct GlobalConstants {
    
    static let serverError = "There was an error connecting to server."
    static let timedOutError = "The request timed out."
    static let oopsError = "Oops!"
    static let successMessage = "SUCCESS!"
    
    static let MalePlaceHolding: String = "placeholder_Male"
    static let FemalePlaceHolding: String = "placeholder_FeMale"
    static let OtherPlaceHolding: String = "placeholder_Male"
    
    static let GoogleWebAPIKey = "AIzaSyBgLMQ8wvy5yda0qP1_8y1e_aJJ_HrTdZw"    
    static let BASE_IMAGE_URL = "https://gentlemanspa-file.s3.ap-south-1.amazonaws.com/FileToSave/"
}
extension String{
    
    static let LiveBaseURL = "https://s1jpw3b88a.execute-api.ap-south-1.amazonaws.com/api/"
    static let LiveDevBaseURL = "https://s1jpw3b88a.execute-api.ap-south-1.amazonaws.com/api/"
    
    var path: String{
        return .LiveBaseURL
    }
    
    var LoginURL: String{
        return "Path".path + "Auth/Login"
    }
    var ChangePassword: String{
        return "Path".path + "Auth/ChangePassword"
    }
    var ResendEmailURL: String{
        return "Path".path + "Auth/EmailOTP"
    }
    
    var SignUpURL: String{
        return "Path".path + "Auth/Register"
    }
    
    var GetAllSpecialities: String{
        return "Path".path + "Content/GetAllSpecialities"
    }
    
    var GetBanners: String{
        return "Path".path + "Content/GetBanners"
    }
    
    var GetSpas: String{
        return "Path".path + "Admin/GetSpas"
    }
    
    var homeApi: String{
        return "Path".path + "Admin/GetSpaCategories"
    }
    
    var GetProfileDetail: String{
        return "Path".path + "Customer/GetProfileDetail"
    }
    var getSalonServiceList: String{
        return "Path".path + "Service/GetServiceList"
    }
    var UpdateProfile: String{
        return "Path".path + "Customer/UpdateProfile"
    }
    var GetServiceDetail: String{
        return "Path".path + "Service/GetServiceDetail"
    }
    
    
    var GetProfessionalProfileDetail: String{
        return "Path".path + "Professional/GetProfessionalProfileDetail"
    }
    
    var AddUpdateProfessionalSchedule: String{
        return "Path".path + "Professional/AddUpdateProfessionalSchedule"
    }
    
    var GetProfessionalSchedulesByProfessionalDetailId: String{
        return "Path".path + "Professional/GetProfessionalSchedulesByProfessionalDetailId"
    }
    
    var UpdateProfessionalProfile: String{
        return "Path".path + "Professional/UpdateProfessionalProfile"
    }
    
    var GetWeekdays: String{
        return "Path".path + "Content/GetWeekdays"
    }
    
    
    var GetProfessionalServices: String{
        return "Path".path + "Service/GetProfessionalServices"
    }
    
    var uploadProfilePic: String{
        return "Path".path + "Upload/UploadProfilePic"
    }
    
   
    
    
}
