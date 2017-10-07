//
//  JSONParser.swift
//  TestTask
//
//  Created by Elatesoftware on 27.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JSONParser {
  func parseWeather(_ todo: [String: AnyObject], isNeedPost: Bool) -> City? {
    guard let idCity = todo["id"] as? Int else {
      return nil
    }
    
    var city = CoreDataManager.share.getCity(idCity)
    
    if city == nil {
      city = NSEntityDescription.insertNewObject(forEntityName: "City",
                                                          into: (UIApplication.shared.delegate as! AppDelegate)
                                                            .managedObjectContext) as? City
    }
    
    city?.id = Int32(idCity)
    
    // MARK: - Parse coordinates
    if let coordJSON = todo["coord"] {
      guard
        let lon = coordJSON["lon"] as? Double,
        let lat = coordJSON["lat"] as? Double
        else {
          return nil
      }
      
      if city?.coord == nil {
        city?.coord = NSEntityDescription.insertNewObject(forEntityName: "Coord",
                                                          into: (UIApplication.shared.delegate as! AppDelegate)
                                                            .managedObjectContext) as? Coord
      }
      
      city?.coord?.lon = lon
      city?.coord?.lat = lat
    }
    
    // MARK: - Parse weather
    if let oldWeather = city?.weather {
      city?.removeFromWeather(oldWeather)
    }
    
    if let weatherJSON = todo["weather"] as? [Any] {
      for weatherObject in weatherJSON {
        let newWeather = NSEntityDescription.insertNewObject(forEntityName: "Weather",
                                                             into: (UIApplication.shared.delegate as! AppDelegate)
                                                              .managedObjectContext) as! Weather
        
        newWeather.id = Int32((weatherObject as! [String: AnyObject])["id"] as! Int)
        newWeather.main = (weatherObject as! [String: AnyObject])["main"] as? String
        newWeather.desc = (weatherObject as! [String: AnyObject])["description"] as? String
        
        if let icon = (weatherObject as! [String: AnyObject])["icon"] as? String {
          newWeather.icon = "http://openweathermap.org/img/w/\(icon).png"
        }
        
        city?.addToWeather(newWeather)
      }
    }
    
    // MARK: - Parse coordinates
    if let mainJSON = todo["main"] {
      guard
        let temp = mainJSON["temp"] as? Float,
        let pressure = mainJSON["pressure"] as? Int,
        let humidity = mainJSON["humidity"] as? Int,
        let temp_min = mainJSON["temp_min"] as? Float,
        let temp_max = mainJSON["temp_max"] as? Float
        else {
          return nil
      }
      
      if city?.main == nil {
        city?.main = NSEntityDescription.insertNewObject(forEntityName: "Main",
                                                         into: (UIApplication.shared.delegate as! AppDelegate)
                                                          .managedObjectContext) as? Main
      }
      
      city?.main?.temp = temp
      city?.main?.pressure = Int32(pressure)
      city?.main?.humidity = Int32(humidity)
      city?.main?.temp_min = temp_min
      city?.main?.temp_max = temp_max
    }
    
    if let visibility = todo["visibility"] as? Int {
      city?.visibility = Int32(visibility)
    }
    
    // MARK: - Parse wind
    if let windJSON = todo["wind"] {
      guard
        let speed = windJSON["speed"] as? Float,
        let deg = windJSON["deg"] as? Int
        else {
          return nil
      }
      
      if city?.wind == nil {
        city?.wind = NSEntityDescription.insertNewObject(forEntityName: "Wind",
                                                         into: (UIApplication.shared.delegate as! AppDelegate)
                                                          .managedObjectContext) as? Wind
      }
      
      city?.wind?.speed = speed
      city?.wind?.deg = Int16(deg)
    }
    
    if let dt = todo["dt"] as? Int {
      city?.dt = Int32(dt)
    }
    
    if let name = todo["name"] as? String {
      city?.name = name
    }
    
    if let cod = todo["cod"] as? Int {
      city?.cod = Int32(cod)
    }
    
    // MARK: - Parse sys
    if let sysJSON = todo["sys"] {
      guard
        let sunrise = sysJSON["sunrise"] as? Int,
        let sunset = sysJSON["sunset"] as? Int
        else {
          return nil
      }
      
      if city?.sys == nil {
        city?.sys = NSEntityDescription.insertNewObject(forEntityName: "Sys",
                                                        into: (UIApplication.shared.delegate as! AppDelegate)
                                                          .managedObjectContext) as? Sys
      }
      
      city?.sys?.sunrise = Int32(sunrise)
      city?.sys?.sunset = Int32(sunset)
      
      CoreDataManager.share.saveContext()
      
      if isNeedPost {
        NotificationCenter.default
          .post(name:Notification.Name.updateTable,
                object:self,
                userInfo:nil)
      }
    }
    
    return city
  }
}
