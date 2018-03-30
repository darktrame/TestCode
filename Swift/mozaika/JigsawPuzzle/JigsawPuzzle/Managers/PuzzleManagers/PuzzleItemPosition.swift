//
//  PuzzleItemPosition.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 21.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class PuzzleItemPosition: NSObject, NSCoding, Codable {
  func encode(with aCoder: NSCoder) {
    aCoder.encode(point, forKey: "point")
    aCoder.encode(row, forKey: "row")
    aCoder.encode(column, forKey: "column")
  }
  
  required init?(coder aDecoder: NSCoder) {
    guard
      let point = aDecoder.decodeObject(forKey: "point") as? CGPoint,
      let row = aDecoder.decodeObject(forKey: "row") as? Int,
      let column = aDecoder.decodeObject(forKey: "column") as? Int else { return }
    
    self.point = point
    self.row = row
    self.column = column
  }
  
  var point: CGPoint!
  var row: Int!
  var column: Int!
  
  init(point: CGPoint, positionInMatrix: (row: Int, column: Int)) {
    self.point = point
    self.row = positionInMatrix.row
    self.column = positionInMatrix.column
  }
}
