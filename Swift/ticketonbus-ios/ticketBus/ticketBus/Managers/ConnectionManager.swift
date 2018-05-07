//
//  ConnectionManager.swift
//  ticketBus
//
//  Created by Elatesoftware on 28.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ConnectionManager {
  static let share = ConnectionManager()
  static var currentUser: Profile?
  
  private var authKeyValue: String? {
    return "Bearer aYgBNuJkQT6NujbN2U0poS2k71jZoCgra11XXDBnRLW1J1GsfKcxXbXV28FQ"
  }
  
  var requestHeaders : HTTPHeaders {
    var headers: HTTPHeaders = [:]
    if let token = authKeyValue {
      headers["Authorization"] = token
    }
    
    headers["Content-type:"] = "application/json"
    
    return headers
  }
  
  private let mainLink = URL(string: "https://api.ticketonbus.ru/v1/json")!
  
  internal func apiRequest(method: HTTPMethod, parameters: Parameters?,
                           completion: @escaping (_ response: JSON?, _ error: String?) -> Void) {
    Alamofire.request(mainLink,
                      method: method, parameters: parameters,
                      encoding: JSONEncoding.default, headers: requestHeaders).responseJSON { (respond) in
                        if let data = respond.data {
                          completion(JSON(data: data), nil)
                        } else {
                          completion(nil, "Error json!")
                        }
    }
  }
  
  // MARK: - Auth
  func authUser(_ userName: String, pincode: Int? = nil, password: String? = nil,
                completion: @escaping (_ response: (username: String, user_id: Int, user_token: String)?, _ error: String?) -> Void) {
    var parameters: Parameters = ["action" :"loginUser",
                                  "username": userName]
    
    if pincode == nil && password != nil {
      parameters["password"] = password
    }
    
    if pincode != nil && password == nil {
      parameters["pincode"] = pincode
    }
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let error = respond?["error"] {
        if error == 0 {
          if let json = respond?["results"] {
            guard
              let username = json["username"].string,
              let user_id = json["user_id"].int,
              let user_token = json["user_token"].string
            else {
              completion(nil, "Ошибка сервера!")
              return
            }
            
            completion((username, user_id, user_token), nil)
          }
        } else {
          completion(nil, respond?["description"].string)
        }
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  // MARK: - API
  func getListOfDepartureStations(completion: @escaping (_ response: Array<String>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action" :"getListOfDepartureStations"]
    
    apiRequest(method: .post,
               parameters: parameters) { (respond, error) in
                if let json = respond {
                  let parser = JSONParser()
                  completion(parser.parseListOfDepartureStations(json), nil)
                } else {
                  completion(nil, "Ошибка сервера!")
                }
    }
  }
  
  func getListOfArrivalStations(_ departure_station: String,
                                completion: @escaping (_ response: Array<ListOfArrivalStations>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action" :"getListOfArrivalStations",
                                  "departure_station": departure_station]
    
    apiRequest(method: .post,
               parameters: parameters) { (respond, error) in
                if let json = respond {
                  let parser = JSONParser()
                  completion(parser.parseListOfArrivalStations(json), nil)
                } else {
                  completion(nil, "Ошибка сервера!")
                }
    }
  }
  
  func getListOfRoutes(_ departure_date: String, departure_station: String, arrival_station: String,
                       number_of_seats: Int, completion: @escaping (_ response: Array<ListOfRoutes>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getListOfRoutes",
                                  "departure_station": departure_station,
                                  "departure_date": departure_date,
                                  "arrival_station": arrival_station,
                                  "number_of_seats": 0,
                                  "full_data": 1]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseListOfRoutes(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func getRouteSeats(_ departure_station: String, departure_date: String,
                     departure_time: String, arrival_station: String,
                     number_of_seats: Int, completion: @escaping (_ response: RouteSeats?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getRouteSeats",
                                  "departure_station": departure_station,
                                  "departure_date": departure_date,
                                  "departure_time": departure_time,
                                  "arrival_station": arrival_station,
                                  "number_of_seats": number_of_seats]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseRouteSeats(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func getGetUser(_ completion: @escaping (_ response: Profile?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getUser",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseProfile(json), error)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func updateUser(_ profile: Profile, _ completion: @escaping (_ response: Profile?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "updateUser",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? "",
                                  "email": profile.email ?? "",
                                  "phone": profile.phone ?? "",
                                  "date_of_birth": profile.date_of_birth ?? "",
                                  "gender": profile.gender ?? "",
                                  "surname": profile.surname ?? "",
                                  "firstname": profile.firstname ?? "",
                                  "patronymic": profile.patronymic ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseProfile(json), error)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func deleteUser(_ completion: @escaping (_ response: Bool?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "deleteUser",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        if let code = json["error"].int {
          if code == 0 {
            completion(true, nil)
          } else {
            completion(false, "Произошла ошибка!")
          }
        } else {
          completion(false, "Произошла ошибка!")
        }
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func getListOfCountries(_ completion: @escaping (_ response: Array<ListOfArrivalStations>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getListOfCountries"]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseListOfArrivalStations(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func getListOfDocuments(_ completion: @escaping (_ response: Array<String>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getListOfDocuments"]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseListOfDepartureStations(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func getUserTickets(_ completion: @escaping (_ response: Array<UserTickets>?, _ error: String?) -> Void) {
    let parameters: Parameters = ["action": "getUserTickets",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseUserTickets(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
  
  func checkUser(username: String, _ completion: @escaping (_ userSuccess: Bool,_ error: String?) -> Void) {
    let parameters: Parameters = ["action": "checkUser",
                                  "username": username]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        if let error = json["error"].int {
          if error == 1 {
            completion(false, nil)
          }
        }
        
        if let user_id = json["results"]["user_id"].int {
          User.user_id = user_id
          
          completion(true, nil)
        }
        
        completion(false, "Ошибка сервера!")
      } else {
        completion(false, "Ошибка сервера!")
      }
    }
  }
  
  func newUser(_ dataUser: UserData?, completion: @escaping (_ error: String?) -> Void) {
    let parameters: Parameters = ["action": "newUser",
                                  "email": dataUser?.mainEmail ?? "",
                                  "phone": dataUser?.phone ?? "",
                                  "surname": dataUser?.family ?? "",
                                  "firstname": dataUser?.name ?? "",
                                  "patronymic": dataUser?.part ?? "",
                                  "gender": dataUser?.sex ?? "",
                                  "date_of_birth": dataUser?.dateBirth ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        if let error = json["error"].int {
          if error == 0 {
            completion(nil)
          } else {
            completion("Произошла ошибка, попробуйте позднее.")
          }
        }
      } else {
        completion("Ошибка сервера!")
      }
    }
  }
  
  func refundUserInsurance(_ insurance_id: String?,
                           completion: @escaping (_ error: String?) -> Void) {
    let parameters: Parameters = ["action": "refundUserInsurance",
                                  "insurance_id": insurance_id ?? "",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        if let error = json["error"].int {
          if error != 0 {
            completion("Произошла ошибка при возврате билета!")
          } else {
            completion(nil)
          }
        }
      } else {
        completion("Ошибка сервера!")
      }
    }
  }
  
  func refundTickets(_ ticket_id: Int,
                     completion: @escaping (_ error: String?) -> Void) {
    let parameters: Parameters = ["action": "newUserRefundForm",
                                  "user_id": User.user_id,
                                  "user_token": User.user_token ?? "",
                                  "ticket_id": ticket_id,
                                  "file_form": "",
                                  "file_ticket": "",
                                  "file_passport": ""]
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        if let error = json["error"].int {
          if error != 0 {
            completion("Произошла ошибка при возврате билета!")
          } else {
            completion(nil)
          }
        }
      } else {
        completion("Ошибка сервера!")
      }
    }
  }
  
  func newOrder(_ selectedSeats: [Int], dataInCells: [UserData],
                insurance: [Int], currentRoute: ListOfRoutes?,
                completion: @escaping (_ response: NewOrder?, _ error: String?) -> Void) {
    var parameters: Parameters = ["action": "newOrder",
                                  "user_id": User.user_id,
                                  "route_start_station": currentRoute?.route_start_station ?? "",
                                  "route_end_station": currentRoute?.route_end_station ?? "",
                                  "departure_station": currentRoute?.departure_station ?? "",
                                  "departure_date": currentRoute?.departure_date ?? "",
                                  "departure_time": currentRoute?.departure_time ?? "",
                                  "arrival_station": currentRoute?.arrival_station ?? "",
                                  "arrival_date": currentRoute?.arrival_date ?? "",
                                  "arrival_time": currentRoute?.arrival_time ?? "",
                                  "carrier": currentRoute?.bus_carrier ?? "",
                                  "model": currentRoute?.bus_model ?? "",
                                  "capacity": currentRoute?.bus_capacity ?? 0,
                                  "number_of_seats": selectedSeats.count,
                                  "phone": dataInCells.first?.phone ?? ""]
    
    var parametersArray: Parameters = [:]
    
    for (index, object) in dataInCells.enumerated() {
      if let serial = object.seriaAndNuber {
        let partDocumets = serial.components(separatedBy: " ")
        let parametersJSON: Parameters = ["surname": object.family ?? "",
                                          "firstname": object.name ?? "",
                                          "patronymic": object.part ?? "",
                                          "document": object.identification ?? "",
                                          "document_series": partDocumets.first ?? "",
                                          "document_number": partDocumets.last ?? "",
                                          "date_of_birth": object.dateBirth ?? "",
                                          "nationality": object.nationality ?? "",
                                          "gender": object.sex ?? "",
                                          "insurance": insurance[index]]
        parametersArray[String(selectedSeats[index])] = parametersJSON
      }
    }
    
    parameters["tickets"] = parametersArray
    
    apiRequest(method: .post, parameters: parameters) { (respond, error) in
      if let json = respond {
        let parser = JSONParser()
        completion(parser.parseNewOrder(json), nil)
      } else {
        completion(nil, "Ошибка сервера!")
      }
    }
  }
}
