//
//  User.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation

enum User {
  static var isAuthorized: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "isAuthorized")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "isAuthorized")
    }
  }
  
  static var username: String? {
    get {
      return UserDefaults.standard.string(forKey: "username")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "username")
    }
  }
  
  static var user_id: Int {
    get {
      return UserDefaults.standard.integer(forKey: "user_id")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "user_id")
    }
  }
  
  static var user_token: String? {
    get {
      return UserDefaults.standard.string(forKey: "user_token")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "user_token")
    }
  }
}
