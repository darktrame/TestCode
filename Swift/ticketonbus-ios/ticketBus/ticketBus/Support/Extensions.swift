//
//  Extensions.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

extension UIViewController {
  static func viewController() -> UIViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController()
  }
  
  func removeTitleBackBarButtonItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                       style: .done,
                                                       target: nil,
                                                       action: nil)
  }
}

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
  
  class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
  
  func showAlert(_ message: String, title: String) -> UIAlertController {
    let alert = UIAlertController(title: message,
                                  message: title,
                                  preferredStyle: .alert)
    
    let close = UIAlertAction(title: "OK",
                              style: .cancel,
                              handler: nil)
    
    alert.addAction(close)
    
    return alert
  }
}

extension UIColor {
  open class var orangeTicketBusColor: UIColor {
    return UIColor(red: 255.0 / 255.0,
                   green: 185.0 / 255.0,
                   blue: 0.0,
                   alpha: 1.0)
  }
  
  open class var blueTicketBusColor: UIColor {
    return UIColor(red: 55.0 / 255.0,
                   green: 94.0 / 255.0,
                   blue: 128.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var blueTicketBusLightColor: UIColor {
    return UIColor(red: 67.0 / 255.0,
                   green: 117.0 / 255.0,
                   blue: 161.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var blueTicketBusTableColor: UIColor {
    return UIColor(red: 240.0 / 255.0,
                   green: 245.0 / 255.0,
                   blue: 248.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var blueSelectTableCellColor: UIColor {
    return UIColor(red: 47.0 / 255.0,
                   green: 83.0 / 255.0,
                   blue: 115.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var blackTextColor: UIColor {
    return UIColor(red: 51.0 / 255.0,
                   green: 51.0 / 255.0,
                   blue: 51.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var unselectedTextButtonColor: UIColor {
    return UIColor(red: 119.0 / 255.0,
                   green: 160.0 / 255.0,
                   blue: 186.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var selectedSiteColor: UIColor {
    return UIColor(red: 1.0,
                   green: 204.0 / 255.0,
                   blue: 0.0,
                   alpha: 1.0)
  }
  
  open class var freeSiteColor: UIColor {
    return UIColor(red: 152.0 / 255.0,
                   green: 224.0 / 255.0,
                   blue: 141.0 / 255.0,
                   alpha: 1.0)
  }
  
  open class var boughtSiteColor: UIColor {
    return UIColor(red: 202.0 / 255.0,
                   green: 219.0 / 255.0,
                   blue: 230.0 / 255.0,
                   alpha: 1.0)
  }
}

extension Date {
  func getStringDDMMYYE() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy (E)"
    dateFormatter.locale = Locale(identifier: "ru_RU")
    
    let currentDateString: String = dateFormatter.string(from: self)
    
    return currentDateString
  }
  
  func getStringDDMMYY() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    
    let currentDateString: String = dateFormatter.string(from: self)
    
    return currentDateString
  }
}

extension String {
  func getSecondTimeFromString() -> Int? {
    let components = self.components(separatedBy: ":")
    
    if components.count == 2 {
      guard let hoursString = components.first, let minutesString = components.last else {
        return nil
      }
      
      guard let hoursInt = Int(hoursString), let minutesInt = Int(minutesString) else {
        return nil
      }
      
      return hoursInt * 60 + minutesInt
    }
    
    return nil
  }
  
  func getSecondDateFromString() -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    
    if let timeIntervalDate = dateFormatter.date(from: self)?.timeIntervalSince1970 {
      return Int(timeIntervalDate)
    }
    
    return nil
  }
  
  func getSecondDateAndTimeFromString(_ isArrive: Bool) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = isArrive ? "dd.MM.yyyy HH:mm:ss" : "dd.MM.yyyy HH:mm"
    
    if let timeIntervalDate = dateFormatter.date(from: self)?.timeIntervalSince1970 {
      return Int(timeIntervalDate)
    }
    
    return nil
  }
}
