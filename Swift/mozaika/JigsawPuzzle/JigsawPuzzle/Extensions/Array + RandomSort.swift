//
//  Array + RandomSort.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 14.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation

extension Array {
  mutating func shuffle() {
    for _ in 0..<((count>0) ? (count-1) : 0) {
      sort { (_,_) in arc4random() < arc4random() }
    }
  }
}
