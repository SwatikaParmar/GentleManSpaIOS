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
    var arrGetProfessionalList = [GetProfessionalObject]()

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
  
            return arrGetProfessionalList.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: ProductHomeCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCollCell", for: indexPath) as! ProductHomeCollCell
        
           
         
            
            let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat("".dynamicFontSize(13.5))) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
            cell.titleLabel.font = actionTitleFont
            
            cell.titleLabel.text = (arrGetProfessionalList[indexPath.row].firstName ?? "") + " " + (arrGetProfessionalList[indexPath.row].lastName ?? "")
            
            let width = (UIScreen.main.bounds.size.width/3)
            
            if Utility.shared.DivceTypeString() == "IPad" {
                cell.widthImage.constant = 104
                cell.heightImage.constant = 104
            }
            else{
                cell.widthImage.constant = 104
                cell.heightImage.constant = 104
            }
          
            
              
            if let imgUrl = arrGetProfessionalList[indexPath.row].profilepic,!imgUrl.isEmpty {
                
                let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
                let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                cell.imageV?.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                    if (error != nil) {
                        cell.imageV.image = UIImage(named: "placeholder_Male")
                    } else {
                        cell.imageV.image = image
                       
                    }
                }
                
            } else {
                    cell.imageV.image = UIImage(named: "placeholder_Male")
            }
        
            
           return cell
}
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    let width = (collectionView.size.width/3)
    var size = CGSize(width: 125, height: width + 45)
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
        let controller:ProfessionalServicesVc =  UIStoryboard(storyboard: .User).initVC()
        controller.name = (arrGetProfessionalList[indexPath.row].firstName ?? "") + " " + (arrGetProfessionalList[indexPath.row].lastName ?? "")
        if let imgUrl = arrGetProfessionalList[indexPath.row].profilepic,!imgUrl.isEmpty {
            
            let imagePath = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
            let urlString = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            controller.imgUser = urlString
        }
        controller.arrayData  = arrGetProfessionalList[indexPath.row].object?.arrayData ?? NSArray()
        controller.professionalDetailId  = arrGetProfessionalList[indexPath.row].object?.professionalDetailId ?? 0

        self.lastClass.parent?.navigationController?.pushViewController(controller, animated: true)
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
