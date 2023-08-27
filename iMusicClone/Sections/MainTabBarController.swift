//
//  MainTabBarController.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import SwiftUI
import UIKit

class MainTabBarController: UITabBarController {
  private let searchVC: SearchVC = .loadFromStoryboard()
  private let libraryView = LibraryView()

  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.tintColor = UIColor(named: "main-color")

    let hostVC = UIHostingController(rootView: libraryView)

    viewControllers = [
      generateVC(from: hostVC, image: UIImage(named: "library")!, title: "Library"),
      generateVC(from: searchVC, image: UIImage(named: "search")!, title: "Search"),
    ]
  }
}

private extension MainTabBarController {
  /// Get view controller from received `vc`.
  ///
  /// - Parameters:
  ///   - vc: A view controller that needs generate naviation controller and
  ///   realize tab bar for this controller.
  ///   - image: The image for set to tab bar item.
  ///   - title: The title for set to tab bar item
  /// - Returns: A view controller from received `vc.`
  func generateVC(
    from vc: UIViewController,
    image: UIImage,
    title: String) -> UIViewController
  {
    let navigationVC = UINavigationController(rootViewController: vc)
    navigationVC.tabBarItem.image = image
    navigationVC.tabBarItem.title = title
    vc.navigationItem.title = title
    navigationVC.navigationBar.prefersLargeTitles = true
    return navigationVC
  }
}
