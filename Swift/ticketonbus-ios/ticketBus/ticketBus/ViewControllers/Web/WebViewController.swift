//
//  WebViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 12.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var webView: UIWebView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var errorLabel: UILabel!
  
  // MARK: - Variables
  var titleString = ""
  var link = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    errorLabel.isHidden = true
    activityIndicator.isHidden = true
    
    webView.delegate = self
    
    title = titleString
    
    if let url = URL(string: link) {
      let request = URLRequest(url: url)
      webView.loadRequest(request)
    }
  }
  
  // MARK: - Methods
  func showActivity() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func hiddeActivity() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
  }
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let url = request.description
    
    if url.hasSuffix("/check/") {
      let alert = UIAlertController(title: "Оплата прошла успешно!", message: "", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        self.navigationController?.popToRootViewController(animated: true)
      })
      
      alert.addAction(ok)
      
      self.present(alert, animated: true, completion: nil)
      
      return false
    }
    
    return true
  }
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    showActivity()
  }
    
  func webViewDidFinishLoad(_ webView: UIWebView) {
    hiddeActivity()
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    hiddeActivity()
    
    errorLabel.isHidden = false
    errorLabel.text = error.localizedDescription
  }
}
