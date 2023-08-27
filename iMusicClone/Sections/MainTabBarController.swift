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
  let trackDetailView: TrackDetailView = .loadFromNib()
  private let libraryView = LibraryView()

  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.tintColor = UIColor(named: "main-color")
    
    setupDetailView()

    searchVC.tabBarDelegate = self

//    libraryView.tabBarDelegate = self
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

  /// Setup detail view.
  func setupDetailView() {
    view.insertSubview(trackDetailView, belowSubview: tabBar)
    trackDetailView.translatesAutoresizingMaskIntoConstraints = false

    trackDetailView.tabBarDelegate = self
    trackDetailView.trackMovingDelegate = searchVC

    minimizedTopAnchorConstraint = trackDetailView.topAnchor
      .constraint(equalTo: tabBar.topAnchor, constant: -64)
    maximizedTopAnchorConstraint = trackDetailView.topAnchor
      .constraint(equalTo: view.topAnchor, constant: view.frame.height)
    bottomAnchorConstraint = trackDetailView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor, constant: view.frame.height)

    NSLayoutConstraint.activate([
      bottomAnchorConstraint,
      maximizedTopAnchorConstraint,
      trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}

extension MainTabBarController: MainTabBarControllerDelegate {
  /// The size state of the view.
  enum SizeType {
    case minimized
    case maximized
  }

  /// Prepare track detail controller for state of the view.
  ///
  /// - Parameters:
  ///   - type: The size state of the view.
  ///   - searchViewModel: The cell of the search view model.
  func prepareTrackDetailController(
    for type: SizeType,
    searchViewModel: SearchViewModel.Cell?)
  {
    switch type {
      case .minimized:
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true

      Helper.animate(options: .curveEaseOut) {
          self.view.layoutIfNeeded()
          self.tabBar.transform = .identity
          self.trackDetailView.minimizedTrackView.alpha = 1
          self.trackDetailView.maximizedTrackView.alpha = 0
//          self.tabBar.alpha = 0
        }
      case .maximized:
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0

        Helper.animate(options: .curveEaseOut) {
          self.view.layoutIfNeeded()
          self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
//          self.tabBar.alpha = 1
          self.trackDetailView.minimizedTrackView.alpha = 0
          self.trackDetailView.maximizedTrackView.alpha = 1
        }

        guard let searchViewModel else { return }
        trackDetailView.set(viewModel: searchViewModel)
    }
  }

  func minimizeTrackDetailController() {
    prepareTrackDetailController(for: .minimized, searchViewModel: nil)
  }

  func maximizeTrackDetailController(searchViewModel: SearchViewModel.Cell?) {
    prepareTrackDetailController(for: .maximized, searchViewModel: searchViewModel)
  }
}
