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
    get { return UserDefaults.standard.bool(forKey: "isPremiumVersionActive") }
    set { UserDefaults.standard.set(newValue, forKey: "isPremiumVersionActive") }
  }
}
