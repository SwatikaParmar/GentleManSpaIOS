//
//  SceneDelegate.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 11/07/24.
//

import UIKit
import LGSideMenuController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        RootControllerManager().SetRootViewController()
        
        if let response = connectionOptions.notificationResponse{
            if let data = response.notification.request.content.userInfo as? [String: AnyObject] {
                if let senderId = data["userId"] as? String {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(nil, forKey: "senderId")
                    if UserDefaults.standard.bool(forKey: Constants.login){
                        if let type = data["type"] as? String {
                            if type == "Chat" {
                                userDefaults.set(senderId, forKey: "senderId")
                            }
                           
                        }
                    }
                }
                
//                let alert = UIAlertController(title: "", message:data.debugDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu_Push_Action"), object: nil, userInfo: ["count":"Notification"])

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        
     
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if UserDefaults.standard.bool(forKey: Constants.login){
            if UserDefaults.standard.string(forKey: Constants.userType) == "Professional" {
                NotificationCenter.default.post(name: Notification.Name("Menu_Push_Pro"), object: nil, userInfo: ["count":"online"])

            }
            else{
                NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":"online"])

            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
 

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        
        if UserDefaults.standard.bool(forKey: Constants.login){
            if UserDefaults.standard.string(forKey: Constants.userType) == "Professional" {
                NotificationCenter.default.post(name: Notification.Name("Menu_Push_Pro"), object: nil, userInfo: ["count":"offline"])
            }
            else{
                NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":"offline"])
            }
        }
    }

    
 
 }



class RootControllerManager: NSObject {
    
    //MARK: -  @Set RootView Controller
    func SetRootViewController(){
       
        if !UserDefaults.standard.bool(forKey: Constants.login) {
            let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
            PushToRootScreen(ClassName: storyboardMain.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        }
        else {
            if UserDefaults.standard.string(forKey: Constants.userType) == "Professional" {
                let storyboardMain = UIStoryboard(name: "Professional", bundle: nil)
                let homecontroller = storyboardMain.instantiateViewController(withIdentifier: "TabBarProVc")
                
                let leftController = storyboardMain.instantiateViewController(withIdentifier: "MenuProController")
                let navigationController = UINavigationController(rootViewController: homecontroller)
                navigationController.isNavigationBarHidden = true
                
                let sideMenu = LGSideMenuController(rootViewController: navigationController,
                                                    leftViewController: leftController,
                                                    rightViewController: nil)
                sideMenu.leftViewWidth = UIScreen.main.bounds.size.width - 110
                sideMenu.navigationController?.isNavigationBarHidden = true
               
                sideMenu.isLeftViewStatusBarHidden = true
                sideMenu.panGestureForLeftView.isEnabled = false
                UIApplication.shared.windows.first?.rootViewController = sideMenu
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            else{
                let storyboard = UIStoryboard(name: "User", bundle: nil)
                let homecontroller = storyboard.instantiateViewController(withIdentifier: "TabBarUserVc")
                
                
                let leftController = storyboard.instantiateViewController(withIdentifier: "MenuUserController")
                
                let navigationController = UINavigationController(rootViewController: homecontroller)
                
                navigationController.isNavigationBarHidden = true
                
                let sideMenu = LGSideMenuController(rootViewController: navigationController,
                                                    leftViewController: leftController,
                                                    rightViewController: nil)
                sideMenu.leftViewWidth = UIScreen.main.bounds.size.width - 110
                sideMenu.navigationController?.isNavigationBarHidden = true
                sideMenu.isLeftViewStatusBarHidden = true
                sideMenu.panGestureForLeftView.isEnabled = false
                UIApplication.shared.windows.first?.rootViewController = sideMenu
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    //MARK: -  @Push To RootController
    func PushToRootScreen(ClassName:UIViewController){
                
        let navigationController = UINavigationController(rootViewController: ClassName)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
