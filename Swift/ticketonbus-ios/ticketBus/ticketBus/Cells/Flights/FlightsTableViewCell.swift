//
//  FlightsTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 30.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class FlightsTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var timeAndDateLabel: UILabel!
  @IBOutlet weak var routeStartStationLabel: UILabel!
  @IBOutlet weak var onTheWayLabel: UILabel!
  @IBOutlet weak var arrivalTimeAndDateLabel: UILabel!
  @IBOutlet weak var routeEndStationLabel: UILabel!
  @IBOutlet weak var busCarrierLabel: UILabel!
  @IBOutlet weak var typeBusLabel: UILabel!
  @IBOutlet weak var availableSeatsLabel: UILabel!
  @IBOutlet weak var buyButton: UIButton!
  
  @IBOutlet weak var heightButtonConstraint: NSLayoutConstraint!
  @IBOutlet weak var topButtonConstraint: NSLayoutConstraint!
  
  // MARK: - Variables
  var route: ListOfRoutes?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.backgroundColor = .white
    buyButton.isEnabled = true
    buyButton.alpha = 1.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if let object = route {
      timeAndDateLabel.text = "\(object.departure_time ?? "NuN"),  \(object.departure_date ?? "NuN")"
      routeStartStationLabel.text = "\(object.route_start_station ?? "NuN") (\(object.departure_station ?? "NuN"))"
      onTheWayLabel.text = object.on_the_way
      arrivalTimeAndDateLabel.text = "\(object.arrival_time ?? "NuN"),  \(object.arrival_date ?? "NuN")"
      routeEndStationLabel.text = "\(object.arrival_station ?? "NuN") (\(object.route_end_station ?? "NuN"))"
      busCarrierLabel.text = object.bus_carrier
      typeBusLabel.text = object.bus_model
      availableSeatsLabel.text = String(object.bus_capacity ?? 0) + " / " + String(object.available_seats ?? 0)
      
      buyButton.setTitle("КУПИТЬ ЗА \(String(format: "%.2f", object.adult?.amount ?? 0.0)) Р", for: .normal)
      
      if let available_seats = object.available_seats {
        if available_seats == 0 {
          backgroundColor = .lightGray
          buyButton.isEnabled = false
          buyButton.alpha = 0.5
          buyButton.setTitle("Нет мест.", for: .normal)
        }
      }
    }
  }
}
