//
//  BookingDaysViewController.swift
//  AnfasUser
//
//  Created by AbsolveTech on 08/07/24.
//

import Foundation
import UIKit

extension BookingDoctorViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        return arrSortedTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TimeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        
        
        if indexPath.row == timeIndex {
            if Utility.shared.DivceTypeString() == "IPad" {
                Utility.shared.makeShadowsOfView_roundCorner(view: cell.vwRound,shadowColor: AppColor.YellowColor, shadowRadius: 0.1, cornerRadius: 5,borderWidth:2, borderColor: AppColor.YellowColor)
            }
            else{
                Utility.shared.makeShadowsOfView_roundCorner(view: cell.vwRound,shadowColor: AppColor.YellowColor, shadowRadius: 0.1, cornerRadius: 5,borderWidth:1.2, borderColor: AppColor.YellowColor)
            }
            
            
            cell.vwRound.backgroundColor = AppColor.YellowColor.withAlphaComponent(0.22)
            let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(14.5))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
            cell.lbeTime.font = actionTitleFont
            
        }
        else{
            
            if Utility.shared.DivceTypeString() == "IPad" {
                Utility.shared.makeShadowsOfView_roundCorner(view: cell.vwRound,shadowColor:UIColor.lightGray, shadowRadius: 0.1, cornerRadius: 5,borderWidth:1.1, borderColor: UIColor.lightGray.withAlphaComponent(1))
            }
            else{
                Utility.shared.makeShadowsOfView_roundCorner(view: cell.vwRound,shadowColor:UIColor.lightGray, shadowRadius: 0.1, cornerRadius: 5,borderWidth:1, borderColor: UIColor.lightGray.withAlphaComponent(1))
            }
            
            cell.vwRound.backgroundColor = AppColor.Timebg
            let actionTitleFont = UIFont(name: FontName.Inter.Regular, size: CGFloat("".dynamicFontSize(13.5))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
            cell.lbeTime.font = actionTitleFont
            
        }
        
        cell.lbeTime.text = arrSortedTime[indexPath.row].fromTime
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size = CGSize(width: collectionView.size.width / 4 - 4, height: 48)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timeIndex = indexPath.row
        slotId = arrSortedTime[indexPath.row].slotId
        self.collectionTime.reloadData()
        
    }
}
class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var lbeTime: UILabel!
    @IBOutlet var vwRound: UIView!
}
