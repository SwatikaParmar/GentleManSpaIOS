//
//  BaseViewController.swift
//  SalonApp
//
//  Created by mac on 13/06/23.
//

import Foundation
import UIKit


class NotificationAlert {
    
    func actualNumberOfLines(label: UILabel) -> Int {
            label.layoutIfNeeded()
            let myText = label.text! as NSString
            let rect = CGSize(width: UIScreen.main.bounds.width - 25, height: CGFloat.greatestFiniteMagnitude)
            let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font as Any], context: nil)
            return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
        }
    
    func NotificationAlert(titles:String){
            
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.gray
        toastView.textColor = UIColor.black
        toastView.textAlignment = .center
        toastView.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15)
        toastView.layer.masksToBounds = true
        toastView.text = titles
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
      
       //     debugPrint(actualNumberOfLines(label: toastView))
        
            var widthString = "V:|-(>=200)-[loginView(==50)]-85-|"
            if actualNumberOfLines(label: toastView) == 1 {
                widthString = String(format: "V:|-(>=200)-[loginView(==50)]-80-|")
                toastView.layer.cornerRadius = 25
            }
            else if actualNumberOfLines(label: toastView) == 2 {
                widthString = String(format: "V:|-(>=200)-[loginView(==60)]-80-|")
                toastView.layer.cornerRadius = 8
            }
            else if actualNumberOfLines(label: toastView) == 3 {
                widthString = String(format: "V:|-(>=200)-[loginView(==70)]-80-|")
                toastView.layer.cornerRadius = 8
            }
            else{
                widthString = String(format: "V:|-(>=200)-[loginView(==80)]-80-|")
                toastView.layer.cornerRadius = 8
            }
        
       
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first  else {
               return
            }
            window.addSubview(toastView)
            
            let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
    
            let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: UIScreen.main.bounds.width - 50)
            
            let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: widthString, options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
            
            NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
            NSLayoutConstraint.activate(verticalContraint)
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 1
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    toastView.alpha = 0
                }, completion: { finished in
                    toastView.removeFromSuperview()
                })
            })
        }
}


class FontName{
    struct Inter {
        static let Bold = "Poppins-Bold"
        static let SemiBold = "Poppins-SemiBold"

        static let Regular = "Poppins-Regular"
        static let Medium = "Poppins-Medium"
    }
   
}

