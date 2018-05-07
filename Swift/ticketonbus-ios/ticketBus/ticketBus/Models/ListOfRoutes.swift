//
//  ListOfRoutes.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation

class ListOfRoutes {
  var route_start_station: String?
  var route_end_station: String?
  var departure_station: String?
  var arrival_station: String?
  var departure_date: String?
  var departure_time: String?
  var arrival_date: String?
  var arrival_time: String?
  var on_the_way: String?
  var adult: Tarif?
  var child: Tarif?
  var available_seats: Int?
  var bus_model: String?
  var bus_carrier: String?
  var bus_capacity: Int?
  var sale: Int?
  var status: Int?

  init(
    route_start_station: String?,
    route_end_station: String?,
    departure_station: String?,
    arrival_station: String?,
    departure_date: String?,
    departure_time: String?,
    arrival_date: String?,
    arrival_time: String?,
    on_the_way: String?,
    adult: Tarif?,
    child: Tarif?,
    available_seats: Int?,
    bus_model: String?,
    bus_carrier: String?,
    bus_capacity: Int?,
    sale: Int?,
    status: Int?) {
      self.route_start_station = route_start_station
      self.route_end_station = route_end_station
      self.departure_station = departure_station
      self.arrival_station = arrival_station
      self.departure_date = departure_date
      self.departure_time = departure_time
      self.arrival_date = arrival_date
      self.arrival_time = arrival_time
      self.on_the_way = on_the_way
      self.adult = adult
      self.child = child
      self.available_seats = available_seats
      self.bus_model = bus_model
      self.bus_carrier = bus_carrier
      self.bus_capacity = bus_capacity
      self.sale = sale
      self.status = status
  }
}
