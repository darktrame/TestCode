//
//  AppDelegate.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 08.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FacebookCore
import Fabric
import Crashlytics
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  fileprivate let notificationTopic = "NewPictures"
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setNavigationBarSettings(with: .applicationColor)
    setNotification(application)
    
    Fabric.with([Crashlytics.self])
    
    RageProducts.store.getAppReceipt()
    
    return true
  }
  
  func setNavigationBarSettings(with color: UIColor) {
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.backgroundColor = color
    navigationBarAppearance.isTranslucent = false
    navigationBarAppearance.barTintColor = color
    navigationBarAppearance.tintColor = .white
    
    navigationBarAppearance.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.white
    ]
  }
  
  func setNotification(_ application: UIApplication) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
      
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    FirebaseApp.configure()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    AppEventsLogger.activate(application)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    Messaging.messaging().subscribe(toTopic: notificationTopic)
  }
}
