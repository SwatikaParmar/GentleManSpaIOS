//
//  OrderDetailsExtension.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 18/10/24.
//

import Foundation
import UIKit

extension OrderDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.servicesArray.count > 0{
                return 1

           }
            return 0
        }
        if section == 1 {
            if self.arrOrderArray.count > 0{
                return 1

           }
            return 0
        }
        return 1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesOrderDetailsTableViewCell") as! ServicesOrderDetailsTableViewCell
            cell.arrSortedService = servicesArray
            cell.tableViewServices.reloadData()
            cell.lastClass = self
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOrderDetailsTableViewCell") as! ProductOrderDetailsTableViewCell
            cell.arrSortedProduct = productsArray
            cell.tableViewProduct.reloadData()
            return cell
        }
        else{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataOrderDetailTVCell") as! DataOrderDetailTVCell
            if arrOrderArray.count != 0 {
                
             //   cell.lbetotalDiscountAmount.text = String(format: "%.2f", self.arrOrderArray[0].totalDiscount ?? 0.00)
                
            //    cell.lbetotalDiscount.text = String(format: "-$%.2f",self.arrOrderArray[0].totalDiscountAmount ?? 0.00)
                
                cell.lbeTotalAmount.text = String(format: "$%.2f", self.arrOrderArray[0].totalAmount)
                cell.lbeOrderStatus.text = String(format: "%@", self.arrOrderArray[0].orderStatus)
                
                cell.lbeOrderDate.text  =  String(format: "%@",self.arrOrderArray[0].orderDate.dobDateToDateString)


                
            }
            return cell

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            var lineCount = CGFloat()
            var totalCount = CGFloat()

            for i in 0 ..< servicesArray.count {
                
                lineCount = CGFloat(servicesArray[i].serviceName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 185))
                
                if lineCount > 1 {
                    if self.servicesArray[i].fromTime == "" {
                        totalCount =  totalCount + 165
                    }
                    else{
                        totalCount =  totalCount +   165
                    }
                }
                else{
                    if self.servicesArray[i].fromTime == "" {
                        totalCount =  totalCount  +   145
                    }
                    else{
                        totalCount =  totalCount  +   145
                        
                    }
                }
            }
            return 32 + totalCount
        }
        else  if indexPath.section == 1{
            var lineCount = CGFloat()
            var totalCount = CGFloat()
            
          
            for i in 0 ..< productsArray.count {
                
                lineCount = CGFloat(productsArray[i].productName.lineCount(text: "", font: UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width: tableView.frame.width - 185))
                
                if lineCount > 1 {
                    totalCount = totalCount +  145
                    
                }
                else{
                    totalCount = totalCount +  130
                    
                }
            }
            return 20 + totalCount
        }
        
        else{
            return 140
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if self.servicesArray.count > 0{
                return 30
                
            }
            return 0.1
        case 1:
            if self.productsArray.count > 0{
                return 30
                
            }
            return 0.1
        case 2:
            if self.arrOrderArray.count > 0{
                return 40
                
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
        case tableViewOrderDetails:
            let cell = tableViewOrderDetails.dequeueReusableCell(withIdentifier: "DashSectionTableViewCell") as! DashSectionTableViewCell
            switch section {
            case 0:
                cell.titleLabel.text = "Severcies"
                
            case 1:
                cell.titleLabel.text = "Products"
                
            case 2:
                cell.titleLabel.text = "Order Summary"
                
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
