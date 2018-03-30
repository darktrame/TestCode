//
//  WebViewController.swift
//  JigsawPuzzle
//
//  Created by Elatesoftware on 28.02.2018.
//  Copyright © 2018 Elatesoftware. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  
  enum Content: String {
    case termsOfUse = "Terms of Use"
    case privacyPolicy = "Privacy Policy"
  }
  
  var content: Content!
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    title = content.rawValue
    guard let doc = Bundle.main.url(forResource: content.rawValue, withExtension: "pdf") else {return}
    let request = URLRequest(url: doc)
    (view as! UIWebView).loadRequest(request)
  }
}
