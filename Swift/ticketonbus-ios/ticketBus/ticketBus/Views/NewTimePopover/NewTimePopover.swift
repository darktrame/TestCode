//
//  DatePickerPopoverViewController.swift
//  ticketBus
//
//  Created by ElateSoftware on 01.09.17.
//  Copyright © 2017 ElateSoftware. All rights reserved.
//

import UIKit

protocol NewTimePopoverDelegate {
  func datePicker(didFinishPicking: Date)
}

class NewTimePopover: UIViewController {
  // MARK: - Outlets
  @IBOutlet private weak var datePicker: UIDatePicker!
  
  // MARK: - Variables
  var delegate: NewTimePopoverDelegate?
  var currentDate: Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if currentDate != nil {
      datePicker.date = currentDate!
      datePicker.minimumDate = Date()
    }
  }
  
  // MARK: - Actions
  @IBAction func done(_ sender: UIButton) {
    if let respond = delegate?.datePicker(didFinishPicking: datePicker.date) {
      respond
    }
    
    dismiss(animated: true, completion: nil)
  }
}
