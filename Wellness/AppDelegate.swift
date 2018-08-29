//
//  AppDelegate.swift
//  Wellness
//
//  Created by think360 on 05/03/18.
//  Copyright © 2018 bharat. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import Stripe
import UserNotifications
 
internal let kMapsAPIKey = "AIzaSyAFhk1Wyc6H_13J-e2JxhTH26vb9ivVj7U"

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    var myArray = NSDictionary()
    var strUserID = NSString()
    var DeviceToken=String()
    
    var NotificationCount = NSNumber()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.IQK

        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
       // IQKeyboardManager.shared.enable = true
      //  IQKeyboardManager.shared.enableAutoToolbar = true
        
        GMSPlacesClient.provideAPIKey(kMapsAPIKey)
        GMSServices.provideAPIKey(kMapsAPIKey)
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AZWL1TRofLyc3KQZBu6u035Nv2b27bHRriRNYG8NAwbNy-dmb1yJpMF-ga4g3Xt8Pi7uW6HCjW-4ril3", PayPalEnvironmentSandbox: "AaewP5F9JetdUoEEgLVivUEJKkYmGVt5KaZsPOt5tXhFr2vgu6t9Tf_DLP4fYqg3jyfpzWEL6B5pThFe"])

        Stripe.setDefaultPublishableKey("pk_test_22zFpNK6ZpBs4qh8Pm9RAmh0")
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        print(deviceId ?? "123")
        
        if UserDefaults.standard.object(forKey: "UserLogin") != nil 
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.pushViewController(destinationViewController, animated: false)
        }
        else
        {
            if UserDefaults.standard.object(forKey: "Installed") != nil
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Image1ViewController") as! Image1ViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
        }
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        let center = UNUserNotificationCenter.current()
        center.delegate=self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        registerForPushNotifications(application: application)
        
        return true
    }
    

    func registerForPushNotifications(application: UIApplication)
    {
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                     DispatchQueue.main.async {
                         UIApplication.shared.registerForRemoteNotifications()
                     }
                }
                else
                {
                    //Do stuff if unsuccessful...
                }
            })
        }
        else{ //If user is not on iOS 10 use the old methods we've been using
            
        }
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        DeviceToken = deviceTokenString
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
    }
    
    
    // Called when APNs failed to register the device for push notifications
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print("for handling push in background")
        print(response.notification.request.content.userInfo)
        
        let dic = response.notification.request.content.userInfo as NSDictionary
        
        if let aps = dic["aps"] as? [String: Any]
        {
            if let quantity = aps["count"] as? NSNumber
            {
                NotificationCount = quantity
            }
            else if let quantity = aps["count"] as? String
            {
                if let myInteger = Int(quantity) {
                    NotificationCount = NSNumber(value:myInteger)
                }
            }
    
            let orderNumberInt  = self.NotificationCount.intValue
            if orderNumberInt == 0
            {
                
            }
            else
            {
                
            }
            
            UserDefaults.standard.set(NotificationCount, forKey: "NCount")
            
            let notificationName = Notification.Name("Notification")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("for handling push in foreground")
        
        completionHandler([.alert, .badge, .sound])
        print(notification.request.content.userInfo)
        let dic = notification.request.content.userInfo as NSDictionary
        
        if let aps = dic["aps"] as? [String: Any]
        {
            if let quantity = aps["count"] as? NSNumber
            {
               NotificationCount = quantity
            }
            else if let quantity = aps["count"] as? String
            {
                if let myInteger = Int(quantity) {
                    NotificationCount = NSNumber(value:myInteger)
                }
            }
            
            let orderNumberInt  = self.NotificationCount.intValue
            if orderNumberInt == 0
            {
                
            }
            else
            {
                
            }
            
            UserDefaults.standard.set(NotificationCount, forKey: "NCount")
            
            let notificationName = Notification.Name("Notification")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

