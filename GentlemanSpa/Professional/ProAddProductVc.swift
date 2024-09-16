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
import IQKeyboardManagerSwift
import SDWebImage
class ProAddProductVc: UIViewController ,UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var productCollection : UICollectionView!
    @IBOutlet weak var txt_Name : CocoaTextField!
    @IBOutlet weak var txt_basePrice : CocoaTextField!
    @IBOutlet weak var txt_listingPrice : CocoaTextField!
    @IBOutlet weak var txt_stock : CocoaTextField!
    @IBOutlet weak var txt_CategoryName : CocoaTextField!

    @IBOutlet weak var txt_View : IQTextView!
    @IBOutlet weak var collection_H_Const: NSLayoutConstraint!
    @IBOutlet weak var titleLbe : UILabel!
    @IBOutlet weak var btnAdd : UIButton!

    var productId = 0; 
    var productCategoryId = 0;
    var logoImages = [UIImage]()
    var isImageAdd = false
    var trimmedName = ""
    var trimmedCate = ""
    var trimmedBase = ""
    var trimmedListing = ""
    var trimmedStock = ""
    var arrSortedProduct:ProductDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_View.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(14)) ?? UIFont.systemFont(ofSize: 15.0)
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
        
        txt_View.delegate = self

        applyStyle(to: txt_stock)
        txt_stock.placeholder = "In Stock"
        
        txt_stock.delegate = self
        txt_stock.keyboardType = .numberPad
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Category_Push_Action(_:)), name: NSNotification.Name(rawValue: "ProductCategory_Push_Action"), object: nil)
        
        if productId > 0 {
            pDetailAPI(true)
            titleLbe.text = "Update Product"
            btnAdd.setTitle("Update", for: .normal)

        }

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text?.count ?? 0 == 0{
            if text == "\n"{
                return false
            }
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 400
    }
    
    
    @objc func Category_Push_Action(_ notification: NSNotification) {
       
        if let array = notification.userInfo?["name"] as? String {
            
            txt_CategoryName.text = array
            
            if let selectid = notification.userInfo?["selectid"] as? Int {
                productCategoryId = selectid
                
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func Close(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    
    @IBAction func subCate(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "Professional", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ProductCategoryViewController") as?  ProductCategoryViewController
        controller!.modalPresentationStyle = .overFullScreen
        self.present(controller!, animated: true, completion: nil)
    }
    
    
    @IBAction func addProduct(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if logoImages.count == 0 {
            MessageAlert(title:"Alert",message: "Please select at least one image")
            return
        }
        
        trimmedName = txt_Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedCate = txt_CategoryName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedBase = txt_basePrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedListing = txt_listingPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        trimmedStock = txt_stock.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        
        if (trimmedName.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter product name")
            return
        }
        
        if (trimmedCate.isEmpty){
            MessageAlert(title:"Alert",message: "Please select category name")
            return
        }
        
        if (trimmedBase.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter base price")
            return
        }
        
        
        if (trimmedListing.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter listing price")
            return
        }
        
        if Double(trimmedBase) ?? 0 >=  Double(trimmedListing) ?? 0 {
            
        }
        else{
            MessageAlert(title:"Alert",message: "Please enter listing price less than base price")
            return
        }
        
        
        if (trimmedStock.isEmpty){
            MessageAlert(title:"Alert",message: "Please enter in stock count")
            return
        }
        
        
        if productId == 0 {
            
            
            let params = ["mainCategoryId": productCategoryId,
                          "subCategoryId":2 ,
                          "name": trimmedName,
                          "description":txt_View.text ?? "",
                          "basePrice": Double(trimmedBase) ?? 0,
                          "listingPrice": Double(trimmedListing) ?? 0,
                          "createdBy": userId(),
                          "spaDetailId": 21,
                          "stock": Int(trimmedStock) ?? 1
                          
            ] as [String : Any]
            
            
            ProAddProductRequest.shared.AddProductRequest(requestParams: params) { (productId, msg, success,Verification) in
                
                if success == false {
                    
                    self.MessageAlert(title: "Alert", message: msg!)
                    
                }
                else
                {
                    self.productId = productId ?? 0
                    self.uploadProfileImageApi()
                    
                }
            }
        }
        else{
            let params = ["mainCategoryId": productCategoryId,
                          "productId" : productId,
                          "subCategoryId":2 ,
                          "name": trimmedName,
                          "description":txt_View.text ?? "",
                          "basePrice": Double(trimmedBase) ?? 0,
                          "listingPrice": Double(trimmedListing) ?? 0,
                          "createdBy": userId(),
                          "spaDetailId": 21,
                          "stock": Int(trimmedStock) ?? 1
                          
            ] as [String : Any]
            
            
            ProUpdateProductRequest.shared.ProUpdateProduct(requestParams: params) { (productId, msg, success,Verification) in
                
                if success == false {
                    
                    self.MessageAlert(title: "Alert", message: msg!)
                    
                }
                else
                {
                    if self.isImageAdd {
                        self.uploadProfileImageApi()
                    }
                    else{
                        NotificationAlert().NotificationAlert(titles: "Product Updated successfully.")
                    }
                    
                }
            }
        }
    }

    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        let apiURL = String("\("Base".UploadProductImage)")


        AlamofireRequest().uploadImageArray(urlString: apiURL, pictures: logoImages, name: fileName , userID: String(productId)){ data, error -> Void in
            
            
            if !data!.isEmpty{
                if data == "failure"{
                    
                    NotificationAlert().NotificationAlert(titles: "Product added successfully.")

                }
                else{
                    NotificationAlert().NotificationAlert(titles: "Product added successfully.")
                }
               
            }
            
        }
        
    }
    
    
    
    func pDetailAPI(_ isLoader:Bool){
        let params = [ "id": productId] as [String : Any]
        ProductDetailRequest.shared.ProductDetailRequestAPI(requestParams:params, isLoader) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedProduct = arrayData
                    
                    for i in 0..<(self.arrSortedProduct?.serviceImageArray.count ?? 0) {
                        let imgV = UIImageView()
                        let img  = "\(GlobalConstants.BASE_IMAGE_URL)\(self.arrSortedProduct?.serviceImageArray[i] ?? "")"
                            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        imgV.sd_setImage(with: URL.init(string:(urlString))) { (image, error, cache, urls) in
                            if (error != nil) {
                            } else {
                                self.logoImages.append(image ?? UIImage())
                            }
                        }
                
                        self.productCollection.reloadData()
                        
                    }
                    
                    
                    self.txt_Name.text = self.arrSortedProduct?.serviceName.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                 //   self.trimmedCate = txt_CategoryName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    self.txt_basePrice.text = String(self.arrSortedProduct?.basePrice ?? 0).trimmingCharacters(in: .whitespacesAndNewlines)
                    self.txt_listingPrice.text = String(self.arrSortedProduct?.listingPrice ?? 0).trimmingCharacters(in: .whitespacesAndNewlines)
                    self.txt_stock.text = String(self.arrSortedProduct?.stock ?? 0).trimmingCharacters(in: .whitespacesAndNewlines)
                    self.txt_View.text = String(self.arrSortedProduct?.serviceDescription ?? "")
                    
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
            if let dotIndex = newText.firstIndex(of: ".") {
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
            if logoImages.count > 4 {
                MessageAlert(title:"Alert",message: "You have exceeded selection limit")
                return
            }
            else{
                addImage()
            }
          
        }
    }
    
    
     @objc func connected(sender: UIButton){

         logoImages.remove(at: sender.tag - 1)
         productCollection.reloadData()
         isImageAdd = true
         if logoImages.count > 2 {
             collection_H_Const.constant = 260
         }
         else{
             collection_H_Const.constant = 130
         }
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
        
        if logoImages.count > 2 {
            collection_H_Const.constant = 260
        }
        else{
            collection_H_Const.constant = 130

        }
        isImageAdd = true

            

        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
