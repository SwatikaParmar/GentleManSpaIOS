//
//  ProductCategoryViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 26/08/24.
//

import UIKit

class ProductCategoryViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    var arrSortedCategory = [ProductCategoriesObject]()
    var arrSortedCategoryMore = [ProductCategoriesObject]()
    var selectid = Int()
    var selectName = String()

    @IBOutlet weak var tblCate : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        categoryAPI()

    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        if selectName.count > 0 {
            NotificationCenter.default.post(name: Notification.Name("ProductCategory_Push_Action"), object: nil, userInfo: ["name":selectName,"selectid": selectid])
            dismiss(animated: true)
        }
        else{
            MessageAlert(title:"Alert",message: "Please select Product Category")
            return
        }
      

    }
    
    //MARK: - Category API
    func categoryAPI(){
        
        let params = [ "spaDetailId": 21
        ] as [String : Any]
        
        ProductCategoriesRequest.shared.ProductCategoriesRequestAPI(requestParams:params, true) { (arrayData,message,isStatus) in
            if isStatus {
                if arrayData != nil{
                    self.arrSortedCategoryMore = arrayData ?? self.arrSortedCategoryMore
                 
                    
                    if self.arrSortedCategoryMore.count > 0 {
                        self.tblCate.reloadData()

                        
                    }
                }
                else{
                    self.arrSortedCategoryMore.removeAll()
                    self.tblCate.reloadData()
                }
            }
            else{
                self.arrSortedCategoryMore.removeAll()
                
                self.tblCate.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
   
        return arrSortedCategoryMore.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableCell") as! CountriesTableCell
        
        cell.lbeName.text = arrSortedCategoryMore[indexPath.row].categoryName
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeFont = CGFloat()
           
        if arrSortedCategoryMore.count > indexPath.row {
            
            sizeFont  = arrSortedCategoryMore[indexPath.row].categoryName?.lineCount(text: "", font: UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(15)) ?? UIFont.systemFont(ofSize: 15.0), width:tableView.frame.size.width - 30) ?? 10
            
            
        }
        return sizeFont * 20 + 40
           
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        selectName = arrSortedCategoryMore[indexPath.row].categoryName ?? ""
        selectid = arrSortedCategoryMore[indexPath.row].mainCategoryId

        
        NotificationCenter.default.post(name: Notification.Name("ProductCategory_Push_Action"), object: nil, userInfo: ["name":selectName,"selectid": selectid])
        dismiss(animated: true)
        }
    }

