//
//  CategoryHomeTvCell.swift
//  SalonApp
//
//  Created by AbsolveTech on 09/01/24.
//

import UIKit
protocol CategorySelectDelegate {
    func cateSelect(_ id:Int, _ name:String)
    
}
class CategoryHomeTvCell: UITableViewCell {

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

extension CategoryHomeTvCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
            return arrSortedCategory.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: DashCategoryHomeCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashCategoryHomeCollCell", for: indexPath) as! DashCategoryHomeCollCell
        
                if let imgUrl = arrSortedCategory[indexPath.row].categoryImage,!imgUrl.isEmpty {
                    
                    let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                    let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    cell.imageV?.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                        if (error != nil) {
                            cell.imageV.image = UIImage(named: "shopPlace")
                        } else {
                            cell.imageV.image = image
                           
                        }
                    }
                    
                } else {
                   
                        cell.imageV.image = UIImage(named: "shopPlace")
                }
            
            if indexPath.row == unitsIndex {
                
                let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(13.5))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
                cell.titleLabel.font = actionTitleFont
                
            }
            else{
                
                let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(13.5))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
                cell.titleLabel.font = actionTitleFont
                
            }
            cell.titleLabel.text = arrSortedCategory[indexPath.row].categoryName
            
            let width = (UIScreen.main.bounds.size.width/3)
            
            if Utility.shared.DivceTypeString() == "IPad" {
                cell.widthImage.constant = width - 50
                cell.heightImage.constant = width - 50
            }
            else{
                cell.widthImage.constant = width - 35
                cell.heightImage.constant = width - 35
            }
              
            
           return cell
}
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    let width = (collectionView.size.width/3)
    
    var height = (UIScreen.main.bounds.size.width/3)
    height = height - 35 + 62
    
    var size = CGSize(width: width, height: height )
    
    if Utility.shared.DivceTypeString() == "IPad" {
         size = CGSize(width: width, height: height)
    }

    return size
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller:ServicesViewController =  UIStoryboard(storyboard: .User).initVC()
        controller.indexInt = indexPath.row
        self.lastClass.parent?.navigationController?.pushViewController(controller, animated: true)
    }
  }



class DashCategoryHomeCollCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellViewRound: UIView!
    @IBOutlet weak var cellViewRoundBG: UIView!
    @IBOutlet weak var cateView: UIViewX!
    
    @IBOutlet weak var widthImage: NSLayoutConstraint!
    @IBOutlet weak var heightImage: NSLayoutConstraint!

}
