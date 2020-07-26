//
//  AppDelegate.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/9/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseCrashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase
        FirebaseApp.configure()
        
        //initial configuration
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        
        Utilities.sharedInstance.populateDefaultUserDefaultsValues()
        
        if (!UserDefaults.standard.bool(forKey: "hasRunBefore")) { // if app lunching for the first time then logout of firebase in case of caching
            try! Auth.auth().signOut()
            
            // Update the flag indicator
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
            UserDefaults.standard.synchronize()
            
            
            
        }
        
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                if(error == nil){
                    
                    //                    FirebaseIDToken = token!
                    let user = appUser()
                    user.firebaseToken = token!
                    saveAppUser(user: user)
                    
                    Utilities.sharedInstance.handleSubscription()
                    
                }
                else{
                    try! Auth.auth().signOut()
                    //                    FirebaseIDToken = ""
                    Utilities.sharedInstance.clearUserDefaults()
                    // Set you login view controller here as root view controller
                    let mainNavigationController = UINavigationController.init(rootViewController: LoginViewController())
                    self.window?.rootViewController = mainNavigationController
                }
            })
        }
        else{
            let mainNavigationController = UINavigationController.init(rootViewController: LoginViewController())
            self.window?.rootViewController = mainNavigationController
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
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
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                if(error == nil){
                    //                    FirebaseIDToken = token!
                    let user = appUser()
                    user.firebaseToken = token!
                    saveAppUser(user: user)
                }
                else{
                    Utilities.sharedInstance.logout()
                }
            })
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

