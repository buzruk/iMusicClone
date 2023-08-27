//
//  CMTime+Extension.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import AVKit

extension CMTime {
  /// Convert to String and format minutes and seconds.
  ///
  /// - Returns: Minutes and seconds in String.
  func toString() -> String {
//    guard let totalSecond = Int(CMTimeGetSeconds(self)) else { return "" }

    guard !CMTimeGetSeconds(self).isNaN else { return "" }
    let totalSeconds = Int(CMTimeGetSeconds(self))

    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
    return timeFormatString
  }
}
