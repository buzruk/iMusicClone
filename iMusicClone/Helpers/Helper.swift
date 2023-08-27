//
//  AnimationHelper.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import UIKit

enum Helper {
  /// Performs a view animation using a timing curve corresponding to the motion of a physical spring.
  ///
  /// - Parameters:
  ///   - withDuration: The amount of time (measured in seconds)
  ///   to wait beforebeginning the animations.
  ///   Specify a value of 0 to begin the animations immediately.
  ///   - delay: The amount of time (measured in seconds)
  ///   to wait before beginning the animations.
  ///   Specify a value of 0 to begin the animations immediately.
  ///   - usingSpringWithDamping: The damping ratio for the spring animation
  ///   as it approaches its quiescent state.
  ///  To smoothly decelerate the animation without oscillation, use a value
  ///  of 1. Employ a damping ratio closer to zero to increase oscillation.
  ///   - initialSpringVelocity: The initial spring velocity.
  ///   For smooth start to the animation, match this value to the view’s
  ///   velocity as it was prior to attachment.
  ///  A value of 1 corresponds to the total animation distance traversed
  ///  in one second. For example, if the total animation distance
  ///  is 200 points and you want the start of the animation to match
  ///  a view velocity of 100 pt/s, use a value of 0.5.
  ///   - options: A mask of options indicating how you want
  ///   to perform the animations.
  ///   - animations: A block object to be executed when the animation
  ///   sequence ends. This block has no return value and takes a single
  ///   Boolean argument that indicates whether or not the animations
  ///   actually finished before the completion handler was called.
  ///   If the duration of the animation is 0, this block is performed at
  ///   the beginning of the next run loop cycle. This parameter may be NULL.
  static func animate(
    withDuration: Double = 1,
    delay: Double = 0,
    usingSpringWithDamping: Double = 0.7,
    initialSpringVelocity: Double = 1,
    options: UIView.AnimationOptions = .curveEaseInOut,
    animations: @escaping () -> Void)
  {
    UIView.animate(
      withDuration: withDuration,
      delay: delay,
      usingSpringWithDamping: usingSpringWithDamping,
      initialSpringVelocity: initialSpringVelocity,
      options: options,
      animations: animations)
  }
  
  
  /// Get MainTabBarController from UIApplication.
  static func getTabBarViewController() -> MainTabBarController? {
    let keyWindow = UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
    return keyWindow?.rootViewController as? MainTabBarController
  }
}
