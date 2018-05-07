//
//  UserData.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import Foundation

//@IBOutlet weak var familyTextField: ATTextField!
//@IBOutlet weak var nameTextField: ATTextField!
//@IBOutlet weak var partTextField: ATTextField!
//@IBOutlet weak var placeBornTextField: ATTextField!
//@IBOutlet weak var dateBirthTextField: ATTextField!
//@IBOutlet var sexButtons: [UIButton]!
//@IBOutlet weak var nationalityTextField: ATTextField!
//@IBOutlet weak var identificationTextField: ATTextField!
//@IBOutlet weak var seriaAndNuberTextField: ATTextField!
//@IBOutlet weak var phoneTextField: ATTextField!
//@IBOutlet weak var mainEmailTextField: ATTextField!
//@IBOutlet weak var confirmEmailTextField: ATTextField!

class UserData {
  var family: String?
  var name: String?
  var part: String?
  var placeBorn: String?
  var dateBirth: String?
  var sex: String?
  var nationality: String?
  var identification: String?
  var seriaAndNuber: String?
  var phone: String?
  var mainEmail: String?
  var confirmEmail: String?
  
  init() {
    self.nationality = "РОССИЯ"
    self.identification = "Паспорт РФ"
    self.sex = "male"
    self.phone = "+7"
  }
  
  init(family: String?,
       name: String?,
       part: String?,
       placeBorn: String?,
       dateBirth: String?,
       sex: String?,
       nationality: String?,
       identification: String?,
       seriaAndNuber: String?,
       phone: String?,
       mainEmail: String?,
       confirmEmail: String?) {
    self.family = family
    self.name = name
    self.part = part
    self.placeBorn = placeBorn
    self.dateBirth = dateBirth
    self.sex = sex
    self.nationality = nationality
    self.identification = identification
    self.seriaAndNuber = seriaAndNuber
    self.phone = phone
    self.mainEmail = mainEmail
    self.confirmEmail = confirmEmail
  }
}
