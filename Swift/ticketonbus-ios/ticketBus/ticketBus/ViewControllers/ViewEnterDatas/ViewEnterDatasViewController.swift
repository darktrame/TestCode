//
//  ViewEnterDatasViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 06.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ViewEnterDatasViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var personalDataButton: UIButton!
  @IBOutlet weak var currentSum: UILabel!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  var currentRoute: ListOfRoutes?
  let flightsCellIdentifier = String(describing: FlightsTableViewCell.self)
  let viewUserDataTableViewCellIdentifier = String(describing: ViewUserDataTableViewCell.self)
  var selectedSeats = [Int]()
  var dataInCells = [UserData]()
  var insurance = [Int]()
  var sumTicket = [(ticket: Float, insurance: Float)]()
  var isConfirm = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Ввод данных"
    
    setUpNavigationBar()
    
    loadingView.alpha = 0.0
    loadingView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.backgroundColor = UIColor.blueTicketBusTableColor
    
    tableView.register(UINib(nibName: flightsCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: flightsCellIdentifier)
    tableView.register(UINib(nibName: viewUserDataTableViewCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: viewUserDataTableViewCellIdentifier)
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    
    insurance = Array<Int>(repeating: 1, count: selectedSeats.count)
    sumTicket = Array<(ticket: Float, insurance: Float)>(repeating: (0.0, 0.0), count: selectedSeats.count)
    
    tableView.dataSource = self
    
    removeTitleBackBarButtonItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    personalDataButtonAction(personalDataButton)
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
  
  func setUpNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(nextStep(_:)))
  }
  
  func setCurrentSum() {
    var sum: Float = 0.0
    for (index, object) in sumTicket.enumerated() {
      sum += object.ticket
      sum += insurance[index] == 1 ? object.insurance : 0.0
    }
    
    let sumString = String(format: "%.2f", sum)
    currentSum.text = "\(sumString) P"
  }
  
  func sendNewOrder() {
    ConnectionManager.share.newOrder(self.selectedSeats,
                                     dataInCells: self.dataInCells,
                                     insurance: self.insurance,
                                     currentRoute: self.currentRoute,
                                     completion: { (result, error) in
                                      DispatchQueue.main.async {
                                        if let order = result {
                                          self.hiddeLoadingView()
                                          
                                          if let controller = PayViewController.viewController() as? PayViewController {
                                            controller.link = order.link
                                            controller.cost = order.amount
                                            
                                            self.navigationController?.pushViewController(controller, animated: true)
                                          }
                                        } else {
                                          self.hiddeLoadingView()
                                          let alert = UIApplication.shared.showAlert(error ?? "Произошла ошибка, попробуйте позже!", title: "")
                                          self.present(alert, animated: true, completion: nil)
                                        }
                                      }
    })
  }
  
  // MARK: - Actions
  @IBAction func uslAction(_ sender: ATButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Условия"
      controller.link = "https://ticketonbus.ru/assets/media/policy.pdf"
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @IBAction func soglActionButton(_ sender: ATButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Соглашения на обработку персональных данных"
      controller.link = "https://ticketonbus.ru/assets/media/agreement.pdf"
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @IBAction func personalDataButtonAction(_ sender: UIButton) {
    if let image = sender.imageView?.image {
      sender.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
      sender.tag = sender.tag == 0 ? 1 : 0
      sender.alpha = sender.tag == 0 ? 0.5 : 1
      sender.imageView?.tintColor = sender.tag == 0 ? UIColor.blackTextColor : UIColor.orange
      
      isConfirm = sender.tag == 1
    }
  }
  
  @objc func nextStep(_ sender: UIBarButtonItem) {
    if !isConfirm {
      let alert = UIAlertController(title: "", message: "Необходимо дать согласие на обработку персональных данных",
                                    preferredStyle: .alert)
      let cancel = UIAlertAction(title: "Хорошо", style: .cancel, handler: nil)
      alert.addAction(cancel)
      
      self.present(alert, animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "", message: "Пожалуйста, подтвердите, что данные заполнены корректно",
                                    preferredStyle: .alert)
      let no = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
      let yes = UIAlertAction(title: "Да", style: .default, handler: { (action) in
        self.showLoadingView()

        if !User.isAuthorized {
          if let email = self.dataInCells.first?.confirmEmail {
            ConnectionManager.share.checkUser(username: email, { (isUser, error) in
              DispatchQueue.main.async {
                if isUser && error == nil {
                  self.sendNewOrder()
                } else {
                  if !isUser && error == nil {
                    ConnectionManager.share.newUser(self.dataInCells.first, completion: { (error) in
                      if error == nil {
                        ConnectionManager.share.authUser(email, completion: { (result, error) in
                          DispatchQueue.main.async {
                            if let controller = ConfirmSMSViewController.viewController() as? ConfirmSMSViewController {
                              controller.selectedSeats = self.selectedSeats
                              controller.dataInCells = self.dataInCells
                              controller.insurance = self.insurance
                              controller.currentRoute = self.currentRoute
                              controller.email = email
                              
                              self.navigationController?.pushViewController(controller, animated: true)
                            }
                          }
                        })
                      } else {
                        let alert = UIApplication.shared.showAlert(error!, title: "")
                        self.present(alert, animated: true, completion: nil)
                      }
                    })
                  }
                }
              }
            })
          }
        } else {
          self.sendNewOrder()
        }
      })
      
      alert.addAction(no)
      alert.addAction(yes)
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @objc func needInsuranceButtonAction(_ sender: UIButton) {
    if let image = sender.imageView?.image {
      sender.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
      
      sender.imageView?.tintColor = UIColor.orange
      sender.setTitleColor(UIColor.orange, for: .normal)
      
      if let cell = sender.superview?.superview?.superview?.superview as? ViewUserDataTableViewCell {
        if let index = tableView.indexPath(for: cell) {
          sender.tag = sender.tag == 0 ? 1 : 0
          sender.alpha = sender.tag == 0 ? 0.5 : 1
          sender.imageView?.tintColor = sender.tag == 0 ? UIColor.blackTextColor : UIColor.orange
          sender.setTitleColor(sender.tag == 0 ? UIColor.blackTextColor : UIColor.orange, for: .normal)
          
          insurance[index.row - 1] = sender.tag
        }
      }
    }
    
    setCurrentSum()
  }
  
  @objc func pushRuls(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Правила страхования"
      controller.link = "https://ticketonbus.ru/assets/media/insurance/rules.pdf"
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  @objc func pushOffer(_ sender: UIButton) {
    if let controller = WebViewController.viewController() as? WebViewController {
      controller.titleString = "Оферта"
      controller.link = "https://ticketonbus.ru/assets/media/insurance/offer.pdf"
      
      navigationController?.pushViewController(controller, animated: true)
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewEnterDatasViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedSeats.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: flightsCellIdentifier)
        as? FlightsTableViewCell else {
          return UITableViewCell()
      }
      
      cell.buyButton.isHidden = true
      cell.route = self.currentRoute
      cell.selectionStyle = .none
      
      cell.heightButtonConstraint.constant = 0.0
      cell.topButtonConstraint.constant = 8.0
      cell.layoutIfNeeded()
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: viewUserDataTableViewCellIdentifier)
        as? ViewUserDataTableViewCell else {
          return UITableViewCell()
      }
      
      needInsuranceButtonAction(cell.need_insuranceButton)
      
      cell.delegate = self
      cell.indexPath = indexPath
      cell.need_insuranceButton.addTarget(self, action: #selector(needInsuranceButtonAction(_:)), for: .touchUpInside)
      cell.rulInsurenceButton.addTarget(self, action: #selector(pushRuls(_:)), for: .touchUpInside)
      cell.offerButton.addTarget(self, action: #selector(pushOffer(_:)), for: .touchUpInside)
      cell.number = selectedSeats[indexPath.row - 1]
      cell.costAdult = currentRoute?.adult?.amount
      cell.costChildren = currentRoute?.child?.amount
      cell.costInsuranseAdult = currentRoute?.adult?.insurance
      cell.costInsuranseChild = currentRoute?.child?.insurance
      
      cell.currentTicket = dataInCells[indexPath.row - 1]
      
      cell.backgroundColor = .clear
      cell.selectionStyle = .none
      
      return cell
    }
  }
}

// MARK: - ViewUserDataTableViewCellDelegate
extension ViewEnterDatasViewController: ViewUserDataTableViewCellDelegate {
  func currentCost(_ ticket: Float, insurance: Float, indexPath: IndexPath) {
    sumTicket[indexPath.row - 1].insurance = insurance
    sumTicket[indexPath.row - 1].ticket = ticket
    
    setCurrentSum()
  }
}
