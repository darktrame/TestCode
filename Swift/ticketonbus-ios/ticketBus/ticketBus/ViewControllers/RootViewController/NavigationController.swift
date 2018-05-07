//
//  NavigationController.swift
//  
//

class NavigationController: UINavigationController {
  static var shared: UINavigationController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NavigationController.shared = self
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var prefersStatusBarHidden : Bool {
    return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .default
  }
  
  override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
    return sideMenuController!.isRightViewVisible ? .slide : .fade
  }
}
