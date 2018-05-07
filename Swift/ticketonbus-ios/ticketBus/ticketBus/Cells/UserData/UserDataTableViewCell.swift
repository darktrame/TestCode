//
//  UserDataTableViewCell.swift
//  ticketBus
//
//  Created by Elatesoftware on 21.09.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

protocol UserDataTableViewCellDelegate {
  func newSex(_ tag: Int, cell: UITableViewCell)
}

class UserDataTableViewCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet weak var numberOfSeatsLabel: UILabel!
  @IBOutlet weak var arrowImageView: UIImageView!
  @IBOutlet weak var activeView: UIView!
  
  @IBOutlet weak var familyTextField: ATTextField!
  @IBOutlet weak var nameTextField: ATTextField!
  @IBOutlet weak var partTextField: ATTextField!
  @IBOutlet weak var placeBornTextField: ATTextField!
  @IBOutlet weak var dateBirthTextField: ATTextField!
  @IBOutlet var sexButtons: [UIButton]!
  @IBOutlet weak var nationalityTextField: ATTextField!
  @IBOutlet weak var identificationTextField: ATTextField!
  @IBOutlet weak var seriaAndNuberTextField: ATTextField!
  @IBOutlet weak var phoneTextField: AKMaskField!
  @IBOutlet weak var mainEmailTextField: ATTextField!
  @IBOutlet weak var confirmEmailTextField: ATTextField!
  
  @IBOutlet weak var dateStackView: UIStackView!
  @IBOutlet weak var nationalityStackView: UIStackView!
  @IBOutlet weak var identificationStackView: UIStackView!
  @IBOutlet weak var emailStack: UIStackView!
  @IBOutlet weak var confirmEmailStack: UIStackView!
  @IBOutlet weak var phoneStack: UIStackView!
  @IBOutlet weak var countryImage: UIImageView!
  
  @IBOutlet weak var contView: UIView!
  
  // MARK: - Variables
  var delegate: UserDataTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Actions
  @IBAction func sexsButtonAction(_ sender: UIButton) {
    for object in sexButtons {
      guard object.tag != sender.tag else {
        continue
      }
          
      object.setImage(#imageLiteral(resourceName: "radio_unactive"), for: .normal)
    }
    
    sender.setImage(#imageLiteral(resourceName: "radio_active"), for: .normal)
    
    if let respond = delegate?.newSex(sender.tag, cell: self) {
      respond
    }
  }
}
