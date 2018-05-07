//
//  AboutUsViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 11.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class AboutUsViewController: GlobalViewController {
  // MARK: - Outlets
  @IBOutlet weak var photoScrollView: PhotoScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "О нас"
    
    view.backgroundColor = UIColor.blueTicketBusTableColor
    
    photoScrollView.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    guard !photoScrollView.isPopulated else {
      return
    }
      
    photoScrollView.populate(with: [#imageLiteral(resourceName: "foto1"),#imageLiteral(resourceName: "foto2"),#imageLiteral(resourceName: "foto3")])
  }
}

// MARK: - UIScrollViewDelegate
extension AboutUsViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.frame.width
    let currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
    
    self.pageControl.currentPage = Int(currentPage)
  }
}
