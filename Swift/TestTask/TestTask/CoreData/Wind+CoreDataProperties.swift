//
//  Wind+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension Wind {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Wind> {
    return NSFetchRequest<Wind>(entityName: "Wind")
  }

  @NSManaged public var speed: Float
  @NSManaged public var deg: Int16
  @NSManaged public var city: City?
}
