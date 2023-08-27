//
//  UIColor+Extension.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import UIKit

extension UIColor {
  /// Make color from received `red`, `green`, `blue`.
  ///
  /// - Parameters:
  ///   - red: The red value of the color object. On applications linked for
  ///   iOS 10 or later, the color is specified in an extended color space, and
  ///   the input value is never clamped. On earlier versions of iOS,
  ///   red values below 0.0 are interpreted as 0.0, and values
  ///   above 1.0 are interpreted as 1.0.
  ///   - green: The green value of the color object. On applications linked
  ///   for iOS 10 or later, the color is specified in an extended color space,
  ///   and the input value is never clamped. On earlier versions of iOS,
  ///   green values below 0.0 are interpreted as 0.0, and values
  ///   above 1.0 are interpreted as 1.0.
  ///   - blue: The blue value of the color object. On applications linked
  ///   for iOS 10 or later, the color is specified in an extended color space,
  ///   and the input value is never clamped. On earlier versions of iOS,
  ///   blue values below 0.0 are interpreted as 0.0, and values
  ///   above 1.0 are interpreted as 1.0.
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: 1.0)
  }

  /// Make color from received hexadicemal number.
  ///
  /// - Parameter rgb: Rgb color in hexadecimal format.
  convenience init(rgb: Int) {
    self.init(red: (rgb >> 16) & 0xFF,
              green: (rgb >> 8) & 0xFF,
              blue: rgb & 0xFF)
  }
}
