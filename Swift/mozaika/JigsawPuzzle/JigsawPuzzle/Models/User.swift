//
//  User.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 03.03.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation

enum User {
  static var isPremiumVersionActive: Bool {
    get {
      guard let purchaseDate = User.purchaseDate, let expiresDate = User.expiresDate else { return false }
      return (purchaseDate...expiresDate).contains(Date())
    }
  }
  
  static var rateUser: Bool {
    get { return UserDefaults.standard.bool(forKey: "rateUser") }
    set { UserDefaults.standard.set(newValue, forKey: "rateUser") }
  }
  
  static var countRate: Int {
    get { return UserDefaults.standard.integer(forKey: "countRate") }
    set { UserDefaults.standard.set(newValue, forKey: "countRate") }
  }
  
  static var purchaseDate: Date? {
    get { return UserDefaults.standard.object(forKey: "purchaseDate") as? Date }
    set { UserDefaults.standard.set(newValue, forKey: "purchaseDate") }
  }
  
  static var expiresDate: Date? {
    get { return UserDefaults.standard.object(forKey: "expiresDate") as? Date }
    set { UserDefaults.standard.set(newValue, forKey: "expiresDate") }
  }
}
