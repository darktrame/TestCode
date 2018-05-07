//
//  BoughtTicketsTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 12.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class BoughtTicketsTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var departure_date: UILabel!
  @IBOutlet weak var departure_station: UILabel!
  @IBOutlet weak var on_the_way: UILabel!
  @IBOutlet weak var arrival_date: UILabel!
  @IBOutlet weak var arrival_station: UILabel!
  @IBOutlet weak var full_name: UILabel!
  @IBOutlet weak var seat: UILabel!
  @IBOutlet weak var ticket_type: UILabel!
  @IBOutlet weak var carrier: UILabel!
  @IBOutlet weak var model: UILabel!
  @IBOutlet weak var capacity: UILabel!
  
  // MARK: - Variables
  var currentTicket: UserTickets?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if let ticket = currentTicket {
      departure_date.text = ticket.order?.departure_date
      departure_station.text = "\(ticket.route?.route_start_station ?? "NuN") (\(ticket.order?.departure_station ?? "NuN"))"
      on_the_way.text = ticket.order?.on_the_way
      arrival_date.text = ticket.order?.arrival_date
      arrival_station.text = "\(ticket.order?.arrival_station ?? "NuN") (\(ticket.route?.route_end_station ?? "NuN"))"
      full_name.text = "\(ticket.surname ?? "") \(ticket.firstname ?? "") \(ticket.patronymic ?? "")"
      seat.text = String(ticket.seat ?? 0)
      carrier.text = ticket.route?.carrier
      model.text = ticket.route?.model
      capacity.text = ticket.route?.capacity

      let now = Date()
      
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = "dd.MM.yyyy"
      
      var isChildren = false
      if let userDate = currentTicket?.date_of_birth {
        if let data = dateFormater.date(from: userDate) {
          let timeInterval = Double(data.timeIntervalSince1970)
          
          let birthday: Date = Date(timeIntervalSince1970: timeInterval)
          
          let calendar = Calendar.current
          
          let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
          let age = ageComponents.year!
          
          isChildren = age < 12
        }
      }
      
      ticket_type.text = "\(isChildren ? "Детский" : "Полный")"
    }
  }
}
