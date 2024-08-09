//
//  CalendarView+Style.swift
//  CalendarView
//
//  Created by Vitor Mesquita on 17/01/2018.
//  Copyright © 2018 Karmadust. All rights reserved.
//

import UIKit

extension CalendarView {
    
    public struct Style {
        
        public enum CellShapeOptions {
            case round
            case square
            case bevel(CGFloat)
            var isRound: Bool {
                switch self {
                case .round:
                    return true
                default:
                    return false
                }
            }
        }
        
        public enum FirstWeekdayOptions{
            case sunday
            case monday
        }
        
        //Event
        public static var cellEventColor = UIColor(red: 254.0 / 255.0, green: 195.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        
        //Header
        public static var headerHeight: CGFloat = 115.0
        public static var headerTextColor = UIColor.gray
        public static var headerFontName: String = "Helvetica"
        public static var headerFontSize: CGFloat = 20.0

        //Common
        public static var cellShape                 = CellShapeOptions.bevel(4.0)
        
        public static var firstWeekday              = FirstWeekdayOptions.monday
        
        //Default Style
        public static var cellColorDefault          = UIColor(white: 0.0, alpha: 0.1)
        public static var cellTextColorDefault      = UIColor.gray
        public static var cellBorderColor           = UIColor.clear
        public static var cellBorderWidth           = CGFloat(1.0)
        
        //Today Style
        public static var cellTextColorToday        = UIColor.gray
        public static var cellColorToday            = UIColor(red: 254.0 / 255.0, green: 195.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        
        //Selected Style
        public static var cellSelectedBorderColor   = UIColor(red: 254.0 / 255.0, green: 195.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        
        public static var cellSelectedBorderWidth   = CGFloat(2.0)
        public static var cellSelectedColor         = UIColor.clear
        public static var cellSelectedTextColor     = UIColor.white
        
        //Weekend Style
        public static var cellTextColorWeekend      = UIColor.black
        
        //Locale Style
        public static var locale                    = Locale.current
        
        //TimeZone Calendar Style
        public static var timeZone                  = TimeZone.current
        // UTC De
        //Calendar Identifier Style
        public static var identifier                = Calendar.Identifier.gregorian
    }
}
