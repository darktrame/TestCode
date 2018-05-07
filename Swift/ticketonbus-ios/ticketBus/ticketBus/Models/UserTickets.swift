//
//  UserTickets.swift
//  ticketBus
//
//  Created by Elatesoftware on 10.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class UserTickets {
  var seat: Int?
  var comission: Int?
  var refund_id: Int?
  var patronymic: String?
  var amount: Double?
  var firstname: String?
  var user_id: Int?
  var tariff: Int?
  var date_of_birth: String?
  var insurance_id: Int?
  var order_id: Int?
  var createdon: String?
  var agent_charge: Double?
  var id: Int?
  var number: String?
  var ticket_type: String?
  var series: String?
  var surname: String?
  var route_id: Int?
  var insurance: Insurance?
  var route: Route?
  var refund: Refund?
  var order: Order?
  var file: String?
  
  init(seat: Int?,
       comission: Int?,
       refund_id: Int?,
       patronymic: String?,
       amount: Double?,
       firstname: String?,
       user_id: Int?,
       tariff: Int?,
       date_of_birth: String?,
       insurance_id: Int?,
       order_id: Int?,
       createdon: String?,
       agent_charge: Double?,
       id: Int?,
       number: String?,
       ticket_type: String?,
       series: String?,
       surname: String?,
       route_id: Int?,
       insurance: Insurance?,
       route: Route?,
       refund: Refund?,
       order: Order?,
       file: String?) {
    self.seat = seat
    self.comission = comission
    self.refund_id = refund_id
    self.patronymic = patronymic
    self.amount = amount
    self.firstname = firstname
    self.user_id = user_id
    self.tariff = tariff
    self.date_of_birth = date_of_birth
    self.insurance_id = insurance_id
    self.order_id = order_id
    self.createdon = createdon
    self.agent_charge = agent_charge
    self.id = id
    self.number = number
    self.ticket_type = ticket_type
    self.series = series
    self.surname = surname
    self.route_id = route_id
    self.insurance = insurance
    self.route = route
    self.refund = refund
    self.order = order
    self.file = file
  }
}
