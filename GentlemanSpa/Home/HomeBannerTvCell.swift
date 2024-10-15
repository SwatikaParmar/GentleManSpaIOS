//
//  HomeBannerTvCell.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 23/07/24.
//

import UIKit
import Foundation
import SDWebImage

class HomeBannerTvCell: UITableViewCell {

    var counter = 0
    @IBOutlet weak var collectionVB: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    var timer = Timer()
    var arrayHomeBannerModel = [HomeBannerModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)

    }
    func stopTimer() {
        guard timer != nil else { return }
        timer.invalidate()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
extension HomeBannerTvCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @objc func changeImage() {
        if counter < arrayHomeBannerModel.count {
        let index = IndexPath.init(item: counter, section: 0)
             self.collectionVB.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
             self.pageController.currentPage = self.counter
             self.counter += 1

            
         } else {
             
             if arrayHomeBannerModel.count > 0 {
                 counter = 0
                 let index = IndexPath.init(item: counter, section: 0)
                 self.collectionVB.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                 pageController.currentPage = counter
                 counter = 1
            }
        }
    }

  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionVB.visibleCells {
            let indexPath = collectionVB.indexPath(for: cell)
            pageController.currentPage = indexPath?.row ?? counter
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayHomeBannerModel.count
    }
    
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
      let cell: HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
  
       cell.cellViewRound.layer.cornerRadius = 18
       cell.imageV.layer.cornerRadius = 18
       cell.imageV.image = UIImage(named: "banneric")
       
       if let imgUrl = arrayHomeBannerModel[indexPath.row].featureBannerImage,!imgUrl.isEmpty {
           let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(imgUrl)"
           let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
           cell.imageV?.sd_setImage(with: URL.init(string:(urlString )),
                                    placeholderImage: UIImage(named: "banneric"),
                                    options: .refreshCached,
                                    completed: nil)
       }
  
     
    return cell
}

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
        let size = CGSize(width:  (UIScreen.main.bounds.size.width), height: collectionView.frame.size.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
class HomeBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var cellViewRound: UIView!
}
