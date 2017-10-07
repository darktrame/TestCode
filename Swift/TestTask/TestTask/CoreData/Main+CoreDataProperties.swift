//
//  Main+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension Main {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Main> {
    return NSFetchRequest<Main>(entityName: "Main")
  }

  @NSManaged public var temp: Float
  @NSManaged public var pressure: Int32
  @NSManaged public var humidity: Int32
  @NSManaged public var temp_min: Float
  @NSManaged public var temp_max: Float
  @NSManaged public var city: City?
}
