//
//  LeftViewController.swift
//  
//

class LeftViewController: UITableViewController {
  // MARK: - Variables
  var selectedIndex = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.blueTicketBusColor
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .fade
  }
  
  func newController(_ controller: UIViewController, index: Int) {
    NavigationController.shared?.viewControllers = [controller]
    selectedIndex = index
  }
}

// MARK: - UITableViewDataSource
extension LeftViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 12
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(indexPath.row)) else {
      return UITableViewCell()
    }
    
    cell.backgroundColor = .clear
    cell.selectionStyle = .none
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension LeftViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 147.0
    } else {
      return 50.0
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.row {
    case 1:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = SearchFlightsViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 2:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if !User.isAuthorized {
          if let controller = AuthViewController.viewController() {
            newController(controller, index: indexPath.row)
          }
        } else {
          if let controller = ProfileUserViewController.viewController() {
            newController(controller, index: indexPath.row)
          }
        }
      }
    case 3:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = AboutUsViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 4:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = HowBuyViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 5:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = HowReturnViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 6:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = TravelWithCildrenViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 7:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = TransportAnimalViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 8:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = TransportBagaggeViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 9:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = InsuranceViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 10:
      hideLeftViewAnimated(nil)
      if selectedIndex != indexPath.row {
        if let controller = ContactsViewController.viewController() {
          newController(controller, index: indexPath.row)
        }
      }
    case 11:
      let email = "support@ticketonbus.ru"
      if let url = URL(string: "mailto:\(email)") {
        UIApplication.shared.openURL(url)
      }
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    if indexPath.row != 0 {
      if let selectedCell = tableView.cellForRow(at: indexPath) {
        selectedCell.contentView.backgroundColor = .blueSelectTableCellColor
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    if indexPath.row != 0 {
      if let selectedCell = tableView.cellForRow(at: indexPath) {
        selectedCell.contentView.backgroundColor = .clear
      }
    }
  }
}
