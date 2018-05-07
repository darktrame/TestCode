//
//  ListDocumentsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

protocol ListDocumentsViewControllerDelegate {
  func getCountry(_ newObject: String, isCountry: Bool)
}

class ListDocumentsViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: - Variables
  var listOfArrivalStations = [ListOfArrivalStations]()
  var filterListOfArrivalStations = [ListOfArrivalStations]()
  var identiList = [String]()
  var nameSearch: String?
  var currentOperation: Operation?
  
  var isCountry = false
  
  var delegate: ListDocumentsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    showLoadingView()
    
    if isCountry {
      title = "Выберите страну"
      
      searchBar.delegate = self
      searchBar.setValue("Отмена", forKey:"_cancelButtonText")
      searchBar.tintColor = UIColor.blueTicketBusColor
      
      ConnectionManager.share.getListOfCountries({ (respond, error) in
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
    } else {
      tableView.tableHeaderView = nil
      
      title = "Выберите документ"
      
      ConnectionManager.share.getListOfDocuments({ (respond, error) in
        if let list = respond {
          self.identiList = list
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
      guard let filterString = nameSearch?.uppercased() else {
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
extension ListDocumentsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isCountry ? filterListOfArrivalStations.count : identiList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "listOfArrival")
      as? ListOfArrivalTableViewCell else {
        return UITableViewCell()
    }
    
    cell.placeLabel.text = isCountry ? filterListOfArrivalStations[indexPath.row].place : identiList[indexPath.row]
    cell.backgroundColor = .clear
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListDocumentsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let cell = tableView.cellForRow(at: indexPath) as? ListOfArrivalTableViewCell {
      if let newName = cell.placeLabel.text {
        if let respond = self.delegate?.getCountry(newName, isCountry: self.isCountry) {
          respond
        }
      }
    }
    
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UISearchBarDelegate
extension ListDocumentsViewController: UISearchBarDelegate {
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

