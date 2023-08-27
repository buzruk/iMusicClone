//
//  MainTabBarController.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import SwiftUI
import UIKit

/// The delegate for control track detail controller to minimize or maximaze.
protocol MainTabBarControllerDelegate: AnyObject {
  /// Minimized track detail controller.
  func minimizeTrackDetailController()
  
  /// Maximize track detail controller.
  ///
  /// - Parameter searchViewModel: The cell of the ``SearchViewModel``.
  func maximizeTrackDetailController(searchViewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
  private var minimizedTopAnchorConstraint: NSLayoutConstraint!
  private var maximizedTopAnchorConstraint: NSLayoutConstraint!
  private var bottomAnchorConstraint: NSLayoutConstraint!
  
  private let searchVC: SearchVC = .loadFromStoryboard()
  private let libraryView = LibraryView()
  let trackDetailView: TrackDetailView = .loadFromNib()

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
