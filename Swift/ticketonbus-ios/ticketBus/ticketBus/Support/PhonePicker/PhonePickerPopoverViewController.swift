//
//  DatePickerPopoverViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.17.
//  Copyright © 2017 ElateSoftware. All rights reserved.
//

import UIKit

class PhonePickerPopoverViewController: UIViewController, CountryPickerDelegate {
  // MARK: - Outlets
  @IBOutlet private weak var phonePicker: CountryPicker!
  
  // MARK: - Variables
  var delegate: PhonePickerPopoverDelegate?
  var currentCode: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let code = currentCode ?? "RU"
    
    phonePicker.countryPickerDelegate = self
    phonePicker.setCountry(code)
  }
  
  // MARK: - Actions
  @IBAction func done(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
    if let respond = delegate?.phonePicker(didFinishPicking: countryCode, phoneCode: phoneCode, flag: flag) {
      respond
    }
  }
}

protocol PhonePickerPopoverDelegate: class {
  func phonePicker(didFinishPicking countryCode: String, phoneCode: String, flag: UIImage)
}
