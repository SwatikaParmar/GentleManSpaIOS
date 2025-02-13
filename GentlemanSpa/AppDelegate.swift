//
//  AppDelegate.swift
//  GentlemanSpa
//
//  Created by AbsolveTech on 11/07/24.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

import CocoaTextField
import LGSideMenuController
import FirebaseCore
import FirebaseMessaging
import Firebase
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = .black
        IQKeyboardManager.shared.enableAutoToolbar =  true
        FirebaseApp.configure()

        GMSServices.provideAPIKey(GlobalConstants.GoogleWebAPIKey)
        GMSPlacesClient.provideAPIKey(GlobalConstants.GoogleWebAPIKey)
        GoogleApi.shared.initialiseWithKey(GlobalConstants.GoogleWebAPIKey)
        registerForPushNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0)
        return true
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
        
            notificationCenter.delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            notificationCenter.requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.setValue(fcmToken, forKey:Constants.fcmToken)
        UserDefaults.standard.synchronize()
        Constants.fcmTokenFirePuch = fcmToken ?? ""
    }
    
    
    //Receive Remote Notification on Background
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
       Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print(#function)
        completionHandler([.list, .banner, .sound])
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        
        let state : UIApplication.State = application.applicationState
        if (state == .inactive || state == .background) {
            print("background")
        } else {
            print("foreground")
        }
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if UserDefaults.standard.bool(forKey: Constants.login)
        {
            if let senderId = response.notification.request.content.userInfo["userId"] as? String {
                if let type = response.notification.request.content.userInfo["type"] as? String {
                    if type == "Chat" {
                        if UserDefaults.standard.string(forKey: Constants.userType) == "Professional" {
                            if UserDefaults.standard.bool(forKey: Constants.login){
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu_Push_Pro"), object: nil, userInfo: ["senderId":senderId])
                            }
                        }
                        else{
                            if UserDefaults.standard.bool(forKey: Constants.login){
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu_Push_Action"), object: nil, userInfo: ["senderId":senderId])
                            }
                        }
                    }
                }
            }
        }
    }
    
  
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

  
}

