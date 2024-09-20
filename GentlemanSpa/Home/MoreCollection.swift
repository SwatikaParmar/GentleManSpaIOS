//
//  MoreCollection.swift
//  Maxemus
//
//  Created by AbsolveTech on 13/06/24.
//

import Foundation
import UIKit


extension ServicesViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSortedCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubProductDetailCV", for: indexPath) as! SubProductDetailCV
        
        if indexInt == indexPath.row {
            cell.vwRound.backgroundColor = UIColor.white
            cell.lblProducTitle.textColor = UIColor.black
        }
        else{
            cell.vwRound.backgroundColor = UIColor.clear
            cell.lblProducTitle.textColor = UIColor.white

        }
        
        cell.lblProducTitle.text = arrSortedCategory[indexPath.row].categoryName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvHeader.frame.size.width, height: cvHeader.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        indexInt = indexPath.row
        self.cvHeader.reloadData()
        self.cvHeader.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      
        
        self.serviceAPI(false, true, "",arrSortedCategory[indexPath.row].mainCategoryId,self.genderPreferences, 0)

     }
}



class SubProductDetailCV: UICollectionViewCell {
    
    @IBOutlet var lblProducTitle: UILabel!
    @IBOutlet var vwRound: UIView!
    
}


extension ProductListViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSortedCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubProductDetailCV", for: indexPath) as! SubProductDetailCV
        
        if indexInt == indexPath.row {
            cell.vwRound.backgroundColor = UIColor.white
            cell.lblProducTitle.textColor = UIColor.black
        }
        else{
            cell.vwRound.backgroundColor = UIColor.clear
            cell.lblProducTitle.textColor = UIColor.white

        }
        
        cell.lblProducTitle.text = arrSortedCategory[indexPath.row].categoryName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvHeader.frame.size.width, height: cvHeader.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        indexInt = indexPath.row
        self.cvHeader.reloadData()

        self.cvHeader.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.productAPI(false, true, "",arrSortedCategory[indexPath.row].mainCategoryId,self.genderPreferences, 0)

     }
}
