//
//  Coord+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension Coord {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Coord> {
    return NSFetchRequest<Coord>(entityName: "Coord")
  }

  @NSManaged public var lon: Double
  @NSManaged public var lat: Double
  @NSManaged public var city: City?
}
