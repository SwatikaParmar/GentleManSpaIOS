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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webAbout.navigationDelegate = self
        webAbout.uiDelegate = self
        var NSAttributedString = NSAttributedString()
        
        
        // HTML content
        let htmlString = """
               <html>
               <head>
               <style>
                   body {
                       font-size: 35px; /* Set your desired font size */
                       font-family: -apple-system, Helvetica, Arial, sans-serif;
                   }
               </style>
               </head>
               <body>
              
              </body>
              </html>
 """
        
        webAbout.loadHTMLString(htmlString, baseURL: nil)
        webAbout.evaluateJavaScript("document.getElementsByTagName('body')[0].style.fontSize='35px';") { (result, error) in
            if let error = error {
                print("Error adjusting font size: \(error)")
            }
        }
        
        
//        if let url = URL(string: "https://www.buda.com.au/") {
//            webAbout.load(URLRequest(url: url))
//               }
        
        
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
