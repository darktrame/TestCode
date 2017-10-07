//
//  ConnectionManager.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ConnectionManager {
  static let share = ConnectionManager()
  
  func getWeather(forName name: String, isNeedPost: Bool = true, completion: @escaping (_ result: City?) -> Void) {
    let urlWeather = "http://api.openweathermap.org/data/2.5/weather?q=\(name)&APPID=437a888a929a2675aab668f9c2adcd72"
  
    guard let stringURLWeater = URL(string: urlWeather) else {
      return
    }
  
    let session = URLSession.shared
    let URLRequestWeater = URLRequest(url: stringURLWeater)
  
    let task = session.dataTask(with: URLRequestWeater, completionHandler: { (data, response, error) in
      guard error == nil else {
        print("error calling GET on /todos/1")
        print(error ?? "")
        return
      }
  
      guard let responseData = data else {
        print("Error: did not receive data")
        return
      }
  
      do {
        guard let todo = try JSONSerialization.jsonObject(with: responseData,
                                                          options: []) as? [String: AnyObject] else {
          print("error trying to convert data to JSON")
          return
        }
        
        let parser = JSONParser()
        completion(parser.parseWeather(todo, isNeedPost: isNeedPost))
      } catch {
        print("error")
      }
    })
    
    task.resume()
  }
}
