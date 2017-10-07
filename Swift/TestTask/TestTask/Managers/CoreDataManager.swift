//
//  CoreDataManager.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
  static let share = CoreDataManager()
  
  lazy var newCoord: Coord? = {
    return NSEntityDescription.insertNewObject(forEntityName: "Coord",
                                               into: (UIApplication.shared.delegate as! AppDelegate)
                                                .managedObjectContext) as! Coord
  }()
  
  lazy var newMain: Main? = {
    return NSEntityDescription.insertNewObject(forEntityName: "Main",
                                               into: (UIApplication.shared.delegate as! AppDelegate)
                                                .managedObjectContext) as! Main
  }()
  
  lazy var newWind: Wind? = {
    return NSEntityDescription.insertNewObject(forEntityName: "Wind",
                                               into: (UIApplication.shared.delegate as! AppDelegate)
                                                .managedObjectContext) as! Wind
  }()
  
  lazy var newSys: Sys? = {
    return NSEntityDescription.insertNewObject(forEntityName: "Sys",
                                               into: (UIApplication.shared.delegate as! AppDelegate)
                                                .managedObjectContext) as! Sys
  }()
  
  func getAllCitys() -> [City]? {
    let citysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
    
    do {
      let fetchedCitys = try (UIApplication.shared.delegate as! AppDelegate)
        .managedObjectContext.fetch(citysFetch) as! [City]
      return fetchedCitys
    } catch {
      fatalError("Failed to fetch employees: \(error)")
    }
  }
  
  func getCity(_ id: Int) -> City? {
    let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
    cityFetch.predicate = NSPredicate(format: "id == %d", id)
    
    do {
      let fetchedCity = try (UIApplication.shared.delegate as! AppDelegate)
        .managedObjectContext.fetch(cityFetch) as! [City]
      return fetchedCity.first
    } catch {
      fatalError("Failed to fetch employees: \(error)")
    }
  }
  
  func removeCity(_ id: Int) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
    cityFetch.predicate = NSPredicate(format: "id == %d", id)
    
    cityFetch.returnsObjectsAsFaults = false
    
    do {
      let results = try managedContext.fetch(cityFetch)
      for managedObject in results {
        let managedObjectData = managedObject as! NSManagedObject
        managedContext.delete(managedObjectData)
      }
      
      //saveContext()
    } catch let error as NSError {
      print("Detele all data in error : \(error) \(error.userInfo)")
    }
  }
  
  func saveContext() {
    do {
      try (UIApplication.shared.delegate as! AppDelegate)
        .managedObjectContext.save()
    } catch {
      fatalError("Failure to save context: \(error)")
    }
  }
}
