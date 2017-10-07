//
//  CityTableViewCell.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import SDWebImage

class CityTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lastUpdateLabel: UILabel!
  @IBOutlet weak var imageWeather: UIImageView!
  @IBOutlet weak var mainDescLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  // MARK: - Variables
  var city: City?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if let name = city?.name {
      nameLabel.text = name
    }
    
    if let lastUpdate = city?.dt {
      let date = Date(timeIntervalSince1970: TimeInterval(lastUpdate))
      lastUpdateLabel.text = date.toString()
    }
    
    if let weather = city?.weather?.allObjects.first as? Weather {
      if let icon = weather.icon {
        if let URLIcon = URL(string: icon) {
          imageWeather.sd_setImage(with: URLIcon)
        }
      }
      
      if let main = weather.main {
        mainDescLabel.text = main
      }
      
      if let mainTemp = city?.main {
        temperatureLabel.text = String(Int(Double(mainTemp.temp - 273.15))) + "°"
      }
    }
  }
}
