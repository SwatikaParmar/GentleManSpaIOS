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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        RootControllerManager().SetRootViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
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
                //   sideMenu.rootViewStatusBarStyle = .lightContent
                //   sideMenu.leftViewStatusBarStyle = .lightContent
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
