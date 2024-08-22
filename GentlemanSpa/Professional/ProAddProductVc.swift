//
//  ProAddProductVc.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 21/08/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos

class ProAddProductVc: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var productCollection : UICollectionView!
    @IBOutlet weak var txt_Name : CocoaTextField!
    @IBOutlet weak var txt_basePrice : CocoaTextField!
    @IBOutlet weak var txt_listingPrice : CocoaTextField!
    @IBOutlet weak var txt_stock : CocoaTextField!
    @IBOutlet weak var txt_CategoryName : CocoaTextField!

    @IBOutlet weak var txt_View : UITextView!
    var productId = 34;

    var logoImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle(to: txt_Name)
        txt_Name.placeholder = "Product Name"
        
        applyStyle(to: txt_CategoryName)
        txt_CategoryName.placeholder = "Category Name"
        
        txt_basePrice.delegate = self
        txt_basePrice.keyboardType = .decimalPad
        applyStyle(to: txt_basePrice)
        txt_basePrice.placeholder = "Base Price"
        
        txt_listingPrice.delegate = self
        txt_listingPrice.keyboardType = .decimalPad
        
        applyStyle(to: txt_listingPrice)
        txt_listingPrice.placeholder = "Listing Price"
        
      
        
        applyStyle(to: txt_stock)
        txt_stock.placeholder = "In Stock"
        
        txt_stock.delegate = self
        txt_stock.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func Close(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    @IBAction func addProduct(_ sender: Any) {
        
        uploadProfileImageApi()
    }
    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        if logoImages.count == 0 {
            return
        }
        
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        let apiURL = String("\("Base".UploadProductImage)")


        AlamofireRequest().uploadImageArray(urlString: apiURL, pictures: logoImages, name: fileName , userID: String(productId)){ data, error -> Void in
            
            
            if !data!.isEmpty{
                if data == "failure"{
                    NotificationAlert().NotificationAlert(titles: "Uploaded successfully.")

                }
                else{
                    UserDefaults.standard.set(data ?? "iOS", forKey: Constants.userImg)
                    UserDefaults.standard.synchronize()
                    
                    NotificationAlert().NotificationAlert(titles: "Uploaded successfully.")
                }
               
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txt_listingPrice == textField || txt_basePrice == textField {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.index(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        return true
    }
    
}


extension ProAddProductVc:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
            return logoImages.count + 1
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell: ProductImageCvCall = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCvCall", for: indexPath) as! ProductImageCvCall
    
            
            if indexPath.row == 0{
                cell.cellViewRound.isHidden = true
                cell.cancelBtn.isHidden = true
                cell.imageV.contentMode = .center
                cell.imageV.image = UIImage(named: "add+")

            }
            else{
                cell.cellViewRound.isHidden = false
                cell.cancelBtn.isHidden = false
                cell.imageV.contentMode = .scaleAspectFill
                
                cell.imageV.image = logoImages[indexPath.row - 1]

            }
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)

           return cell
}
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (collectionView.size.width/3)
        var size = CGSize(width: width, height: width - 3)
        if Utility.shared.DivceTypeString() == "IPad" {
            size = CGSize(width: width, height: 340)
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
       
        if indexPath.row == 0 {
            addImage()
        }
    }
    
    
     @objc func connected(sender: UIButton){

         logoImages.remove(at: sender.tag - 1)
         productCollection.reloadData()
        
    }
  }



class ProductImageCvCall: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cellViewRound: UIView!


}
extension ProAddProductVc: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func addImage(){
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let takePic = UIAlertAction(title: "Take Photo", style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraAccess()
        })
        let choseAction = UIAlertAction(title: "Choose from Library",style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPickerController.modalPresentationStyle = .fullScreen
            self.present(myPickerController, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePic)
        optionMenu.addAction(choseAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
              //  popoverController.sourceView = sender
             //   popoverController.sourceRect = sender.bounds
            }
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            print("Authorized, proceed")
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerController.SourceType.camera
                myPickerController.modalPresentationStyle = .fullScreen
                myPickerController.showsCameraControls = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = UIImagePickerController.SourceType.camera
                        myPickerController.modalPresentationStyle = .fullScreen
                        myPickerController.showsCameraControls = true
                        self.present(myPickerController, animated: true, completion: nil)
                    }
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            }
        default:
            self.alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        
        let alert = UIAlertController(
            title: "Alert",
            message: "App requires to access your camera to capture image on your business profile and service.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage else { return }
        
        
        logoImages.append(originalImage)
        productCollection.reloadData()

        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
