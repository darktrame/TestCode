//
//  MyTicketsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 04.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class MyTicketsViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet var sortButtons: [UIButton]!
  @IBOutlet var buttonsImageStackViews: [UIStackView]!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  let boughtTicketsCellIdentifier = String(describing: BoughtTicketsTableViewCell.self)
  
  let ticketPlusInsuranceIdentifier = String(describing: TicketPlusInsuranceTableViewCell.self)
  let returnOnlyInsuranceIdentifier = String(describing: ReturnOnlyInsuranceTableViewCell.self)
  let buyOnlyTicketIdentifier = String(describing: BuyOnlyTicketTableViewCell.self)
  let returnAllIdentifier = String(describing: ReturnAllTableViewCell.self)
  let returnOnlyTicketIdentifier = String(describing: ReturnOnlyTicketTableViewCell.self)
  
  var currentSortButton = SortButtons.departure
  var directionDownSort = true
  var tickets = [UserTickets]()
  
  let directionDownSortImageActive = #imageLiteral(resourceName: "filter_2_a")
  let directionDownSortImageUnactive = #imageLiteral(resourceName: "filter_2")
  
  let directionUpSortImageActive = #imageLiteral(resourceName: "filter_1_a")
  let directionUpSortImageUnactive = #imageLiteral(resourceName: "filter_1")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showLoadingView()
    
    tableView.tableFooterView = UIView()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.register(UINib(nibName: boughtTicketsCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: boughtTicketsCellIdentifier)
    tableView.register(UINib(nibName: ticketPlusInsuranceIdentifier, bundle: nil),
                       forCellReuseIdentifier: ticketPlusInsuranceIdentifier)
    tableView.register(UINib(nibName: returnOnlyInsuranceIdentifier, bundle: nil),
                       forCellReuseIdentifier: returnOnlyInsuranceIdentifier)
    tableView.register(UINib(nibName: buyOnlyTicketIdentifier, bundle: nil),
                       forCellReuseIdentifier: buyOnlyTicketIdentifier)
    tableView.register(UINib(nibName: returnAllIdentifier, bundle: nil),
                       forCellReuseIdentifier: returnAllIdentifier)
    tableView.register(UINib(nibName: returnOnlyTicketIdentifier, bundle: nil),
                       forCellReuseIdentifier: returnOnlyTicketIdentifier)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    getTickets()
    
    removeTitleBackBarButtonItem()
  }
  
  // MARK: - Methods
  func getTickets() {
    ConnectionManager.share.getUserTickets { (result, error) in
      if let list = result {
        self.tickets = list
        
        DispatchQueue.main.async {
          self.hiddeLoadingView()
          self.tableView.reloadData()
        }
      } else {
        DispatchQueue.main.async {
          self.hiddeLoadingView()
          
          if error != nil {
            let alert = UIApplication.shared.showAlert(error!, title: "")
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  func hiddeLoadingView() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 0.0
    }
  }
  
  func showLoadingView() {
    UIView.animate(withDuration: 0.3) {
      self.loadingView.alpha = 1.0
    }
    
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func getTupleTimeFromObjects(_ object1: UserTickets, object2: UserTickets, isDeparture: Bool) -> (timeObject1: Int, timeObject2: Int)? {
    let timeIntObject1 = isDeparture ? object1.route?.departure_date?.getSecondDateAndTimeFromString(false) : object1.order?.arrival_date?.getSecondDateAndTimeFromString(true)
    let timeIntObject2 = isDeparture ? object2.route?.departure_date?.getSecondDateAndTimeFromString(false) : object2.order?.arrival_date?.getSecondDateAndTimeFromString(true)

    guard
      timeIntObject1 != nil,
      timeIntObject2 != nil
      else {
        return nil
    }

    return (timeIntObject1!, timeIntObject2!)
  }
  
  func sortList() {
    tickets = tickets.sorted(by: { (object1, object2) -> Bool in
      switch currentSortButton {
      case .departure:
        if let resultInts = getTupleTimeFromObjects(object1, object2: object2, isDeparture: true) {
          return !directionDownSort ? resultInts.timeObject1 > resultInts.timeObject2 : resultInts.timeObject1 < resultInts.timeObject2
        }
        return false
      case .arrival:
        if let resultInts = getTupleTimeFromObjects(object1, object2: object2, isDeparture: false) {
          return !directionDownSort ? resultInts.timeObject1 > resultInts.timeObject2 : resultInts.timeObject1 < resultInts.timeObject2
        }
        return false
      case .tariff:
        return !directionDownSort ? object1.amount! > object2.amount! : object1.amount! < object2.amount!
      }
    })
    
    tableView.reloadData()
  }
  
  func setItemsInButton() {
    for object in sortButtons {
      object.setTitleColor(currentSortButton.rawValue == object.tag ? UIColor.blackTextColor : UIColor.unselectedTextButtonColor,
                           for: .normal)
    }
    
    for object in buttonsImageStackViews {
      if object.tag == currentSortButton.rawValue {
        for image in object.arrangedSubviews {
          if directionDownSort {
            if (image as! UIImageView).tag == 0 {
              (image as! UIImageView).image = directionUpSortImageUnactive
            } else {
              (image as! UIImageView).image = directionDownSortImageActive
            }
          } else {
            if (image as! UIImageView).tag == 0 {
              (image as! UIImageView).image = directionUpSortImageActive
            } else {
              (image as! UIImageView).image = directionDownSortImageUnactive
            }
          }
        }
      } else {
        for image in object.arrangedSubviews {
          (image as! UIImageView).image = (image as! UIImageView).tag == 0 ? directionUpSortImageUnactive : directionDownSortImageUnactive
        }
      }
    }
    
    sortList()
  }
  
  func getTicketsStatusCell(_ statusTicket: Int, statusInsurance: Int) -> UITableViewCell {
    var currentCellIdent = ""
    
    switch (statusTicket, statusInsurance) {
    case (-1, 1):
      currentCellIdent = buyOnlyTicketIdentifier
    case (-1, 2):
      currentCellIdent = ticketPlusInsuranceIdentifier
    case (-1, 0):
      currentCellIdent = returnOnlyInsuranceIdentifier
    case (1, 0):
      currentCellIdent = returnAllIdentifier
    case (1, 1):
      currentCellIdent = returnOnlyTicketIdentifier
    default:
      currentCellIdent = returnAllIdentifier
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: currentCellIdent) else {
      return UITableViewCell()
    }
    
    cell.backgroundColor = .clear
    cell.selectionStyle = .none
    
    return cell
  }
  
  // MARK: - Actions
  @IBAction func sortButtonsAction(_ sender: UIButton) {
    if let tapSortButton = SortButtons(rawValue: sender.tag) {
      if currentSortButton == tapSortButton {
        directionDownSort = !directionDownSort
      } else {
        currentSortButton = tapSortButton
        directionDownSort = false
      }
    }
    
    setItemsInButton()
  }
  
  @objc func getTicket(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Билет"
      
      if let cell = sender.superview?.superview as? UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else {
          return
        }
        
        let object = tickets[Int(Double(index.row) / 2.0)]
        if let file = object.file {
          controller.link = file
        }
      }
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @objc func getInsurance(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Страховка"
      
      if let cell = sender.superview?.superview as? UITableViewCell {
        guard let index = tableView.indexPath(for: cell) else {
          return
        }
        
        let object = tickets[Int(Double(index.row) / 2.0)]
        if let file = object.insurance?.file {
          controller.link = file
        }
      }
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @objc func returnTicket(_ sender: UIButton) {
    let alert = UIAlertController(title: "", message: "Вы действительно хотите вернуть билет?", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    let ok = UIAlertAction(title: "Вернуть", style: .default) { (action) in
      if let cell = sender.superview?.superview as? UITableViewCell {
        guard let index = self.tableView.indexPath(for: cell) else {
          return
        }
        
        let object = self.tickets[Int(Double(index.row) / 2.0)]
        self.showLoadingView()
        ConnectionManager.share.refundTickets(object.id ?? 0, completion: { (error) in
          if error == nil {
            self.getTickets()
          } else {
            DispatchQueue.main.async {
              self.hiddeLoadingView()
              let alert = UIApplication.shared.showAlert(error!, title: "")
              self.present(alert, animated: true, completion: nil)
            }
          }
        })
      }
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func returnInsurance(_ sender: UIButton) {
    let alert = UIAlertController(title: "", message: "Вы действительно хотите вернуть страховку?", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    let ok = UIAlertAction(title: "Вернуть", style: .default) { (action) in
      if let cell = sender.superview?.superview as? UITableViewCell {
        guard let index = self.tableView.indexPath(for: cell) else {
          return
        }
        
        let object = self.tickets[Int(Double(index.row) / 2.0)]
        self.showLoadingView()
        ConnectionManager.share.refundUserInsurance(String(object.insurance_id ?? 0), completion: { (error) in
          if error == nil {
            self.getTickets()
          } else {
            DispatchQueue.main.async {
              self.hiddeLoadingView()
              let alert = UIApplication.shared.showAlert(error!, title: "")
              self.present(alert, animated: true, completion: nil)
            }
          }
        })
      }
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension MyTicketsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tickets.count * 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if Double(indexPath.row).truncatingRemainder(dividingBy: 2.0) == 0.0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: boughtTicketsCellIdentifier)
        as? BoughtTicketsTableViewCell else {
          return UITableViewCell()
      }

      cell.currentTicket = tickets[Int(Double(indexPath.row) / 2.0)]
      cell.selectionStyle = .none
      
      return cell
    } else {
      let route = tickets[Int(Double(indexPath.row) / 2.0)]
      
      let ins: Int? = 1
      guard
        let statusTicket = route.refund?.status,
        let statusInsurance = route.insurance?.status ?? ins
      else {
        return UITableViewCell()
      }
      
      let cell = getTicketsStatusCell(statusTicket, statusInsurance: statusInsurance)
      
      if cell.isKind(of: TicketPlusInsuranceTableViewCell.self) {
        (cell as! TicketPlusInsuranceTableViewCell).costTicket.text = "\(String(format: "%.2f", route.amount ?? 0.0)) Р"
        (cell as! TicketPlusInsuranceTableViewCell).costInsurance.text = "\(String(format: "%.2f", Double(route.insurance?.amount ?? 0))) Р"
        
        (cell as! TicketPlusInsuranceTableViewCell).getTicketButton.addTarget(self, action: #selector(getTicket(_:)), for: .touchUpInside)
        (cell as! TicketPlusInsuranceTableViewCell).getInsuranceButton.addTarget(self, action: #selector(getInsurance(_:)), for: .touchUpInside)
        (cell as! TicketPlusInsuranceTableViewCell).returnTicketButton.addTarget(self, action: #selector(returnTicket(_:)), for: .touchUpInside)
        (cell as! TicketPlusInsuranceTableViewCell).returnInsuranceButton.addTarget(self, action: #selector(returnInsurance(_:)), for: .touchUpInside)
        
        (cell as! TicketPlusInsuranceTableViewCell).ticketLink = route.file ?? ""
        (cell as! TicketPlusInsuranceTableViewCell).insuranceLink = route.insurance?.file ?? ""
      }
      
      if cell.isKind(of: ReturnOnlyInsuranceTableViewCell.self) {
        (cell as! ReturnOnlyInsuranceTableViewCell).costTicket.text = "\(String(format: "%.2f", route.amount ?? 0.0)) Р"
        (cell as! ReturnOnlyInsuranceTableViewCell).costInsurance.text = "\(String(format: "%.2f", Double(route.insurance?.amount ?? 0))) Р"
        (cell as! ReturnOnlyInsuranceTableViewCell).getTicketButton.addTarget(self, action: #selector(getTicket(_:)), for: .touchUpInside)
        (cell as! ReturnOnlyInsuranceTableViewCell).returnTicketButton.addTarget(self, action: #selector(returnTicket(_:)), for: .touchUpInside)
        (cell as! ReturnOnlyInsuranceTableViewCell).costReturnInsurance.text = "\(String(format: "%.2f", Double(route.insurance?.to_pay ?? 0))) Р"
        (cell as! ReturnOnlyInsuranceTableViewCell).ticketLink = route.file ?? ""
      }
      
      if cell.isKind(of: BuyOnlyTicketTableViewCell.self) {
        (cell as! BuyOnlyTicketTableViewCell).costTicket.text = "\(String(format: "%.2f", route.amount ?? 0.0)) Р"
        (cell as! BuyOnlyTicketTableViewCell).getTicketButton.addTarget(self, action: #selector(getTicket(_:)), for: .touchUpInside)
        (cell as! BuyOnlyTicketTableViewCell).returnTicketButton.addTarget(self, action: #selector(returnTicket(_:)), for: .touchUpInside)
      }
      
      if cell.isKind(of: ReturnAllTableViewCell.self) {
        (cell as! ReturnAllTableViewCell).costTicket.text = "\(String(format: "%.2f", route.amount ?? 0.0)) Р"
        (cell as! ReturnAllTableViewCell).costInsurance.text = "\(String(format: "%.2f", Double(route.insurance?.amount ?? 0))) Р"
        (cell as! ReturnAllTableViewCell).returnCostTicket.text = "\(String(format: "%.2f", route.refund?.to_pay ?? 0.0)) Р"
        (cell as! ReturnAllTableViewCell).returnInsuranceCost.text = "\(String(format: "%.2f", Double(route.insurance?.to_pay ?? 0))) Р"
      }
      
      if cell.isKind(of: ReturnOnlyTicketTableViewCell.self) {
        (cell as! ReturnOnlyTicketTableViewCell).returnCost.text = "\(String(format: "%.2f", route.refund?.to_pay ?? 0.0)) Р"
        (cell as! ReturnOnlyTicketTableViewCell).costTicket.text = "\(String(format: "%.2f", route.amount ?? 0.0)) Р"
      }
      
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension MyTicketsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
