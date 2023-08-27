//
//  UIViewController+Extension.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import UIKit

extension UIViewController {
  /// Loads instance of UIViewController from Stroryboard.
  ///
  /// - Returns: Received `T` from Storyboard.
  class func loadFromStoryboard<T: UIViewController>() -> T {
    let name = String(describing: T.self)

    let storyboard = UIStoryboard(name: name, bundle: nil)

    if let vc = storyboard.instantiateInitialViewController() as? T {
      return vc
    } else {
      fatalError("Error: No initial view controller in \(name) storyboard!")
    }
  }
}
