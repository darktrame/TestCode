//
//  Sys+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension Sys {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Sys> {
    return NSFetchRequest<Sys>(entityName: "Sys")
  }

  @NSManaged public var sunrise: Int32
  @NSManaged public var sunset: Int32
  @NSManaged public var city: City?
}
