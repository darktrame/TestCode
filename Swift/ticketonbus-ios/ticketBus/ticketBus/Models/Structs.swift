//
//  PlaceLastFlight.swift
//  ticketBus
//
//  Created by Elatesoftware on 01.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation
import UIKit

struct ListOfArrivalStations {
  var id: String
  var place: String
}

struct Tarif {
  var tariff: Float?
  var commission: Float?
  var service_charge: Float?
  var agent_charge: Float?
  var amount: Float?
  var insurance: Float?
}

struct RouteSeats {
  var transaction: String
  var id: String
  var number_of_seats: Int
  var available_seats: [Int]
}

// MARK: - My Tickets
struct Insurance {
  var status: Int?
  var amount: Int?
  var refund_enabled: Int?
  var status_description: String?
  var to_pay: Int?
  var file: String?
}

struct Route {
  var capacity: String?
  var id: Int?
  var model: String?
  var carrier: String?
  var route_start_station: String?
  var route_end_station: String?
  var departure_date: String?
}

struct Refund {
  var status: Int?
  var to_pay: Double?
  var enabled: Int?
  var text: String?
}

struct Order {
  var arrival_station: String?
  var phone: String?
  var amount: String?
  var id: String?
  var createdon: String?
  var tds_order_id: String?
  var on_the_way: String?
  var arrival_date: String?
  var departure_station: String?
  var departure_date: String?
}

struct NewOrder {
  var order_id: Int
  var amount: Float
  var link: String
}
