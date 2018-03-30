//
//  MainViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 09.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit
import Crashlytics

class MainViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let titleViewController = NSLocalizedString("gallery", comment: "")
  private let footerHeight: CGFloat = 28.0
  
  fileprivate let categoriesPuzzleCellIdentifier = String(describing: CategoriesPuzzleTableViewCell.self)
  fileprivate var refreshControl: UIRefreshControl!
  
  var applicationModel: ApplicationModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = titleViewController
    setNavigationBarButton()
    setTableViewSettings()
    removeTitleBackBarButtonItem()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setStatusBarColor(with: .applicationColor)
  }
  
  private func setTableViewSettings() {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44.0
    tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: footerHeight))
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: categoriesPuzzleCellIdentifier, bundle: nil),
                       forCellReuseIdentifier: categoriesPuzzleCellIdentifier)
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self,
                             action: #selector(refresh(_:)),
                             for: .valueChanged)
    tableView.addSubview(refreshControl)
  }
  
  private func setStatusBarColor(with color: UIColor) {
    guard let statusBar = UIApplication.shared.statusBarView else { return }
    statusBar.backgroundColor = color
  }
  
  private func setNavigationBarButton() {
    let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "myPuzzle"), style: .plain, target: self, action: #selector(openMyProfile(_:)))
    navigationItem.rightBarButtonItem = rightBarButton
  }
  
  @objc
  func refresh(_ sender: Any) {
    ConnectionManager.sharedInstance.getPicturesLibrary { (puzzle, error) in
      guard error == nil, let list = puzzle, !list.isEmpty else { self.refreshControl.endRefreshing(); return }
      self.applicationModel.picturesPuzzle = list
      
      DispatchQueue.main.async {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
      }
    }
  }
  
  @objc
  func openMyProfile(_ sender: UIBarButtonItem) {
    if let controller = MyPuzzleViewController.instantiateInitialViewController() as? MyPuzzleViewController{
      controller.applicationModel = applicationModel
      navigationController?.pushViewController(controller, animated: true)
    }
  }
  
  private func trackSelectedPuzzle(withId id: Int) {
    Answers.logContentView(withName: "User selected puzzle with id = \(id)",
      contentType: "Selected Puzzle",
      contentId: "\(id)",
      customAttributes: nil)
  }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return applicationModel.categoriesPuzzle.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: categoriesPuzzleCellIdentifier)
      as? CategoriesPuzzleTableViewCell else {
      return UITableViewCell()
    }
    
    let currentCategory = applicationModel.categoriesPuzzle[indexPath.row]
    let filterPuzzle = applicationModel.picturesPuzzle.filter { $0.category == indexPath.row}
                                                      .sorted {
                                                        if $0.isChargable && !$1.isChargable {
                                                          return !$0.isChargable && $1.isChargable
                                                        } else {
                                                          return $0.id > $1.id
                                                        }
    }
    
    cell.puzzle = filterPuzzle
    cell.categoryImageView.image = currentCategory.image
    cell.titleCategoryLabel.text = currentCategory.name
    cell.titleCategoryLabel.textColor = currentCategory.titleColor
    cell.borderColor = currentCategory.titleColor
    cell.delegate = self
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - CategoriesPuzzleTableViewCellDelegate
extension MainViewController: CategoriesPuzzleTableViewCellDelegate {
  func presentDetailsPuzzleViewController(with puzzle: PicturesModel) {
    guard let controller = DetailsPuzzleViewController.instantiateInitialViewController()
      as? DetailsPuzzleViewController else { return }
    controller.puzzle = puzzle
    trackSelectedPuzzle(withId: puzzle.id)
    navigationController?.pushViewController(controller, animated: true)
  }
  
  func presentProScreenViewController() {
    guard let navigationController = ProScreenViewController.instantiateInitialViewController() as? UINavigationController,
    let controller = navigationController.viewControllers.first as? ProScreenViewController else { return }
    navigationController.modalTransitionStyle = .crossDissolve
    navigationController.modalPresentationStyle = .overCurrentContext
    controller.delegate = self
    present(navigationController, animated: true, completion: nil)
  }
  
  func userDidChangePuzzle(_ puzzle: PicturesModel) {
    guard !User.isPremiumVersionActive else { presentDetailsPuzzleViewController(with: puzzle); return }
    puzzle.isChargable ? presentProScreenViewController() : presentDetailsPuzzleViewController(with: puzzle)
  }
}

extension MainViewController: ProScreenViewControllerDelegate {
  func reloadTableView() {
    tableView.reloadData()
  }
}
