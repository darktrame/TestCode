//
//  JSONParser.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 12.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
  private var json: JSON!
  
  init(_ json: JSON) {
    self.json = json
  }
  
  func parsePicturesLibrary() -> [PicturesModel] {
    guard let arrayPictures = json.array else { return [] }
    
    var picturesObjects: [PicturesModel] = []
    for jsonObject in arrayPictures {
      guard let category = jsonObject["Category"].int,
        let isChargable = jsonObject["IsChargable"].bool,
        let id = jsonObject["Id"].int else { continue }
      let newPictures = PicturesModel(category: category, isChargable: isChargable, id: id)
      picturesObjects.append(newPictures)
    }
    
    return picturesObjects
  }
}
