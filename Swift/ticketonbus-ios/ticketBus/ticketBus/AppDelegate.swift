//
//  AppDelegate.swift
//  ticketBus
//
//  Created by Elatesoftware on 16.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  // MARK: - Variables
  var window: UIWindow?
  let googleMapsApiKey = "AIzaSyDccQqiS1KPGqo8_SUWV40iuxQZtChA91E"
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    IQKeyboardManager.sharedManager().enable = true
    GMSServices.provideAPIKey(googleMapsApiKey)
    
    setUpNavigationBarSettings()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    
    navigationController.setViewControllers([SearchFlightsViewController.viewController()!], animated: false)
    
    let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
    mainViewController.rootViewController = navigationController
    mainViewController.setup()
    
    window?.rootViewController = mainViewController
    
    UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    
    if User.isAuthorized {
      ConnectionManager.share.getGetUser { (_, _) in }
    }
    
    return true
  }
  
  // MARK: - UI
  func setUpNavigationBarSettings() {
    let navAppearance = UINavigationBar.appearance()
    navAppearance.barTintColor = UIColor.blueTicketBusColor
    
    navAppearance.tintColor = UIColor.white
    navAppearance.isTranslucent = true
    
    UINavigationBar.appearance().isTranslucent = false
    
    navAppearance.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.white
    ]
    
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.blueTicketBusColor
    navAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                         NSAttributedStringKey.font: UIFont(name: "SFUIDisplay-Medium", size: 17)!]
  }
}

