/*
 * CalendarHeaderView.swift
 * Created by Michael Michailidis on 07/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

open class CalendarHeaderView: UIView {
    
    lazy var monthLabel : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: CalendarView.Style.headerFontName, size: CalendarView.Style.headerFontSize)
        
        lbl.textColor = UIColor.white

        self.addSubview(lbl)
        
        return lbl
    }()
    lazy var prevButton : UIButton = {
        let btn = UIButton()
        //btn.setTitle("PREV", for: .normal)
      //   btn.setImage(#imageLiteral(resourceName: "NextWhite"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font =  UIFont(name: CalendarView.Style.headerFontName, size: 15)
      //  self.addSubview(btn)
        
        return btn
    }()
    
    lazy var nextButton : UIButton = {
        let btn = UIButton()
        //btn.setTitle("NEXT", for: .normal)
       // btn.setImage(#imageLiteral(resourceName: "backImage"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font =  UIFont(name: CalendarView.Style.headerFontName, size: 15)
     //   self.addSubview(btn)
        
        return btn
    }()
    
    lazy var dayLabelContainerView : UIView = {
        let v = UIView()
        
        let formatter = DateFormatter()
        formatter.locale = CalendarView.Style.locale
       // formatter.timeZone = CalendarView.Style.timeZone
        formatter.timeZone = TimeZone.current
        var start = CalendarView.Style.firstWeekday == .sunday ? 0 : 1
        // Anil
        for index in start..<(start+7) {
            
            let weekdayLabel = UILabel()
            
            weekdayLabel.font = UIFont(name: CalendarView.Style.headerFontName, size: 18)
            var str = formatter.shortWeekdaySymbols[(index % 7)].capitalized
            weekdayLabel.text = str.first?.description ?? ""
            weekdayLabel.textColor = UIColor.black
            weekdayLabel.textAlignment = NSTextAlignment.center
            v.addSubview(weekdayLabel)
        }
        
        self.addSubview(v)
        
        return v
        
    }()
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        var frm = self.bounds
        frm.origin.y = -10.0
        frm.size.height = self.bounds.size.height / 2.0
        
        
        self.monthLabel.frame = frm

        var labelFrame = CGRect(
            x: 3.5,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0 - 7,
            height : self.bounds.size.width / 7.0 - 7
            
        )
        
        for lbl in self.dayLabelContainerView.subviews {
            lbl.backgroundColor = UIColor.clear
            monthLabel.textColor = UIColor.black
            lbl.frame = labelFrame
            lbl.layer.cornerRadius = lbl.frame.size.width / 2
            lbl.clipsToBounds = true
            labelFrame.origin.x += labelFrame.size.width + 7
        }
    }
}
