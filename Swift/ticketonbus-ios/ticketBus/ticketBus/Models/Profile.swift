//
//  Profile.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class Profile {
  var phone: String?
  var gender: String?
  var date_of_birth: String?
  var id: Int!
  var surname: String?
  var firstname: String?
  var username: String?
  var email: String?
  var fullname: String?
  var patronymic: String?
  
  init(phone: String,
       gender: String,
       date_of_birth: String,
       id: Int,
       surname: String,
       firstname: String,
       username: String,
       email: String,
       fullname: String,
       patronymic: String) {
    self.phone = phone
    self.gender = gender
    self.date_of_birth = date_of_birth
    self.id = id
    self.surname = surname
    self.firstname = firstname
    self.username = username
    self.email = email
    self.fullname = fullname
    self.patronymic = patronymic
  }
}
