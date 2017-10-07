//
//  DetailInformationViewController.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class DetailInformationViewController: UITableViewController {
  // MARK: - Outlets
  @IBOutlet weak var cityIdLabel: UILabel!
  @IBOutlet weak var nameCityLabel: UILabel!
  @IBOutlet weak var visibilityLabel: UILabel!
  @IBOutlet weak var dateUpdateLabel: UILabel!
  
  @IBOutlet weak var lantitudeLabel: UILabel!
  @IBOutlet weak var lontitudeLabel: UILabel!
  
  @IBOutlet weak var humiditylabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var tempMaxLabel: UILabel!
  @IBOutlet weak var tempMinLabel: UILabel!
  
  @IBOutlet weak var susetLabel: UILabel!
  @IBOutlet weak var sunriseLabel: UILabel!
  
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var wendDegLabel: UILabel!
  
  // MARK: - Variables
  var city: City?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if city != nil {
      if let id = city?.id {
        cityIdLabel.text = String(id)
      }
      
      if let name = city?.name {
        nameCityLabel.text = name
      }
      
      if let visibility = city?.visibility {
        visibilityLabel.text = String(visibility)
      }
      
      if let lastUpdate = city?.dt {
        let date = Date(timeIntervalSince1970: TimeInterval(lastUpdate))
        dateUpdateLabel.text = date.toString()
      }
      
      if let coord = city?.coord {
        lantitudeLabel.text = String(coord.lat)
        lontitudeLabel.text = String(coord.lon)
      }
      
      if let main = city?.main {
        humiditylabel.text = String(main.humidity)
        pressureLabel.text = String(main.pressure)
        tempLabel.text = String(Int(Double(main.temp - 273.15))) + "°"
        tempMaxLabel.text = String(Int(Double(main.temp_max - 273.15))) + "°"
        tempMinLabel.text = String(Int(Double(main.temp_min - 273.15))) + "°"
      }
      
      if let sys = city?.sys {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateSunset = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sys.sunset)))
        let dateSunrise = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(sys.sunrise)))
        
        susetLabel.text = dateSunset
        sunriseLabel.text = dateSunrise
      }
      
      if let weather = city?.weather?.allObjects.first as? Weather {
        if let icon = weather.icon {
          if let URLIcon = URL(string: icon) {
            iconImage.sd_setImage(with: URLIcon)
          }
        }
        
        if let main = weather.main {
          mainLabel.text = main
        }
        
        if let desc = weather.desc {
          descriptionLabel.text = desc
        }
      }
      
      if let wind = city?.wind {
        windSpeedLabel.text = String(wind.speed)
        wendDegLabel.text = String(wind.deg)
      }
    }
    
    title = "Detailed information"
  }
}
