//
//  ProfileUserViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 05.09.17.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class ProfileUserViewController: GlobalViewController {
  enum TabIndex : Int {
    case myProfileTab = 0
    case myTicketsTab = 1
  }
  
  // MARK: - Outlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var contentView: UIView!
  
  // MARK: - Variables
  var currentViewController: UIViewController?
  lazy var myProfileTabVC: UIViewController? = {
    if let myProfileTabVC = MyProfileViewController.viewController() {
      return myProfileTabVC
    }
    
    return nil
  }()
  
  lazy var myTicketsTabVC : UIViewController? = {
    if let myTicketsTabVC = MyTicketsViewController.viewController() {
      return myTicketsTabVC
    }
    
    return nil
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Личный кабинет"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
    
    setNavigationBar()
    
    segmentedControl.selectedSegmentIndex = TabIndex.myProfileTab.rawValue
    displayCurrentTab(TabIndex.myProfileTab.rawValue)
    
    removeTitleBackBarButtonItem()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let currentViewController = currentViewController {
      currentViewController.viewWillDisappear(animated)
    }
  }
  
  // MARK: - Methods
  func displayCurrentTab(_ tabIndex: Int){
    if let controller = viewControllerForSelectedSegmentIndex(tabIndex) {
      if controller.isKind(of: MyProfileViewController.self) {
        (controller as! MyProfileViewController).delegate = self
      }
      
      self.addChildViewController(controller)
      controller.didMove(toParentViewController: self)
      
      controller.view.frame = self.contentView.bounds
      self.contentView.addSubview(controller.view)
      self.currentViewController = controller
    }
  }
  
  func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
    var vc: UIViewController?
    switch index {
    case TabIndex.myProfileTab.rawValue :
      vc = myProfileTabVC
    case TabIndex.myTicketsTab.rawValue :
      vc = myTicketsTabVC
    default:
      return nil
    }
    
    return vc
  }
  
  func setNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти",
                                                        style: .plain,
                                                        target: self, action: #selector(logOut))
  }
  
  // MARK: - Actions
  @IBAction func switchTabs(_ sender: UISegmentedControl) {
    self.currentViewController!.view.removeFromSuperview()
    self.currentViewController!.removeFromParentViewController()
    
    displayCurrentTab(sender.selectedSegmentIndex)
  }
  
  @objc func logOut() {
    User.isAuthorized = false
    User.user_id = -1
    User.username = nil
    User.user_token = nil
    
    if let controller = AuthViewController.viewController() {
      navigationController?.setViewControllers([controller], animated: true)
    }
  }
}

// MARK: - MyProfileViewControllerDelegate
extension ProfileUserViewController: MyProfileViewControllerDelegate {
  func deleteUser() {
    ConnectionManager.share.deleteUser { (result, error) in
      if let flag = result {
        if flag && error == nil {
          self.logOut()
        } else {
          let alert = UIApplication.shared.showAlert(error ?? "Произошла ошибка!", title: "")
          self.present(alert, animated: true, completion: nil)
        }
      } else {
        let alert = UIApplication.shared.showAlert(error ?? "Произошла ошибка!", title: "")
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}
