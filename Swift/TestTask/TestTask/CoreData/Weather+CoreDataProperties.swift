//
//  Weather+CoreDataProperties.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData

extension Weather {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
    return NSFetchRequest<Weather>(entityName: "Weather")
  }

  @NSManaged public var id: Int32
  @NSManaged public var desc: String?
  @NSManaged public var main: String?
  @NSManaged public var icon: String?
  @NSManaged public var city: City?
}
