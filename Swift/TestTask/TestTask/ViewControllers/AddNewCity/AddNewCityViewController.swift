//
//  AddNewCityViewController.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

protocol AddNewCityViewControllerDelegate: class {
  func addNewCity(_ name: String)
}

class AddNewCityViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var newCityTextField: ATTextField!

  // MARK: - Variables
  var delegate: AddNewCityViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Actions
  @IBAction func cancelButtonAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func enterButtonAction(_ sender: UIButton) {
    if let respond = delegate?.addNewCity(newCityTextField.text!) {
      respond
    }
    
    dismiss(animated: true, completion: nil)
  }
}
