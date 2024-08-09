//
//  UILabelX.swift
//  DesignableXTesting
//
//  Created by Avtar Singh on 12/18/16.
//  Developer Email: dhaliwal.avtar1@gmail.com
//

import UIKit

@IBDesignable
class UILabelX: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }
    
    @IBInspectable var DynamicFontSize: CGFloat = 0 {
        didSet {
            overrideFontSize(FontSize: DynamicFontSize)
        }
    }
    
    func overrideFontSize(FontSize: CGFloat){
        let fontName = self.font.fontName
        let screenWidth = UIScreen.main.bounds.size.width
        var calculatedFontSize = screenWidth / 375 * FontSize
        
        if Utility.shared.DivceTypeString() == "IPad" {
            calculatedFontSize = calculatedFontSize + 5
        }
       
        self.font = UIFont(name: fontName, size: calculatedFontSize)
    }
}
