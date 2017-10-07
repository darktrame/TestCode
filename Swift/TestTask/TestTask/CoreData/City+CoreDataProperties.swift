//
//  City+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension City {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
    return NSFetchRequest<City>(entityName: "City")
  }

  @NSManaged public var cod: Int32
  @NSManaged public var dt: Int32
  @NSManaged public var id: Int32
  @NSManaged public var visibility: Int32
  @NSManaged public var name: String?
  @NSManaged public var coord: Coord?
  @NSManaged public var weather: NSSet?
  @NSManaged public var main: Main?
  @NSManaged public var wind: Wind?
  @NSManaged public var sys: Sys?
}

// MARK: Generated accessors for weather
extension City {
  @objc(addWeatherObject:)
  @NSManaged public func addToWeather(_ value: Weather)

  @objc(removeWeatherObject:)
  @NSManaged public func removeFromWeather(_ value: Weather)

  @objc(addWeather:)
  @NSManaged public func addToWeather(_ values: NSSet)

  @objc(removeWeather:)
  @NSManaged public func removeFromWeather(_ values: NSSet)
}
