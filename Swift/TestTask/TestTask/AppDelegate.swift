//
//  AppDelegate.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  // MARK: - Variables
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    IQKeyboardManager.sharedManager().enable = true
    if UIApplication.shared.isInternetAvailable() {
      let firstRun = UserDefaults.standard.bool(forKey: "FirstRun")
      
      if !firstRun {
        if let citys = CoreDataManager.share.getAllCitys() {
          if citys.count == 0 {
            ConnectionManager.share.getWeather(forName: "Moskow", completion: {_ in})
            _ = ConnectionManager.share.getWeather(forName: "London", completion: {_ in})
            _ = ConnectionManager.share.getWeather(forName: "Minsk", completion: {_ in})
            _ = ConnectionManager.share.getWeather(forName: "Ostin", completion: {_ in})
            _ = ConnectionManager.share.getWeather(forName: "Boston", completion: {_ in})
            
            return true
          }
        }
      }
      
      if let citys = CoreDataManager.share.getAllCitys() {
        for city in citys {
          if let name = city.name {
            _ = ConnectionManager.share.getWeather(forName: name, completion: {_ in})
          }
        }
      }
      
      UserDefaults.standard.set(true, forKey: "FirstRun")
    }
    
    return true
  }
  
  // MARK: - Core Data stack
  lazy var applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: "WeatherModel", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
    } catch {
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
  
  func deleteAllData(entity: String) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      for managedObject in results {
        let managedObjectData = managedObject as! NSManagedObject
        managedContext.delete(managedObjectData)
      }
    } catch let error as NSError {
      print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
    }
  }
}

