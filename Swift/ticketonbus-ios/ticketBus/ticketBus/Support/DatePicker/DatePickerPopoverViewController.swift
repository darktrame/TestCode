//
//  DatePickerPopoverViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.17.
//  Copyright © 2017 ElateSoftware. All rights reserved.
//

import UIKit

class DatePickerPopoverViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet private weak var datePicker: UIDatePicker!
  
  // MARK: - Variables
  weak var delegate: DatePickerPopoverDelegate?
  var currentDate: Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if currentDate != nil {
      datePicker.date = currentDate!
    }
    
    datePicker.maximumDate = Date()
  }
  
  // MARK: - Actions
  @IBAction func done(_ sender: UIButton) {
    delegate?.datePicker(didFinishPicking: datePicker.date)
    dismiss(animated: true, completion: nil)
  }
}

protocol DatePickerPopoverDelegate: class {
  func datePicker(didFinishPicking date: Date)
}
