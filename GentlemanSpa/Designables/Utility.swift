//
//  Utility.swift
//  BaseProject
//
//  Created by rupinder singh on 31/08/20.
//  Copyright © 2020 rupinder singh. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class Utility: NSObject {
    static let shared:Utility = Utility()
  
var appDelegate: AppDelegate {
     return UIApplication.shared.delegate as! AppDelegate
    }
 
    func appVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
       
        return "\(version)"
    }
    func appBuildVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
       
        let build = dictionary["CFBundleVersion"] as! String
        return "\(build)"
    }

    func getMajorSystemVersion() -> Int
    {
        let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
        let mainSystemVersion = Int((systemVersionStr.split{$0 == "."}.map(String.init))[0])
        
        return mainSystemVersion!
    }

   

    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    func  DivceTypeString() -> String{
        if DeviceType.IS_IPHONE{
            return "IPhone"
        }else if DeviceType.IS_IPAD{
            return "IPad"
        }
        return "IPod"
    }
    struct DeviceType
    {
        static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
        //static let IS_TV = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.TV
        
        static let IS_IPHONE_4_OR_LESS =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    }

    func getAppUniqueId() -> String
    {
        let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
        
        return uniqueId.uuidString
    }
    func setColorOfButtonImage(btn:UIButton,color:UIColor,image:UIImage){
        
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = color    }
    
    
    func setColorOfImageView(imgView:UIImageView,color:UIColor,image:UIImage){
        
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        imgView.image = tintedImage
        imgView.tintColor = color    }
    
    
    
    
   
    func makeShadowsOfView(view:UIView,shadowColor:UIColor = UIColor.black){
        
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = 2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2.5
        
    }
    func makeShadowsOfView_blow_roundCorner(view:UIView,shadowColor:UIColor = UIColor.lightGray,shadowRadius:CGFloat,shadowOffset:CGSize,cornerRadius:CGFloat,borderWidth:CGFloat = 1,borderColor:UIColor){
        
      
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowRadius = shadowRadius
        
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        
    }
    func makeShadowsOfView_roundCorner(view:UIView,shadowColor:UIColor = UIColor.darkGray.withAlphaComponent(0.5),shadowRadius:CGFloat,cornerRadius:CGFloat,borderWidth:CGFloat = 0.5,borderColor:UIColor){
        
      
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = shadowRadius
        
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        
    }
    
    func makeShadowsOfLayer_roundCorner(layer:CALayer,shadowColor:UIColor = UIColor.darkGray.withAlphaComponent(0.5),shadowRadius:CGFloat,cornerRadius:CGFloat,borderWidth:CGFloat = 0.5,borderColor:UIColor){
        
      
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
    }
    
    
    
    func makeRoundCorner(layer:CALayer,color:UIColor,radius:CGFloat,borderWidth:CGFloat = 1){
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
        
    }
    
    func makeCircular(layer:CALayer,borderColor:UIColor,object:UIView,borderWidth:CGFloat = 1.0){
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = object.frame.height/2
        object.clipsToBounds = true
    }
    func makeCircular_withConstantWidthHeight(layer:CALayer,borderColor:UIColor,object:UIView,width:CGFloat,height:CGFloat){
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = height/2
        object.clipsToBounds = true
    }
    
    func roundCorners_particular(layer:CALayer,cornerRadius: CGFloat,corners:CACornerMask)
    {
     
          layer.cornerRadius = cornerRadius
          layer.maskedCorners =  corners //[.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat,view:UIView) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
         view.layer.mask = mask
        view.layer.masksToBounds = true
        
        
        
        }
    
    func roundParticular(corners: UIRectCorner, cornerRadius: Double,view1:UIView) {
           
           let size = CGSize(width: cornerRadius, height: cornerRadius)
           let bezierPath = UIBezierPath(roundedRect: view1.bounds, byRoundingCorners: corners, cornerRadii: size)
           let shapeLayer = CAShapeLayer()
        shapeLayer.frame = view1.bounds
             shapeLayer.path = bezierPath.cgPath
        view1.layer.mask = shapeLayer
       }
    func roundedButtonByCorners(button:UIButton,corners:UIRectCorner,cornerRadius:CGSize){
            
      let  maskPath1 = UIBezierPath(roundedRect: button.bounds,
                byRoundingCorners: corners,
                cornerRadii: cornerRadius)
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame =  button.bounds
            maskLayer1.path = maskPath1.cgPath
            button.layer.mask = maskLayer1
        
        }
    func changeStatusBarColor(view:UIView,color:UIColor){
        let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
        statusbarView.backgroundColor =  color
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func taxPercenatage(price:Double,tax:Double) -> Double{
        let basicPrice = price
        let tax = (basicPrice * tax) / 100
        return tax
    }
    func addEye(textField:UITextField)-> UIButton
    {
        let buttonNew = UIButton(type: .custom)
        buttonNew.setImage(UIImage(named: "EyeHide"), for: .normal)
        buttonNew.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNew.frame = CGRect(x: CGFloat(textField.frame.size.width - 35), y: CGFloat(5), width: CGFloat(35), height: CGFloat(35))
      //  buttonNew.addTarget(self, action: #selector(self.reveal1), for: .touchUpInside)
        textField.rightView = buttonNew
        textField.rightViewMode = .always
        
       return buttonNew
    }
    func provideAttributedFamily(text:String,size:CGFloat,fontName:String) -> NSAttributedString{
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.init(name: fontName, size: size)]
        return NSAttributedString(string: text, attributes: titleTextAttributes as [NSAttributedString.Key : Any])
    }
    
}
extension String {
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
                let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
                return phoneTest.evaluate(with: self)
    }
    
    func isValidEmail()->Bool {
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func dateFromString(_ dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateString) ?? Date()
        return date
    }
    
    func getTodayWeekDay(_ dateT :Date)-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEE"
           dateFormatter.timeZone = TimeZone.current

           let weekDay = dateFormatter.string(from: dateT)
           return weekDay
     }
    
    func getTodayDateDD(_ dateT :Date)-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd"
           dateFormatter.timeZone = TimeZone.current

           let weekDay = dateFormatter.string(from: dateT)
           return weekDay
     }
  
    func changeDateFormat(_ dateString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.Z"
        
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy'-'MMM'-'dd"
        return outputDateFormatter.string(from: date)
    }
    
    func changeINDateFormat(_ dateString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd'-'MMM'-'yyyy"
        return outputDateFormatter.string(from: date)
    }
    

    func changeDateFormat_String(_ dateString : String) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
      
        let date = dateFormatter.date(from: dateString) ?? Date()
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        return outputDateFormatter.string(from: date)
    }
    
    
    var dobDateToDateString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if localDate != nil {
            let localDateString = dateFormatter.string(from: localDate!)
            return localDateString
        }
        else{
            return self
        }
    }
    
    func formatDateStringMMM(_ dateString: String) -> String? {
        // Define the input and output date formatters
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(identifier: "UTC") // Adjust if the input time is not UTC
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        outputFormatter.timeZone = TimeZone.current // Adjust to local timezone if needed
        
        // Convert the string to a date and then back to the desired string format
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return "" // Handle invalid date string
        }
    }
    
    func convertToDDMMYYYY(_ date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    func convertToYYYYMMDD(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    
    func convertMMDD(date:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "E, d MMM yyyy"
        if localDate != nil {
            let localDateString = dateFormatter.string(from: localDate!)
            return localDateString
        }
        else{
            return self
        }
    }
    
    
    func heightForTableViewCell(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label = UILabel ()
        label.frame = CGRect.init(x: 0, y: 0, width:width, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        
        let style = NSMutableParagraphStyle()
            style.lineSpacing = 0
            style.alignment = .center
            label.attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: style])
            label.sizeToFit()
        
        let maxSize = CGSize(width:width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let textSize = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        
        print("LineNo-",linesRoundedUp)
        print("TextSize-",Int(charSize))
        print("Height-",CGFloat(linesRoundedUp * Int(charSize)))
        return CGFloat(linesRoundedUp * Int(charSize))
    }
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label = UILabel ()
        label.frame = CGRect.init(x: 0, y: 0, width:width, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        let maxSize = CGSize(width:width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let textSize = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        
        print("LineNo-",linesRoundedUp)
        print("textsize-",Int(charSize))
        print("LINE-",CGFloat(linesRoundedUp * Int(charSize) + 20))
        return CGFloat(linesRoundedUp * Int(charSize) + 20)
    }
    
    func lineCount(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label = UILabel ()
        label.frame = CGRect.init(x: 0, y: 0, width:width, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()

        let maxSize = CGSize(width:width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let textSize = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return CGFloat(linesRoundedUp)
    }
    
    
    func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
           let screenWidth = UIScreen.main.bounds.size.width
           var calculatedFontSize = screenWidth / 375 * FontSize
        
        if Utility.shared.DivceTypeString() == "IPad" {
            calculatedFontSize = FontSize + 5
        }
      
           return calculatedFontSize
       }
}
