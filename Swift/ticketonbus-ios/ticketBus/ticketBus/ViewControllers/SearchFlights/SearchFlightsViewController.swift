//
//  SearchFlightsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 16.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class SearchFlightsViewController: GlobalViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  let findFlightCellIdentifier = String(describing: FindFlightsTableViewCell.self)
  let filterDateCellIdentifier = String(describing: FilterDateTableViewCell.self)
  
  let findTextArray = ["Откуда", "Куда", "Дата", "Кол-во"]
  var list = [String]()
  
  var startStation: String? = nil
  var endStation: String = "Пункт прибытия"
  
  let countPeople = ["1 билет", "2 билета", "3 билета", "4 билета", "5 билетов"]
  var currentDate = Date()
  var isSelectredDate = true
  var indexCountPeople = 0
  
  var departure_date: String!
  var departure_station: String!
  var arrival_station: String?
  var number_of_seats: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    title = "Поиск рейсов"
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    registerTableView()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.backgroundColor = .blueTicketBusTableColor

    removeTitleBackBarButtonItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if list.isEmpty {
      showLoadingView()
      ConnectionManager.share.getListOfDepartureStations { (result, error) in
        if let list = result {
          self.list = list
          
          DispatchQueue.main.async {
            self.hiddeLoadingView()
            self.tableView.reloadData()
          }
        }
      }
    } else {
      self.hiddeLoadingView()
    }
  }
  // MARK: - Methods
  func registerTableView() {
    tableView.register(UINib(nibName: findFlightCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: findFlightCellIdentifier)
    tableView.register(UINib(nibName: filterDateCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: filterDateCellIdentifier)
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
  
  // MARK: - Actions
  @IBAction func searchButtonAction(_ sender: UIButton) {
    showLoadingView()
    ConnectionManager.share.getListOfRoutes(departure_date,
                                            departure_station: departure_station,
                                            arrival_station: arrival_station ?? "",
                                            number_of_seats: number_of_seats) { (result, error) in
                                              if error == nil {
                                                DispatchQueue.main.async {
                                                  if let controller = ResultSearchFlightsViewController.viewController() as? ResultSearchFlightsViewController {
                                                    if let list = result {
                                                      controller.number_of_seats = self.number_of_seats
                                                      controller.listOfRoutes = list
                                                    }
                                                    
                                                    self.navigationController?.pushViewController(controller, animated: true)
                                                  }
                                                }
                                              } else {
                                                DispatchQueue.main.async {
                                                  self.hiddeLoadingView()
                                                  self.present(UIApplication.shared.showAlert(error!, title: ""),
                                                               animated: true,
                                                               completion: nil)
                                                }
                                              }
    }
  }
  
  @objc func selectedItemSegmentedControll(_ sender: UISegmentedControl) {
    isSelectredDate = true
    
    switch sender.selectedSegmentIndex {
    case 0:
      self.currentDate = Date()
    case 1:
      let nextTime = Date().timeIntervalSince1970 + 86400
      self.currentDate = Date(timeIntervalSince1970: nextTime)
    case 2:
      let nextTime = Date().timeIntervalSince1970 + (86400 * 2)
      self.currentDate = Date(timeIntervalSince1970: nextTime)
    default:
      self.currentDate = Date()
      isSelectredDate = false
    }
    
    tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
  }
}

// MARK: - UITableViewDataSource
extension SearchFlightsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 1
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: findFlightCellIdentifier)
        as? FindFlightsTableViewCell else {
          return UITableViewCell()
      }
      
      cell.findLabel.text = findTextArray[indexPath.row]
      
      if indexPath.row == 2 {
        cell.imageFind.image = #imageLiteral(resourceName: "calendar_2")
        cell.startLabel.textColor = UIColor.blackTextColor
        cell.startLabel.text = currentDate.getStringDDMMYYE()
        
        departure_date = currentDate.getStringDDMMYY()
      } else {
        if indexPath.row == 0 {
          cell.startLabel.text = startStation ?? list.first
          cell.startLabel.textColor = UIColor.blackTextColor
          
          departure_station = cell.startLabel.text
        } else {
          if endStation != "Пункт прибытия" {
            cell.startLabel.text = endStation
            arrival_station = endStation
            cell.startLabel.textColor = UIColor.blackTextColor
          } else {
            cell.startLabel.textColor = UIColor.lightGray
          }
        }
      }
      
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: filterDateCellIdentifier)
        as? FilterDateTableViewCell else {
          return UITableViewCell()
      }
      
      cell.segmentedControll.selectedSegmentIndex = isSelectredDate ? cell.segmentedControll.selectedSegmentIndex : -1
      cell.segmentedControll.addTarget(self, action: #selector(selectedItemSegmentedControll(_:)), for: .valueChanged)
      
      cell.backgroundColor = .clear
      cell.selectionStyle = .none
      
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: findFlightCellIdentifier)
        as? FindFlightsTableViewCell else {
          return UITableViewCell()
      }
      
      cell.findLabel.text = findTextArray.last!
      cell.imageFind.image = #imageLiteral(resourceName: "ticket")
      cell.startLabel.text = countPeople[indexCountPeople]
      cell.startLabel.textColor = UIColor.blackTextColor
      
      if let people = cell.startLabel.text {
        let first = people[people.startIndex...people.index(people.startIndex, offsetBy: 0)]
        number_of_seats = Int(first)
      }
      
      return cell
    }

  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return nil
  }
}

// MARK: - UITableViewDelegate
extension SearchFlightsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.section == 0 {
      if indexPath.row < 2 {
        if let controller = ListTableViewController.viewController() as? ListTableViewController {
          controller.delegate = self
          
          if indexPath.row == 0 {
            controller.list = list
          } else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FindFlightsTableViewCell {
              controller.departure_station = cell.startLabel.text
            }
          }
          
          navigationController?.pushViewController(controller, animated: true)
        }
      } else {
        if let datePicker = NewTimePopover.viewController() as? NewTimePopover {
          datePicker.currentDate = currentDate
          datePicker.modalPresentationStyle = .popover
          datePicker.popoverPresentationController!.delegate = self
          
          if let cell = tableView.cellForRow(at: indexPath) {
            datePicker.popoverPresentationController!.sourceView = cell
          }
          
          datePicker.popoverPresentationController?.backgroundColor = UIColor.white
          datePicker.delegate = self
          present(datePicker, animated: true, completion: nil)
        }
      }
    } else {
      if indexPath.section > 1 {
        if let controller = ListTableViewController.viewController() as? ListTableViewController {
          controller.list = countPeople
          controller.isChooseCountTicket = true
          controller.delegate = self
          
          navigationController?.pushViewController(controller, animated: true)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25.0))
    headerView.backgroundColor = .clear
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 25.0
  }
}

// MARK: - ListTableViewControllerDelegate
extension SearchFlightsViewController: ListTableViewControllerDelegate {
  func getNewStation(_ newStation: String, isChooseArrivalStation: Bool) {
    if isChooseArrivalStation {
      endStation = newStation
    } else {
      startStation = newStation
      endStation = "Пункт прибытия"
    }
    
    self.tableView.reloadSections(IndexSet(integer: 0),
                                  with: .none)
  }
  
  func countTicket(_ index: Int) {
    indexCountPeople = index
    
    self.tableView.reloadSections(IndexSet(integer: 2),
                                  with: .none)
  }
}

// MARK: - DatePickerPopoverDelegate
extension SearchFlightsViewController: NewTimePopoverDelegate {
  func datePicker(didFinishPicking date: Date) {
    currentDate = date
    isSelectredDate = false
    
    tableView.reloadRows(at: [IndexPath(row: 2, section: 0),
                              IndexPath(row: 0, section: 1)],
                         with: .none)
  }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension SearchFlightsViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}
