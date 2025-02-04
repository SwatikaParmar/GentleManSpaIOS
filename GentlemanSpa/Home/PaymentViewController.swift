//
//  PaymentViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 03/02/25.
//

import UIKit
@preconcurrency import WebKit

class PaymentViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var webAbout: WKWebView!
    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    
    var paymentUrl: String = ""
    var paymentId: Int = 0

    
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        webAbout.navigationDelegate = self
        webAbout.uiDelegate = self
        
        if let url = URL(string: paymentUrl) {
                webAbout.load(URLRequest(url: url))
        }
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
 
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
            if let url = navigationAction.request.url {
                print(url)
                if url.absoluteString.contains("OrderConfirmation?paymentId") {
                    paymentIdAPI(true)
                    decisionHandler(.cancel)
                }
                else  if url.absoluteString.contains("cancelpay.com") {
                    decisionHandler(.cancel)
                }
                else  if url.absoluteString.contains("legal") {
                    decisionHandler(.cancel)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else  if url.absoluteString.contains("privacy") {
                    decisionHandler(.cancel)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else{
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        
    }
    
    func paymentIdAPI(_ isLoader:Bool){
        var params = [ "paymentId": paymentId
        ] as [String : Any]
        OrderConfirmationRequest.shared.OrderConfirmationRequestAPI(requestParams:params, isLoader) { [self] (arrayData,arrayService,message,isStatus) in
            if isStatus {
                
                if arrayData == "Paid"{
                    bookingAPI()
                }
                else {
                    NotificationAlert().NotificationAlert(titles: "Payment Failed")

                }
               
            }
            else {
                NotificationAlert().NotificationAlert(titles: "Payment Failed")

            }
        }
    }
    
    
    func bookingAPI() {

       let Model = [
           "customerAddressId": 0,
           "deliveryType": "AtVenue",
           "paymentId": paymentId,
           "paymentType":  "Online"] as [String : Any]
 
        BookAppointmentRequest.shared.bookingAPI(requestParams: Model) { (user,message,isStatus) in
               if isStatus {
                   let controller:OrderPlaceViewController =  UIStoryboard(storyboard: .User).initVC()
                   controller.providesPresentationContextTransitionStyle = true
                   controller.definesPresentationContext = true
                   controller.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
                   self.present(controller, animated: true, completion: nil)
                   
               }
           }
       }
        
}
