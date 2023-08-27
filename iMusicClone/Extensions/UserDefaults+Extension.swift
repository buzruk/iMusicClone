//
//  UserDefaults+Extension.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import Foundation

extension UserDefaults {
  static let favoriteTrackKey = "favoriteTrackKey"

  /// Get saved data from UserDefaults.
  ///
  /// - Returns: The cell of the search view model.
  func getSavedTracks() -> [SearchViewModel.Cell] {
    let defaults = UserDefaults.standard

    guard let savedTracks = defaults
      .object(forKey: UserDefaults.favoriteTrackKey) as? Data
    else { return [] }

    guard let decodedTrack = try? NSKeyedUnarchiver
      .unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell]
    else { return [] }

    return decodedTrack
  }
}
