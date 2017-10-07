//
//  CitysListViewController.swift
//  TestTask
//
//  Created by Elatesoftware on 26.07.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class CitysListViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var loadingImage: UIImageView!
  
  // MARK: - Variables
  let cityCellIdentifier = String(describing: CityTableViewCell.self)
  var cityList: [City] = [City]()
  var isLoading = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !UIApplication.shared.isInternetAvailable() {
      present(UIApplication.shared.showAlert("Warning!",
                                             title: "No internet connection! The application will work offline."), animated: true)
      
      reloadTable()
    }
    
    startLoading()
    
    title = "List of Cities"
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    tableView.tableFooterView = UIView()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(UINib(nibName: cityCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: cityCellIdentifier)
    
    setBarButtonItems()
    
    removeTitleBackBarButtonItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(
      self, selector: #selector(reloadTable),
      name: NSNotification.Name.updateTable,
      object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self)
  }
  
  func startLoading() {
    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    
    animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi / 2.0), 0.0, 0.0, 1.0))
    animation.duration = 0.25
    animation.isCumulative = true
    animation.repeatCount = MAXFLOAT
    
    self.loadingImage.layer.add(animation, forKey: "loading")
    self.loadingImage.startAnimating()
  }
  
  // MARK: - Setting Navigation Bar
  func setBarButtonItems() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                             target: self,
                                                             action: #selector(addButtonPressed(_:)))
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(refresh(_:)))
  }
  
  // MARK: - Actions
  func reloadTable() {
    if let citys = CoreDataManager.share.getAllCitys() {
      cityList = citys
    }
    
    DispatchQueue.main.async {
      self.tableView.reloadData()
      
      if self.isLoading {
        self.isLoading = false
        self.loadingImage.stopAnimating()
        
        UIView.animate(withDuration: 0.3) {
          self.loadingView.alpha = 0.0
        }
      }
    }
  }
  
  func refresh(_ sender: UIBarButtonItem) {
    if !UIApplication.shared.isInternetAvailable() {
      present(UIApplication.shared.showAlert("Warning!",
                                             title: "No internet connection! The application will work offline."), animated: true)
    } else {
      if let citys = CoreDataManager.share.getAllCitys() {
        for city in citys {
          if let name = city.name {
            ConnectionManager.share.getWeather(forName: name, completion: {_ in})
          }
        }
      }
    }
  }
  
  func addButtonPressed(_ sender: UIBarButtonItem) {
    if !UIApplication.shared.isInternetAvailable() {
      present(UIApplication.shared.showAlert("Warning!",
                                             title: "No internet connection!"), animated: true)
    } else {
      if let controller = AddNewCityViewController.viewController() as? AddNewCityViewController {
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension CitysListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cityList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier)
      as? CityTableViewCell else {
      return UITableViewCell()
    }
    
    cell.city = cityList[indexPath.row]
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CitysListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let controller = DetailInformationViewController.viewController()
      as? DetailInformationViewController {
      controller.city = cityList[indexPath.row]
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .destructive,
                                            title: "Delete") { (action, indexPath) in
                                              tableView.beginUpdates()
                                              CoreDataManager.share.removeCity(Int(self.cityList[indexPath.row].id))
                                              self.cityList.remove(at: indexPath.row)
                                              tableView.deleteRows(at: [indexPath], with: .left)
                                              tableView.endUpdates()
    }
    
    deleteAction.backgroundColor = .red
    
    return [deleteAction]
  }
}

// MARK: - AddNewCityViewControllerDelegate
extension CitysListViewController: AddNewCityViewControllerDelegate {
  func addNewCity(_ name: String) {
    if !UIApplication.shared.isInternetAvailable() {
      present(UIApplication.shared.showAlert("Warning!",
                                             title: "No internet connection! The application will work offline."), animated: true)
    } else {
      ConnectionManager.share.getWeather(forName: name, completion: { result in
        if result != nil {
          DispatchQueue.main.async {
            self.reloadTable()
          }
        }
      })
    }
  }
}
