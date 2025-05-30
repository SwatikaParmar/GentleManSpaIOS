//
//  UIViewAnchorPoint.swift
//  DesignableXTesting
//
//  Created by Avtar Singh on 12/18/16.
//  Developer Email: dhaliwal.avtar1@gmail.com
// Anil

//    import UIKit
//
//    @IBDesignable
//    class UIViewAnchorPoint: UIView {
//
//        @IBInspectable var showAnchorPoint: Bool = false
//        @IBInspectable override var anchorPoint : CGPoint{
//
//            didSet {
//                setAnchorPoint(anchorPoint: anchorPoint)
//            }
//        }
//
//
//        override func draw(_ rect: CGRect) {
//            if showAnchorPoint {
//                let anchorPointlayer = CALayer()
//                anchorPointlayer.backgroundColor = UIColor.red.cgColor
//                anchorPointlayer.bounds = CGRect(x: 0, y: 0, width: 6, height: 6)
//                anchorPointlayer.cornerRadius = 3
//
//                let anchor = layer.anchorPoint
//                let size = layer.bounds.size
//
//                anchorPointlayer.position = CGPoint(x: anchor.x * size.width, y: anchor.y * size.height)
//                layer.addSublayer(anchorPointlayer)
//            }
//        }
//
//        func setAnchorPoint(anchorPoint: CGPoint) {
//            var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
//            var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
//
//            newPoint = newPoint.applying(transform)
//            oldPoint = oldPoint.applying(transform)
//
//            var position = layer.position
//            position.x -= oldPoint.x
//            position.x += newPoint.x
//
//            position.y -= oldPoint.y
//            position.y += newPoint.y
//
//            layer.position = position
//            layer.anchorPoint = anchorPoint
//        }
//    }
