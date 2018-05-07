//
//  ListTableViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 31.08.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

protocol ListTableViewControllerDelegate {
  func getNewStation(_ newStation: String, isChooseArrivalStation: Bool)
  func countTicket(_ index: Int)
}

class ListTableViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: - Variables
  var departure_station: String?
  var list = [String]()
  var listOfArrivalStations = [ListOfArrivalStations]()
  var filterListOfArrivalStations = [ListOfArrivalStations]()
  var nameSearch: String?
  var currentOperation: Operation?
  
  var isChooseCountTicket = false
  
  var delegate: ListTableViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    if departure_station == nil {
      tableView.tableHeaderView = nil
      
      if !isChooseCountTicket {
        title = "Выберите место отправления"
      } else {
        title = "Выберите кол-во билетов"
      }
      
      hiddeLoadingView()
    } else {
      searchBar.delegate = self
      searchBar.setValue("Отмена", forKey:"_cancelButtonText")
      searchBar.tintColor = UIColor.blueTicketBusColor
      
      title = departure_station
      
      showLoadingView()
      
      ConnectionManager.share.getListOfArrivalStations(departure_station!, completion: { (respond, error) in
        if var list = respond {
          list = list.sorted(by: { (object1, object2) -> Bool in
            let place1 = object1.place.lowercased()
            let place2 = object2.place.lowercased()
            return place1 < place2
          })
          
          self.listOfArrivalStations = list
          self.filterListOfArrivalStations = list
          
          DispatchQueue.main.async {
            self.hiddeLoadingView()
            self.tableView.reloadData()
          }
        }
      })
    }
    
    tableView.tableFooterView = UIView()
    
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  // MARK: - Methods
  func filterPlaces() -> [ListOfArrivalStations]? {
    var filterList = [ListOfArrivalStations]()
    for object in listOfArrivalStations {
      guard let filterString = nameSearch else {
        return listOfArrivalStations
      }
      
      if filterString.characters.count > 0 && (object.place as NSString).range(of: filterString).location == NSNotFound {
        continue
      }
      
      if object.place.contains(filterString) {
        filterList.append(object)
      }
    }
    
    return filterList
  }
  
  func hiddeLoadingView() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    
    UIView.animate(withDuration: 0.3) { 
      self.loadingView.alpha = 0.0
    }
  }
  
  func showLoadingView() {
    loadingView.alpha = 1.0
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func backgroundFilterArrayInSearch() {
    self.currentOperation?.cancel()
    
    self.filterListOfArrivalStations = self.listOfArrivalStations
    self.currentOperation = BlockOperation(block: {
      if let newList = self.filterPlaces() {
        self.filterListOfArrivalStations = newList
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    })
    
    self.currentOperation?.start()
  }
}

// MARK: - UITableViewDataSource
extension ListTableViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if departure_station == nil {
      return list.count
    } else {
      return filterListOfArrivalStations.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "listOfArrival")
      as? ListOfArrivalTableViewCell else {
      return UITableViewCell()
    }
    
    if departure_station == nil {
      cell.placeLabel.text = list[indexPath.row]
    } else {
      cell.placeLabel.text = filterListOfArrivalStations[indexPath.row].place
    }
    
    cell.backgroundColor = .clear
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let cell = tableView.cellForRow(at: indexPath) as? ListOfArrivalTableViewCell {
      if let newStation = cell.placeLabel.text {
        if !isChooseCountTicket {
          if let respond = delegate?.getNewStation(newStation, isChooseArrivalStation: departure_station == nil ? false : true) {
            respond
          }
        } else {
          if let respond = delegate?.countTicket(indexPath.row) {
            respond
          }
        }
      }
    }
    
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UISearchBarDelegate
extension ListTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if !searchText.isEmpty {
      nameSearch = searchText
    } else {
      nameSearch = nil
    }
    
    backgroundFilterArrayInSearch()
  }
}
