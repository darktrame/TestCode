//
//  Pictures.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 12.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation
import UIKit

protocol Pictures {
  var category: Int { get set }
  var isChargable: Bool { get set }
  var id: Int { get set }
}

extension Pictures {
  var pictures: String {
    return "http://yourjigs.w10.hoster.by/api/picture/getpicture?id=\(id)"
  }
  
  var preview: String {
    return "http://yourjigs.w10.hoster.by/api/picture/getpreviewpicture?id=\(id)"
  }
}

struct PicturesModel: Pictures {
  var category: Int
  var isChargable: Bool
  var id: Int
}
