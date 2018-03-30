//
//  PuzzleStateManager.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 21.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

fileprivate protocol Path {
  var id: Int { get set }
}

extension Path {
  var fileURL: URL? {
    let dirPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as String
    let pathArray = [dirPath, String(id)]
    return NSURL.fileURL(withPathComponents: pathArray)
  }
}

class PuzzleStateManager: NSObject, Path {
  var id: Int
  var countItems: Int
  
  func save(toItems items: [PuzzleItemPosition]) {
    NSKeyedArchiver.archiveRootObject(items, toFile: fileURL!.path)
    
    let onePuzzleProgress = Double(100) / Double(countItems)
    var multip = Int(ceil(Double(Double(abs(items.count - countItems)) * onePuzzleProgress)))
    guard var myPuzzles = UserDefaults.standard.dictionary(forKey: "savePuzzle"),
          var myPuzzlesCount = UserDefaults.standard.dictionary(forKey: "myPuzzlesCount") else {
      let myPuzzles = [String(id): multip]
      let myPuzzlesCount = [String(id): countItems]
      
      UserDefaults.standard.set(myPuzzles, forKey: "savePuzzle")
      UserDefaults.standard.set(myPuzzlesCount, forKey: "myPuzzlesCount")
      
      return
    }
    
    if multip > 100 { multip = 100 }
    
    myPuzzles[String(id)] = multip
    myPuzzlesCount[String(id)] = countItems
    
    UserDefaults.standard.set(myPuzzles, forKey: "savePuzzle")
    UserDefaults.standard.set(myPuzzlesCount, forKey: "myPuzzlesCount")
  }
  
  func getItems() -> [PuzzleItemPosition]? {
    return NSKeyedUnarchiver.unarchiveObject(withFile: fileURL!.path) as? [PuzzleItemPosition]
  }
  
  init(imageId: Int, countItems: Int) {
    self.id = imageId
    self.countItems = countItems
  }
}
