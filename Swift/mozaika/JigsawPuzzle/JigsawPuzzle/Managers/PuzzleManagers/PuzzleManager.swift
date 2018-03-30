//
//  PuzzleStateManager.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 16.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import PuzzleMaker

typealias PuzzleTyple = (image: UIImage, position: PuzzleItemPosition)

protocol PuzzleManagerDelegate {
  func puzzleDidGenerated(_ originalPuzzle: [PuzzleTyple],
                          puzzleElementsImages: [PuzzleTyple],
                          maxHeightPuzzle: CGFloat)
  func puzzleDidFinishLoaded(_ removedPuzzle: [PuzzleTyple])
  func puzzleDidFinish()
}

class PuzzleManager {
  enum PuzzleManagerImages {
    case original
    case elements
    case white
  }
  
  var delegate: PuzzleManagerDelegate?
  
  private var whiteImages: [PuzzleTyple] = []
  private var originalImages: [PuzzleTyple] = []
  private var puzzleElementsImages: [PuzzleTyple] = []
  
  private var maxHeight: CGFloat = 0.0
  private var size: CGSize!
  private var countPuzzle: Int
  private var puzzleStateManager: PuzzleStateManager!
  
  fileprivate var image: UIImage!
  
  init(withImage image: UIImage, countPuzzle: Int, size: CGSize, delegate: PuzzleManagerDelegate, imageId: Int) {
    self.size = size
    self.image = image
    self.countPuzzle = countPuzzle
    self.delegate = delegate
    
    puzzleStateManager = PuzzleStateManager(imageId: imageId, countItems: countPuzzle)
    
    generatePuzzle()
  }
  
  private func generatePuzzle() {
    let newImage = image.resizedImage(newSize: size)
    let countPuzzleInMaker = Int(sqrt(Double(countPuzzle)))
    
    let puzzleMaker = PuzzleMaker(image: newImage!, numRows: countPuzzleInMaker, numColumns: countPuzzleInMaker)
    puzzleMaker.generatePuzzles { (throwableClosure) in
      do {
        let puzzleElements = try throwableClosure()
        for row in 0 ..< countPuzzleInMaker {
          for column in 0 ..< countPuzzleInMaker {
            let puzzleElement = puzzleElements[row][column]
            let whiteImage = puzzleElement.image.imageWithColor(tintColor: .white, path: puzzleElement.puzzleUnit.path)
            
            self.whiteImages.append((whiteImage, PuzzleItemPosition(point: puzzleElement.position,
                                                                    positionInMatrix: (row, column))))
            self.originalImages.append((puzzleElement.image, PuzzleItemPosition(point: puzzleElement.position,
                                                                                positionInMatrix: (row, column))))
            
            self.puzzleElementsImages.append((puzzleElement.image, PuzzleItemPosition(point: puzzleElement.position,
                                                                                      positionInMatrix: (row, column))))
          }
        }
        
        self.puzzleElementsImages.shuffle()
        
        if let height = self.originalImages.max(by: { (element1, element2) -> Bool in
          return element1.image.size.height > element2.image.size.height
        })?.image.size.height {
          self.maxHeight = height
        }
        
        if let respond = self.delegate?.puzzleDidGenerated(self.originalImages,
                                                           puzzleElementsImages: self.puzzleElementsImages,
                                                           maxHeightPuzzle: self.maxHeight) {
          respond
        }
      } catch let error {
        debugPrint(error)
      }
    }
  }
}

extension PuzzleManager {
  func getPuzzle(withType type: PuzzleManagerImages) -> [PuzzleTyple] {
    switch type {
    case .elements: return puzzleElementsImages
    case .original: return originalImages
    case .white: return whiteImages
    }
  }
  
  private func removeElementAndReplaceWhite(fromElement element: PuzzleTyple) {
    let index = puzzleElementsImages.index { (puzzleElement) -> Bool in
      return (puzzleElement.position.row == element.position.row)
        && (puzzleElement.position.column == element.position.column)
    }
    
    guard let removeIndex = index else { return }
    
    puzzleElementsImages.remove(at: removeIndex)
    
    guard puzzleElementsImages.isEmpty else { return }
    
    if let respond = delegate?.puzzleDidFinish() {
      respond
    }
  }
  
  private func getElement(withMatrix matrix: (row: Int, column: Int)) -> PuzzleTyple? {
    return originalImages.first(where: { (element) -> Bool in
      return (element.position.row == matrix.row)
        && (element.position.column == matrix.column)
    })
  }
  
  func checkPuzzleAndGetOriginalRect(withLocation location: CGPoint, needPosition: (row: Int, column: Int)?) -> CGRect? {
    guard let matrixElement = needPosition,
      let originalEmenent = getElement(withMatrix: matrixElement) else { return nil }
    
    let originalPuzzleRect = CGRect(origin: originalEmenent.position.point, size: originalEmenent.image.size)
    let contains = originalPuzzleRect.contains(location)
    
    if contains {
      removeElementAndReplaceWhite(fromElement: originalEmenent)
    }
    
    return contains ? originalPuzzleRect : nil
  }
  
  func getOriginalImage() -> UIImage {
    return image
  }
}

extension PuzzleManager {
  func save() {
    let puzzles = puzzleElementsImages.flatMap { (element) -> PuzzleItemPosition in
      return element.position
    }
    
    puzzleStateManager.save(toItems: puzzles)
  }
  
  func load() {
    guard let savePuzzle = puzzleStateManager.getItems() else { return }
    let myPuzzleLoaded = puzzleElementsImages.filter({ (element) -> Bool in
      return savePuzzle.contains(where: { (puzzle) -> Bool in
        return element.position.row == puzzle.row && element.position.column == puzzle.column
      })
    })
    
    let removedPuzzle = puzzleElementsImages.filter({ (element) -> Bool in
      return !myPuzzleLoaded.contains(where: { (puzzlePosition) -> Bool in
        return puzzlePosition.position == element.position
      })
    })
    
    puzzleElementsImages = myPuzzleLoaded
    
    if let respond = delegate?.puzzleDidFinishLoaded(removedPuzzle) { respond }
  }
}
