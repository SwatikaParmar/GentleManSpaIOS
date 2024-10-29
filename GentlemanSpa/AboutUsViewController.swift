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
               <p>Available in various widths and depths these heelguard grates are perfect for outdoor use such as pools, balconies, walkways and even some profiles can be used in driveways.</p>
               <p>Each drain is sold in standard lengths with accessories such as end caps, joiners and outlets all sold separately. Typically these products are purchased in the standard lengths and cut and joined on site as required as they only require a simple installation. There is no hole cut out in the base for the hole position, allowing it to be cut wherever you require it.</p>
               <h2>Available sizes</h2>
               <ul>
                   <li>85mm wide x 20mm deep - sold in 2 metre lengths</li>
                   <li>85mm wide x 40mm deep - sold in 1 and 2 metre lengths</li>
                   <li>110mm wide x 60mm deep - sold in 1 and 2 metre lengths</li>
                   <li>140mm wide x 125mm deep - sold in 1, 2 and 3 metre lengths</li>
                   <li>140mm wide x 125mm deep (Class B) - sold in 1, 2 and 3 metre lengths</li>
                   <li>200mm wide x 170mm deep (Class B) - sold in 2 and 3 metre lengths</li>
               </ul>
               <table style="width: 100%;">
                   <tbody>
                       <tr>
                           <td style="width: 100%;"><strong>Product Drawings</strong></td>
                       </tr>
                       <tr>
                           <td style="width: 100%;"><a title="85mm wide x 20mm deep Heelguard Grate and Channel" href="https://cdn.shopify.com/s/files/1/0610/1011/6826/files/20heel_copy.pdf?v=1638831666" target="_blank">85mm wide x 20mm deep</a></td>
                       </tr>
                       <tr>
                           <td style="width: 100%;"><a title="85mm wide x 40mm deep Heelguard Grate and Channel" href="https://cdn.shopify.com/s/files/1/0610/1011/6826/files/40heel_copy.pdf?v=1638831666" target="_blank">85mm wide x 40mm deep</a></td>
                       </tr>
                       <tr>
                           <td style="width: 100%;"><a title="110mm wide x 60mm deep Heelguard Grate and Channel" href="https://cdn.shopify.com/s/files/1/0610/1011/6826/files/60heel_copy.pdf?v=1638831666" target="_blank">110mm wide x 60mm deep</a></td>
                       </tr>
                       <tr>
                           <td style="width: 100%;"><a title="140mm wide x 125mm deep Heelguard Grate and Channel" href="https://cdn.shopify.com/s/files/1/0610/1011/6826/files/140heel.pdf?v=1638831666" target="_blank">140mm wide x 125mm deep</a></td>
                       </tr>
                       <tr>
                           <td style="width: 100%;"><a title="200mm wide x 170mm deep Stainless Steel Heelguard" href="https://cdn.shopify.com/s/files/1/0610/1011/6826/files/ss200heel_copy.pdf?v=1638831747" target="_blank">200mm wide x 170mm deep</a></td>
                       </tr>
                   </tbody>
               </table>
               <p>Please note that both the 200x170mm and 140x125mm trench box grate has buda.com.au engraving on the grates.</p>
              </body>
              </html>
 """
        
        webAbout.loadHTMLString(htmlString, baseURL: nil)
        webAbout.evaluateJavaScript("document.getElementsByTagName('body')[0].style.fontSize='35px';") { (result, error) in
            if let error = error {
                print("Error adjusting font size: \(error)")
            }
        }
        
        
        
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            // Check if the URL is an external link
            if navigationAction.navigationType == .linkActivated, url.host != nil {
                // Open external link in Safari
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel) // Cancel the navigation in WKWebView
            } else {
                // Allow WKWebView to load the URL
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Run JavaScript to get content height
        
        let jsToCalculateBodyHeight = """
               document.body.scrollHeight;
               """
                
        
        webView.evaluateJavaScript(jsToCalculateBodyHeight) { (result, error) in
            if let height = result as? CGFloat {
                // Update the web view's height constraint
                print(height)
                self.specialityConst.constant = height / 2 - 65
                self.view.layoutIfNeeded()
            }
        }
    }
}
