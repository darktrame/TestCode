//
//  ChooseSitesViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ChooseSitesViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var bus_modelLabel: UILabel!
  @IBOutlet weak var countCopLabel: UILabel!
  @IBOutlet weak var ChoosedPlaceLabel: UILabel!
  @IBOutlet weak var choosenStackView: UIStackView!
  @IBOutlet weak var infoLabel: UILabel!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Variables
  var currentRoute: ListOfRoutes?
  var routeSeats: RouteSeats?
  
  let cellIdentifier = String(describing: SiteCollectionViewCell.self)
  
  var selectedSeats = [Int]()
  
  var colorCell = [(indexPath: IndexPath, color: UIColor, number: String, isHidden: Bool)]()
  
  var countSection = 0
  var countCells = 0
  
  var countHiddenCell = 0
  
  var isFive = false
  var isBus = true
  var is46 = false
  var isDes3 = false
  var lastIndex = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    choosenStackView.isHidden = true
    infoLabel.isHidden = false
    
    title = "Выбор места"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
    
    setUpNavigationBar()
    
    if let route = currentRoute {
      bus_modelLabel.text = route.bus_model
      
      if let capacity = route.bus_capacity {
        countCopLabel.text = String(capacity)
        
        if capacity <= 28 {
          isBus = false
        }
        
        if Double(capacity).truncatingRemainder(dividingBy: 4.0) == 1.0 {
          isFive = true
        }
        
        if Double(capacity).truncatingRemainder(dividingBy: 4.0) == 3.0 {
          isDes3 = true
          isFive = true
        }
        
        if Double(capacity).truncatingRemainder(dividingBy: 4.0) != 0.0 && Double(capacity).truncatingRemainder(dividingBy: 2.0) == 0.0 {
          is46 = true
          
          print(is46)
        }
        
        countCells = capacity + Int(Double(capacity) / 4.0)
      }
    }
    
    if isDes3 || isFive {
      countSection = 2
    } else {
      countSection = 1
    }
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: cellIdentifier)
    
    removeTitleBackBarButtonItem()
  }
  
  // MARK: - Methods
  func setUpNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее",
                                                        style: .plain,
                                                        target: self, action: #selector(nextStepBuyTicket))
  }
  
  func checkChoosenEmpty() {
    if !selectedSeats.isEmpty {
      infoLabel.isHidden = true
      choosenStackView.isHidden = false
    } else {
      infoLabel.isHidden = false
      choosenStackView.isHidden = true
    }
  }
  
  func setChooseSeatsFromUI() {
    let numbers_of_count = "(\(selectedSeats.count)/\(routeSeats?.number_of_seats ?? 0))"
    var choosen = ""
    
    for (index, object) in selectedSeats.enumerated() {
      if index + 1 != selectedSeats.count {
        choosen.append(String(object) + ",")
      } else {
        choosen.append(String(object))
      }
    }
    
    ChoosedPlaceLabel.text = choosen + " " + numbers_of_count
  }
  
  func calculating(_ section: Int, count: Int) {
    for i in 0..<count {
      let indexPath = IndexPath(row: i, section: section)
      var isHidden = false
      
      let index = lastIndex
      
      var indexInCell = ""
      if indexPath.section == 0 {
        if (Double(index).truncatingRemainder(dividingBy: 5.0) == 3.0)
          || (is46 && (indexPath.row == 28 || indexPath.row == 29))
          || (!isBus && !isFive && (indexPath.row == 13 || indexPath.row == 14)
            && Double((currentRoute?.bus_capacity)!).truncatingRemainder(dividingBy: 4.0) != 0.0)
          || (isDes3 && (indexPath.row == 3 || indexPath.row == 4)) {
          isHidden = true
          countHiddenCell += 1
        }
        
        indexInCell = String(index - countHiddenCell)
      } else {
        indexInCell = String(index - countHiddenCell)
      }
      
      var colorCell = UIColor.freeSiteColor
      
      if let freeSeat = routeSeats?.available_seats {
        colorCell = freeSeat.contains(index - countHiddenCell) ? UIColor.freeSiteColor : UIColor.boughtSiteColor
      }
      
      let appendObject: (indexPath: IndexPath, color: UIColor, number: String, isHidden: Bool) = (indexPath, colorCell, indexInCell, isHidden)
      self.colorCell.append(appendObject)
      
      lastIndex += 1
    }
  }
  
  // MARK: - Actions
  @objc func nextStepBuyTicket() {
    let alert = UIAlertController(title: "", message: "Я понимаю, что схема автобуса условна и реальная схема мест может быть другой",
                                  preferredStyle: .alert)
    let no = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
    let yes = UIAlertAction(title: "Да", style: .default) { (action) in
      if let controller = EnterUsersDataViewController.viewController() as? EnterUsersDataViewController {
        controller.currentRoute = self.currentRoute
        controller.selectedSeats = self.selectedSeats
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }

    alert.addAction(no)
    alert.addAction(yes)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func resetButtonAction(_ sender: ATButton) {
    for indexSeat in selectedSeats {
      if let index = self.colorCell.index(where: { (object) -> Bool in
        return object.number == String(indexSeat)
      }) {
        self.colorCell[index].color = UIColor.freeSiteColor
      }
    }
    
    selectedSeats.removeAll()
    checkChoosenEmpty()
  
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource
extension ChooseSitesViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return countSection
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isFive && !isDes3 {
      let count = section == 0 ? countCells - 6 : 5
      calculating(section, count: count)
      
      return count
    } else {
      if isFive && isDes3 {
        let count = section == 0 ? countCells - 3 : 5
        calculating(section, count: count)
        return count
      } else {
        if is46 {
          let count = countCells + 3
          calculating(section, count: count)
          
          return count
        } else {
          calculating(section, count: countCells)
          return countCells
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
      as? SiteCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    if let index = colorCell.index(where: { (object) -> Bool in
      return object.indexPath == indexPath
    }) {
      let object = colorCell[index]
      
      cell.layer.cornerRadius = cell.bounds.height / 2.0
      cell.isHidden = object.isHidden
      cell.viewSeat.backgroundColor = object.color
      cell.number_seat_label.text = object.number
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChooseSitesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? SiteCollectionViewCell {
      guard let index = Int(cell.number_seat_label.text!) else {
        return
      }
      
      if let freeSeat = routeSeats?.available_seats {
        if freeSeat.contains(index) {
          if let removeIndex = selectedSeats.index(where: { (object) -> Bool in
            return object == index
          }) {
            selectedSeats.remove(at: removeIndex)
            cell.viewSeat.backgroundColor = UIColor.freeSiteColor
            
            if let index = colorCell.index(where: { (object) -> Bool in
              return object.indexPath == indexPath
            }) {
              colorCell[index].color = UIColor.freeSiteColor
            }
            
          } else {
            if let number_of_seats = routeSeats?.number_of_seats {
              guard number_of_seats > selectedSeats.count else {
                return
              }
              
              selectedSeats.append(index)
              cell.viewSeat.backgroundColor = UIColor.selectedSiteColor
              
              if let index = colorCell.index(where: { (object) -> Bool in
                return object.indexPath == indexPath
              }) {
                colorCell[index].color = UIColor.selectedSiteColor
              }
            }
          }
        }
      }
      
      checkChoosenEmpty()
      setChooseSeatsFromUI()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
      return CGSize(width: 0, height: 40)
    } else {
      return CGSize.zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: 0, height: 20)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = UIScreen.main.bounds.size.height
    
    if height > 568.0 {
      return CGSize(width: 35.0, height: 35.0)
    } else {
      return CGSize(width: 30.0, height: 30.0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    let height = UIScreen.main.bounds.size.height
    
    if height > 568.0 {
      return 18.0
    } else {
      return 12.0
    }
  }
}









