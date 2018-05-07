//
//  ResultSearchFlightsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 30.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

enum SortButtons: Int {
  case departure
  case arrival
  case tariff
}

class ResultSearchFlightsViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyDataView: UIView!
  @IBOutlet var sortButtons: [UIButton]!
  @IBOutlet var buttonsImageStackViews: [UIStackView]!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  let flightsCellIdentifier = String(describing: FlightsTableViewCell.self)
  var listOfRoutes = [ListOfRoutes]()
  var currentSortButton = SortButtons.departure
  var directionDownSort = true
  
  let directionDownSortImageActive = #imageLiteral(resourceName: "filter_2_a")
  let directionDownSortImageUnactive = #imageLiteral(resourceName: "filter_2")
  
  let directionUpSortImageActive = #imageLiteral(resourceName: "filter_1_a")
  let directionUpSortImageUnactive = #imageLiteral(resourceName: "filter_1")
  
  var number_of_seats = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadingView.alpha = 0.0
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    tableView.tableFooterView = UIView()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UINib(nibName: flightsCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: flightsCellIdentifier)
    
    if listOfRoutes.count > 0 {
      emptyDataView.isHidden = true
    }
    
    removeTitleBackBarButtonItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = "Результаты поиска (\(listOfRoutes.count))"
  }
  
  // MARK: - Methods
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
  
  func getTupleTimeFromObjects(_ object1: ListOfRoutes, object2: ListOfRoutes, isDeparture: Bool) -> (timeObject1: Int, timeObject2: Int)? {
    let timeIntObject1 = isDeparture ? object1.departure_time?.getSecondTimeFromString() : object1.arrival_time?.getSecondTimeFromString()
    let timeIntObject2 = isDeparture ? object2.departure_time?.getSecondTimeFromString() : object2.arrival_time?.getSecondTimeFromString()
    
    let dateIntObject1 = isDeparture ? object1.departure_date?.getSecondDateFromString() : object1.arrival_date?.getSecondDateFromString()
    let dateIntObject2 = isDeparture ? object2.departure_date?.getSecondDateFromString() : object2.arrival_date?.getSecondDateFromString()
    
    guard
      timeIntObject1 != nil,
      timeIntObject2 != nil,
      dateIntObject1 != nil,
      dateIntObject2 != nil
      else {
        return nil
    }
    
    return (timeIntObject1! + dateIntObject1!, timeIntObject2! + dateIntObject2!)
  }
  
  func sortList() {
    listOfRoutes = listOfRoutes.sorted(by: { (object1, object2) -> Bool in
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
        return !directionDownSort ? object1.adult!.amount! > object2.adult!.amount! : object1.adult!.amount! < object2.adult!.amount!
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
  
  @objc func buyTicketButtonAction(_ sender: UIButton) {
    if let cell = sender.superview?.superview as? FlightsTableViewCell {
      showLoadingView()
      
      guard
        let departure_station = cell.route?.departure_station,
        let departure_date = cell.route?.departure_date,
        let departure_time = cell.route?.departure_time,
        let arrival_station = cell.route?.arrival_station
      else {
        hiddeLoadingView()
        let alert = UIApplication.shared.showAlert("Произошла ошибка. Попробуйте позже!", title: "")
        self.present(alert, animated: true, completion: nil)
        
        return
      }
      
      ConnectionManager.share.getRouteSeats(departure_station, departure_date: departure_date,
                                            departure_time: departure_time, arrival_station: arrival_station,
                                            number_of_seats: number_of_seats, completion: { (result, error) in
        if error == nil {
          DispatchQueue.main.async {
            self.hiddeLoadingView()
            
            if let routeSeats = result {
              if let controller = ChooseSitesViewController.viewController() as? ChooseSitesViewController {
                controller.currentRoute = cell.route
                controller.routeSeats = routeSeats
                self.navigationController?.pushViewController(controller, animated: true)
              }
            } else {
              self.hiddeLoadingView()
              let alert = UIApplication.shared.showAlert("Произошла ошибка. Попробуйте позже!", title: "")
              self.present(alert, animated: true, completion: nil)
            }
          }
        } else {
          self.hiddeLoadingView()
          
          let alert = UIApplication.shared.showAlert(error!, title: "")
          self.present(alert, animated: true, completion: nil)
        }
      })
    }
  }
}

// MARK: - UITableViewDataSource
extension ResultSearchFlightsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listOfRoutes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: flightsCellIdentifier)
      as? FlightsTableViewCell else {
      return UITableViewCell()
    }
    
    cell.route = listOfRoutes[indexPath.row]
    cell.selectionStyle = .none
    cell.buyButton.addTarget(self, action: #selector(buyTicketButtonAction(_:)), for: .touchUpInside)
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ResultSearchFlightsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
