//
//  MyCartExtension.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 16/10/24.
//

import Foundation
import UIKit

extension MyCartViewController : UITableViewDataSource,UITableViewDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.arrSortedService.count > 0{
                return 1

           }
            return 0
        }
        if section == 1 {
            if self.arrSortedProduct.count > 0{
                return 1

           }
            return 0
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
            
            if arrObjectServices != nil {
                cell.lbetotalSellingPrice.text = String(format: "$%.2f", self.arrObjectServices?.totalSellingPrice ?? 0.00)
                
                
                cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrObjectServices?.totalDiscountAmount ?? 0.00)
                
                cell.lbetotalMrp.text = String(format: "$%.2f", self.arrObjectServices?.totalMrp ?? 0.00)
                
                
            }
            cell.arrSortedService = arrSortedService
            cell.tableViewServices.reloadData()
            cell.lastClass = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as! ProductListTableViewCell
            
            if arrObject != nil {
                cell.lbetotalSellingPrice.text = String(format: "$%.2f", self.arrObject?.totalSellingPrice ?? 0.00)
                
                
                cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrObject?.totalDiscountAmount ?? 0.00)
                
                cell.lbetotalMrp.text = String(format: "$%.2f", self.arrObject?.totalMrp ?? 0.00)
            }
            
            if self.isAddressSelected == "Venue" {
                cell.imgViewHome.image = UIImage(named: "uncheck")
                cell.imgViewVenue.image = UIImage(named: "checkic")
                cell.lbeAddress.text = ""
                cell.lbeAddressTitle.text = ""
                
                cell.imgViewHome.isHidden = false
                cell.imgViewVenue.isHidden = false
                
                cell.lbeHomeType.isHidden = false
                cell.lbeVenueType.isHidden = false
                
                
                cell.btnAdd.isHidden = true
                cell.imgViewAddAddress.isHidden = true
                
                cell.btnAdd.isHidden = true
                cell.imgViewAddAddress.isHidden = true
                
                cell.addressView_H_Constraint.constant = 55
                cell.addressView.isHidden = false

            }
            else if self.isAddressSelected == "Home" {
                cell.imgViewHome.image = UIImage(named: "checkic")
                cell.imgViewVenue.image = UIImage(named: "uncheck")
                cell.lbeAddress.text = strAddress
                cell.lbeAddressTitle.text = strAddressType
                
                cell.imgViewHome.isHidden = false
                cell.imgViewVenue.isHidden = false
                
                cell.lbeHomeType.isHidden = false
                cell.lbeVenueType.isHidden = false
                
                
                cell.btnAdd.isHidden = false
                cell.imgViewAddAddress.isHidden = false
                
                cell.btnAdd.isHidden = false
                cell.imgViewAddAddress.isHidden = false
                
                cell.addressView_H_Constraint.constant = 125
                cell.addressView.isHidden = false
            }
            else{
                cell.imgViewHome.isHidden = true
                cell.imgViewVenue.isHidden = true
                cell.lbeAddress.text = ""
                cell.lbeAddressTitle.text = ""
                cell.btnAdd.isHidden = true
                cell.imgViewAddAddress.isHidden = true
                cell.lbeHomeType.isHidden = true
                cell.lbeVenueType.isHidden = true
                cell.addressView_H_Constraint.constant = 10
                cell.addressView.isHidden = true
            }
            
            
          
            cell.arrSortedProduct = arrSortedProduct
            cell.tableViewProduct.reloadData()
                
    
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            var lineCount = CGFloat()
            var totalCount = CGFloat()

            for i in 0 ..< arrSortedService.count {
                
                lineCount = CGFloat(arrSortedService[i].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 185))
                
                if lineCount > 1 {
                    if self.arrSortedService[i].fromTime == "" {
                        totalCount =  totalCount + 190
                    }
                    else{
                        totalCount =  totalCount +   210
                    }
                }
                else{
                    if self.arrSortedService[i].fromTime == "" {
                        totalCount =  totalCount  +   160
                    }
                    else{
                        totalCount =  totalCount  +   180
                        
                    }
                }
            }
            return 170 + totalCount
        }
        else{
            var sizeFonts = CGFloat()
            var lineCount = CGFloat()
            var totalCount = CGFloat()
            
            if strAddress != "" {
                sizeFonts  = strAddress.heightForView(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(13)) ?? UIFont.systemFont(ofSize: 15.0), width: self.view.frame.width - 65)
            }
            
            for i in 0 ..< arrSortedProduct.count {
                
                lineCount = CGFloat(arrSortedProduct[i].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(17)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 185))
                
                if lineCount > 1 {
                    totalCount = totalCount +  170
                    
                }
                else{
                    totalCount = totalCount +  150
                    
                }
            }
            
            if self.isAddressSelected == "Venue" {
                return 170 + totalCount + 55

            }
            else if self.isAddressSelected == "Home" {
                return 170 + totalCount + 120

            }
            else{
                return 170 + totalCount + 10

                }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if self.arrSortedService.count > 0{
                return 30
                
            }
            return 0.1
        case 1:
            if self.arrSortedProduct.count > 0{
                return 30
                
            }
            return 0.1
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.1
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView {
        case tableViewMyCart:
            let cell = tableViewMyCart.dequeueReusableCell(withIdentifier: "DashSectionTableViewCell") as! DashSectionTableViewCell
            switch section {
            case 0:
                cell.titleLabel.text = "Severcies"
                
            case 1:
                cell.titleLabel.text = "Products"
            default:
                return nil
            }
            return cell
    
        default:
            return nil
        }
    }



      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
   
      }
    
    
}
