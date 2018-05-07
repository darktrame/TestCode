//
//  MainViewController.swift
//  
//

class MainViewController: LGSideMenuController {
  func setup() {
    leftViewPresentationStyle = .slideBelow
    rightViewPresentationStyle = .slideBelow
  }

  override func leftViewWillLayoutSubviews(with size: CGSize) {
    super.leftViewWillLayoutSubviews(with: size)

    if !isLeftViewStatusBarHidden {
      leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
    }
  }
}
