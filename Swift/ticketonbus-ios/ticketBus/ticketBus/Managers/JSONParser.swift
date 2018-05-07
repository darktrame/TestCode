//
//  JSONParser.swift
//  ticketBus
//
//  Created by Elatesoftware on 31.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
  func parseListOfDepartureStations(_ json: JSON) -> Array<String> {
    guard let resultArray = json["results"].array else {
      return [String]()
    }
    
    var array = [String]()
    
    for object in resultArray {
      guard let stringObject = object.string else {
        continue
      }
      
      array.append(stringObject)
    }
    
    return array
  }
  
  func parseListOfArrivalStations(_ json: JSON) -> Array<ListOfArrivalStations> {
    guard let resultDictionary = json["results"].dictionary else {
      return [ListOfArrivalStations]()
    }
    
    var array = [ListOfArrivalStations]()
    
    for object in resultDictionary.keys {
      guard let place = resultDictionary[object]?.string else {
        continue
      }
      
      let placeStruct = ListOfArrivalStations(id: object, place: place)
      array.append(placeStruct)
    }
    
    return array
  }
  
  func parseListOfRoutes(_ json: JSON) -> Array<ListOfRoutes> {
    guard let resultArray = json["results"].array else {
      return [ListOfRoutes]()
    }
    
    var array = [ListOfRoutes]()
    for dictionaryObject in resultArray {
      let routeObject = ListOfRoutes(route_start_station: dictionaryObject["route_start_station"].string,
                                     route_end_station: dictionaryObject["route_end_station"].string,
                                     departure_station: dictionaryObject["departure_station"].string,
                                     arrival_station: dictionaryObject["arrival_station"].string,
                                     departure_date: dictionaryObject["departure_date"].string,
                                     departure_time: dictionaryObject["departure_time"].string,
                                     arrival_date: dictionaryObject["arrival_date"].string,
                                     arrival_time: dictionaryObject["arrival_time"].string,
                                     on_the_way: dictionaryObject["on_the_way"].string,
                                     adult: parseTarrifJSON(dictionaryObject["adult"]),
                                     child: parseTarrifJSON(dictionaryObject["child"]),
                                     available_seats: dictionaryObject["available_seats"].int,
                                     bus_model: dictionaryObject["bus_model"].string,
                                     bus_carrier: dictionaryObject["bus_carrier"].string,
                                     bus_capacity: dictionaryObject["bus_capacity"].int,
                                     sale: dictionaryObject["sale"].int,
                                     status: dictionaryObject["status"].int)
      
      array.append(routeObject)
    }
    
    return array
  }
  
  private func parseTarrifJSON(_ json: JSON) -> Tarif {
    return Tarif(tariff: json["tariff"].float,
                 commission: json["commission"].float,
                 service_charge: json["service_charge"].float,
                 agent_charge: json["agent_charge"].float,
                 amount: json["amount"].float,
                 insurance: json["insurance"].float)
  }
  
  func parseRouteSeats(_ json: JSON) -> RouteSeats? {
    if let results = json["results"].dictionary {
      guard
        let transaction = results["transaction"]?.string,
        let id = results["id"]?.string,
        let number_of_seats = results["number_of_seats"]?.int,
        let available_seats = results["available_seats"]?.string
      else {
        return nil
      }
      
      guard !available_seats.isEmpty else {
        return nil
      }
      
      let available_seats_array = available_seats.components(separatedBy: ",")
      let available_seats_array_int = available_seats_array.flatMap{ Int($0)! }
      
      return RouteSeats(transaction: transaction, id: id,
                        number_of_seats: number_of_seats,
                        available_seats: available_seats_array_int)
    }
    
    return nil
  }
  
  func parseProfile(_ json: JSON) -> Profile? {
    if let results = json["results"].dictionary {
      guard let id = results["id"]?.int else {
        return nil
      }
      
      let profile = Profile(phone: results["phone"]?.string ?? "",
                            gender: results["gender"]?.string ?? "",
                            date_of_birth: results["date_of_birth"]?.string ?? "",
                            id: id,
                            surname: results["surname"]?.string ?? "",
                            firstname: results["firstname"]?.string ?? "",
                            username: results["username"]?.string ?? "",
                            email: results["email"]?.string ?? "",
                            fullname: results["fullname"]?.string ?? "",
                            patronymic: results["patronymic"]?.string ?? "")
      
      ConnectionManager.currentUser = profile
      
      return profile
    }
    
    return nil
  }
  
  // MARK: - Parse tickets user
  func parseUserTickets(_ json: JSON) -> Array<UserTickets>? {
    guard let resultArray = json["results"].array else {
      return nil
    }
    
    var array = [UserTickets]()
    
    for ticket in resultArray {
      let object = UserTickets(seat: ticket["seat"].int,
                               comission: ticket["comission"].int,
                               refund_id: ticket["refund_id"].int,
                               patronymic: ticket["patronymic"].string,
                               amount: ticket["amount"].double,
                               firstname: ticket["firstname"].string,
                               user_id: ticket["user_id"].int,
                               tariff: ticket["tariff"].int,
                               date_of_birth: ticket["date_of_birth"].string,
                               insurance_id: ticket["insurance_id"].int,
                               order_id: ticket["order_id"].int,
                               createdon: ticket["createdon"].string,
                               agent_charge: ticket["agent_charge"].double,
                               id: ticket["id"].int,
                               number: ticket["number"].string,
                               ticket_type: ticket["ticket_type"].string,
                               series: ticket["series"].string,
                               surname: ticket["surname"].string,
                               route_id: ticket["route_id"].int,
                               insurance: parseInsurance(ticket["insurance"]),
                               route: parseRoute(ticket["route"]),
                               refund: parseRefund(ticket["refund"]),
                               order: parseOrder(ticket["order"]),
                               file: ticket["file"].string)
      
      array.append(object)
    }
    
    return array
  }
  
  func parseInsurance(_ json: JSON) -> Insurance {
    return Insurance(status: json["status"].int,
                     amount: json["amount"].int,
                     refund_enabled: json["refund_enabled"].int,
                     status_description: json["status_description"].string,
                     to_pay: json["to_pay"].int,
                     file: json["file"].string)
  }
  
  func parseRoute(_ json: JSON) -> Route {
    return Route(capacity: json["capacity"].string,
                 id: json["id"].int,
                 model: json["model"].string,
                 carrier: json["carrier"].string,
                 route_start_station: json["route_start_station"].string,
                 route_end_station: json["route_end_station"].string,
                 departure_date: json["departure_date"].string)
  }
  
  func parseRefund(_ json: JSON) -> Refund {
    return Refund(status: json["status"].int,
                  to_pay: json["to_pay"].double,
                  enabled: json["enabled"].int,
                  text: json["text"].string)
  }
  
  func parseOrder(_ json: JSON) -> Order {
    return Order(arrival_station: json["arrival_station"].string,
                 phone: json["phone"].string,
                 amount: json["amount"].string,
                 id: json["id"].string,
                 createdon: json["createdon"].string,
                 tds_order_id: json["tds_order_id"].string,
                 on_the_way: json["on_the_way"].string,
                 arrival_date: json["arrival_date"].string,
                 departure_station: json["departure_station"].string,
                 departure_date: json["departure_date"].string)
  }
  
  func parseNewOrder(_ json: JSON) -> NewOrder? {
    if let results = json["results"].dictionary {
      guard
        let order_id = results["order_id"]?.int,
        let amount = results["amount"]?.float,
        let paylink = results["paylink"]?.string
      else {
        return nil
      }
      
      return NewOrder(order_id: order_id, amount: amount, link: paylink)
    }

    return nil
  }
}
