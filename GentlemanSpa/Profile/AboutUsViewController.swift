//
//  AboutUsViewController.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 28/10/24.
//

import UIKit
@preconcurrency import WebKit

class AboutUsViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webAbout: WKWebView!
    
    @IBOutlet weak var specialityConst: NSLayoutConstraint!

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    func topViewLayout(){
        if !HomeUserViewController.hasSafeArea{
            if view_NavConst != nil {
                view_NavConst.constant = 70
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewLayout()
        webAbout.navigationDelegate = self
        webAbout.uiDelegate = self
        var NSAttributedString = NSAttributedString()
        

        
       if let url = URL(string: "http://gentlemanspa-dev.us-east-2.elasticbeanstalk.com/api/Content/GetTermsHtml") {
           webAbout.load(URLRequest(url: url))
        }
        
        
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        sideMenuController?.showLeftView(animated: true)
    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        if let url = navigationAction.request.url {
//            // Check if the URL is an external link
//            if navigationAction.navigationType == .linkActivated, url.host != nil {
//                // Open external link in Safari
//             //   UIApplication.shared.open(url, options: [:], completionHandler: nil)
//              //  decisionHandler(.cancel) // Cancel the navigation in WKWebView
//            } else {
//                // Allow WKWebView to load the URL
//                decisionHandler(.allow)
//            }
//        } else {
//            decisionHandler(.allow)
//        }
//    }
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Run JavaScript to get content height
        
        let jsToCalculateBodyHeight = """
               document.body.scrollHeight;
               """
                
        
        webView.evaluateJavaScript(jsToCalculateBodyHeight) { (result, error) in
            if let height = result as? CGFloat {
                // Update the web view's height constraint
                print(height)
             //   self.specialityConst.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
}
