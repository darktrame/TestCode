//
//  ViewUserDataTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 06.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

protocol ViewUserDataTableViewCellDelegate {
  func currentCost(_ ticket: Float, insurance: Float, indexPath: IndexPath)
}

class ViewUserDataTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var seat: UILabel!
  @IBOutlet weak var full_name: UILabel!
  @IBOutlet weak var placeBorn: UILabel!
  @IBOutlet weak var date_of_birth: UILabel!
  @IBOutlet weak var sex: UILabel!
  @IBOutlet weak var nationality: UILabel!
  @IBOutlet weak var document: UILabel!
  @IBOutlet weak var cost_ticket: UILabel!
  
  @IBOutlet weak var rulInsurenceButton: ATButton!
  @IBOutlet weak var offerButton: ATButton!
  
  @IBOutlet weak var need_insuranceButton: UIButton!
  
  // MARK: - Variables
  var currentTicket: UserData?
  var number = 0
  var costAdult: Float?
  var costChildren: Float?
  var costInsuranseAdult: Float?
  var costInsuranseChild: Float?
  var currentCost: String = ""
  var currentInsuranceCost: String = ""
  var indexPath: IndexPath = IndexPath(row: 0, section: 0)
  
  var delegate: ViewUserDataTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if let user = currentTicket {
      seat.text = "Место \(number): "
      full_name.text = "\(user.family ?? "") \(user.name ?? "") \(user.part ?? "")"
      placeBorn.text = user.placeBorn
      date_of_birth.text = user.dateBirth
      
      if let sexUser = user.sex {
        sex.text = sexUser == "male" ? "Мужской" : "Женский"
      }
      
      let now = Date()
      
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = "dd.MM.yyyy"
      
      var isChildren = false
      
      if let userDate = user.dateBirth {
        if let data = dateFormater.date(from: userDate) {
          let timeInterval = Double(data.timeIntervalSince1970)
          
          let birthday: Date = Date(timeIntervalSince1970: timeInterval)
          
          let calendar = Calendar.current
          
          let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
          let age = ageComponents.year!
          
          isChildren = age < 12
        }
      }
      
      nationality.text = user.nationality
      document.text = "\(user.identification ?? "") \(user.seriaAndNuber ?? "")"
      
      currentCost = String(format: "%.2f", isChildren ? costChildren ?? 0.0 : costAdult ?? 0.0)
      cost_ticket.text = "\(currentCost) P (\(isChildren ? "Детский" : "Полный"))"
      
      currentInsuranceCost = String(Int(isChildren ? costInsuranseChild ?? 0.0 : costInsuranseAdult ?? 0.0))
      need_insuranceButton.setTitle("\(currentInsuranceCost) P", for: .normal)
      
      if let respond = delegate?.currentCost(Float(currentCost) ?? 0.0,
                                             insurance: Float(currentInsuranceCost) ?? 0.0,
                                             indexPath: indexPath) {
        respond
      }
    }
  }
}
