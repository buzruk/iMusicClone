//
//  UIView+Extension.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import UIKit

extension UIView {
  /// Loads instance of UIView from Stroryboard.
  ///
  /// - Returns: Received `T` from Storyboard.
  class func loadFromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(
      String(describing: T.self),
      owner: nil)![0] as! T
  }
}
