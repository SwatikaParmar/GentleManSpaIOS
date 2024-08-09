//
//  ProductCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 31/07/24.
//

import UIKit

class ProductCell: UITableViewCell {
    
    var arrSortedCategory = [dashboardCategoryObject]()
    var delegateCate :CategorySelectDelegate!
    var unitsIndex = 0
    var lastClass = UIViewController()
    var shopId = 0
    var salonName = ""
    var categoryId = 0
    var genderStr = ""
    var isHome = false
   
    @IBOutlet weak var collectionViewCate: UICollectionView!
    @IBOutlet weak var lbeTop: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewCate.delegate = self
        collectionViewCate.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension ProductCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
            return 10
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: ProductHomeCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollCell", for: indexPath) as! ProductHomeCollCell
        
           
            
            if indexPath.row == unitsIndex {
                
                let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(16))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
                cell.titleLabel.font = actionTitleFont
                
            }
            else{
                
                let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(16))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
                cell.titleLabel.font = actionTitleFont
                
            }
            cell.titleLabel.text = "Product 1"
            
            let width = (UIScreen.main.bounds.size.width/2)
            
            if Utility.shared.DivceTypeString() == "IPad" {
                cell.widthImage.constant = width - 50
                cell.heightImage.constant = width - 50
            }
            else{
                cell.widthImage.constant = width - 45
                cell.heightImage.constant = width - 45
            }
              
            
           return cell
}
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    let width = (collectionView.size.width/2)
    var size = CGSize(width: width - 10, height: width + 45)
    if Utility.shared.DivceTypeString() == "IPad" {
         size = CGSize(width: width, height: 340)
    }

    return size
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let controller:ServicesViewController =  UIStoryboard(storyboard: .User).initVC()
      //  self.lastClass.parent?.navigationController?.pushViewController(controller, animated: true)
    }
  }



class ProductHomeCollCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellViewRound: UIView!
    @IBOutlet weak var cellViewRoundBG: UIView!
    @IBOutlet weak var cateView: UIViewX!
    
    @IBOutlet weak var widthImage: NSLayoutConstraint!
    @IBOutlet weak var heightImage: NSLayoutConstraint!

}
