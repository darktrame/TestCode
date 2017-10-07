//
//  Extensions.swift
//  
//
//  Created by Elatesoftware on 06.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import SystemConfiguration

extension UIViewController {
  static func viewController() -> UIViewController? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController()
  }
  
  func removeTitleBackBarButtonItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
  }
}

extension Date {
  func toString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd yyyy, HH:mm"
    return dateFormatter.string(from: self)
  }
}

extension Notification.Name {
  static let updateTable = Notification.Name("updateTable")
}

extension UIApplication {
  func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
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
