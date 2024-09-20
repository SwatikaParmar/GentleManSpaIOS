//
//  HomeUTableView.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 20/07/24.
//

import Foundation
import UIKit


extension HomeUserViewController: UITableViewDataSource,UITableViewDelegate,CategorySelectDelegate {
    func cateSelect(_ id: Int, _ name: String) {
       
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "CategoryHomeTvCell") as! CategoryHomeTvCell
            cell.arrSortedCategory = self.arrSortedCategory 
            cell.delegateCate = self
            cell.lastClass = self.parent ?? self
            cell.isHome =  true
            
            DispatchQueue.main.async(execute: cell.collectionViewCate.reloadData)
            return cell
            
        }
        if indexPath.section == 1 {
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "HomeBannerTvCell") as! HomeBannerTvCell

            cell.arrayHomeBannerModel = self.arrayHomeBannerModel
            
            cell.pageController.pageIndicatorTintColor = UIColor.darkGray
            cell.pageController.currentPageIndicatorTintColor = UIColor.black
            cell.pageController.numberOfPages = self.arrayHomeBannerModel.count
            cell.pageController.currentPage = 0
            cell.collectionVB.reloadData()
            return cell
            
          
        }
        if indexPath.section == 2 {
            
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "CategoryHomeTvCell") as! CategoryHomeTvCell
            cell.arrSortedCategory = self.arrSortedCategory 
            cell.delegateCate = self
            cell.lastClass = self.parent ?? self
            cell.isHome =  true
            cell.collectionViewCate.delegate = cell
            cell.collectionViewCate.dataSource = cell
            DispatchQueue.main.async(execute: cell.collectionViewCate.reloadData)
            
            return cell

        }
        
        if indexPath.section == 3 {
            
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "ProductCategoriesCell") as! ProductCategoriesCell
            cell.arrSortedCategory = self.arrSortedProductCategories
            cell.lastClass = self.parent ?? self
            cell.isHome =  true
            cell.collectionViewCate.delegate = cell
            cell.collectionViewCate.dataSource = cell
            DispatchQueue.main.async(execute: cell.collectionViewCate.reloadData)
            
            return cell

        }
        
        if indexPath.section == 4 {
            
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
            cell.lastClass = self.parent ?? self
            cell.isHome =  true
            cell.arrGetProfessionalList = self.arrGetProfessionalList
            cell.collectionViewCate.delegate = cell
            cell.collectionViewCate.dataSource = cell
            DispatchQueue.main.async(execute: cell.collectionViewCate.reloadData)
            
            return cell

        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //            let controller:MyAppointmentVc =  UIStoryboard(storyboard: .Dashboard).initVC()
        //            self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        }
        if indexPath.section == 1 {
            return 200
        }
        if indexPath.section == 2 {
            var width = (UIScreen.main.bounds.size.width/3)
            width = width - 35 + 62
            
            if arrSortedCategory.count > 0 {
                let result = Int(arrSortedCategory.count) % 3
                if result == 0 {
                    let count = Int(arrSortedCategory.count) / 3
                    return CGFloat(count * Int(width)) + 45
                }
                else{
                    var count = Int(arrSortedCategory.count) / 3
                    count = count + 1
                    return CGFloat(count * Int(width)) + 45
                    
                }
            }
            return  300
        }
        
        if indexPath.section == 3 {
            var width = (UIScreen.main.bounds.size.width/3)
            width = width - 35 + 45
            if arrSortedProductCategories.count > 0 {
                let result = Int(arrSortedProductCategories.count) % 3
                if result == 0 {
                    let count = Int(arrSortedProductCategories.count) / 3
                    return CGFloat(count * Int(width)) + 45
                }
                else{
                    var count = Int(arrSortedProductCategories.count) / 3
                    count = count + 1
                    return CGFloat(count * Int(width)) + 45
                    
                }
            }
            return  300
        }
        
        if indexPath.section == 4 {
            
          
            return 225

           
        }
        
        return 0
    }
        
       
    
}

