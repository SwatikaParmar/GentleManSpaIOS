//
//  ServiceDetailImageCollection.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 02/08/24.
//
import UIKit
import Foundation
extension ServiceDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in cvHeader.visibleCells {
            self.myPageCntrl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if arrSortedService?.serviceImageArray.count == 0 {
                myPageCntrl.numberOfPages  = 0
                return 1
            }
            else if arrSortedService?.serviceImageArray.count == 1 {
                myPageCntrl.numberOfPages  = 0

            }
            else {
                myPageCntrl.numberOfPages  = arrSortedService?.serviceImageArray.count ?? 0
            }
            return arrSortedService?.serviceImageArray.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDescriptionCVC", for: indexPath) as! ProductDescriptionCVC
        
        if arrSortedService?.serviceImageArray != nil {
            if arrSortedService?.serviceImageArray.count == 0 {
                cell.imgProduct.image = UIImage(named: "placeholder")
                return cell
            }
            if let imgUrl = arrSortedService?.serviceImageArray[indexPath.row] {
                
                let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell.imgProduct?.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                    if (error != nil) {
                        cell.imgProduct.image = UIImage(named: "placeholder")
                    } else {
                        cell.imgProduct.image = image
                    }
                }
            } else {
                cell.imgProduct.image = UIImage(named: "placeholder")
            }
        }
        else{
            cell.imgProduct.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvHeader.frame.size.width, height: cvHeader.frame.size.height)
    }
}
class ProductDescriptionCVC: UICollectionViewCell {
    
    @IBOutlet var imgProduct: UIImageView!

}
extension ProductDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in cvHeader.visibleCells {
            self.myPageCntrl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if arrSortedService?.serviceImageArray.count == 0 {
                myPageCntrl.numberOfPages  = 0
                return 1
            }
            else if arrSortedService?.serviceImageArray.count == 1 {
                myPageCntrl.numberOfPages  = 0

            }
            else {
                myPageCntrl.numberOfPages  = arrSortedService?.serviceImageArray.count ?? 0
            }
            return arrSortedService?.serviceImageArray.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDescriptionCVC", for: indexPath) as! ProductDescriptionCVC
        
        if arrSortedService?.serviceImageArray != nil {
            if arrSortedService?.serviceImageArray.count == 0 {
                cell.imgProduct.image = UIImage(named: "placeholder")
                return cell
            }
            if let imgUrl = arrSortedService?.serviceImageArray[indexPath.row] {
                
                let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell.imgProduct?.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                    if (error != nil) {
                        cell.imgProduct.image = UIImage(named: "placeholder")
                    } else {
                        cell.imgProduct.image = image
                    }
                }
            } else {
                cell.imgProduct.image = UIImage(named: "placeholder")
            }
        }
        else{
            cell.imgProduct.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cvHeader.frame.size.width, height: cvHeader.frame.size.height)
    }
}
