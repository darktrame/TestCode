//
//  ApplicationModel.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 08.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import Foundation
import UIKit

class ApplicationModel: NSObject {
  private let countCategories = 10
  private let categoriesTitle: [String] = [NSLocalizedString("Animals", comment: ""),
                                           NSLocalizedString("Flowers", comment: ""),
                                           NSLocalizedString("Sights", comment: ""),
                                           NSLocalizedString("Art", comment: ""),
                                           NSLocalizedString("Food", comment: ""),
                                           NSLocalizedString("Landscapes", comment: ""),
                                           NSLocalizedString("Transport", comment: ""),
                                           NSLocalizedString("Sport", comment: ""),
                                           NSLocalizedString("Holidays", comment: ""),
                                           NSLocalizedString("Other", comment: "")]
  private let categoriesColor: [UIColor] = [#colorLiteral(red: 0.3647058824, green: 0.262745098, blue: 0.5294117647, alpha: 1), #colorLiteral(red: 0.4666666667, green: 0.3254901961, blue: 0.6470588235, alpha: 1), #colorLiteral(red: 0.568627451, green: 0.2823529412, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0.7137254902, green: 0.2588235294, blue: 0.5882352941, alpha: 1), #colorLiteral(red: 0.9294117647, green: 0.2862745098, blue: 0.3803921569, alpha: 1), #colorLiteral(red: 0.9294117647, green: 0.2980392157, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.4117647059, blue: 0.1882352941, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4862745098, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.7568627451, blue: 0.1568627451, alpha: 1)]
  var categoriesPuzzle: [(name: String, image: UIImage, titleColor: UIColor)] = []
  var picturesPuzzle: [PicturesModel] = []
  
  override init() {
    for (index, object) in categoriesTitle.enumerated() {
      let imageCategory = UIImage(named: index.getString()) ?? UIImage()
      let newCategoriesObject = (object, imageCategory, categoriesColor[index])
      categoriesPuzzle.append(newCategoriesObject)
    }
  }
}
