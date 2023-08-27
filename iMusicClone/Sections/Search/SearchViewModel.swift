//
//  SearchViewModel.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

class SearchViewModel {
  class Cell {
    let trackName: String
    let collectionName: String?
    let artistName: String
    let iconUrl: String?
    let previewUrl: String?

    init(
      trackName: String,
      collectionName: String?,
      artistName: String,
      iconUrl: String?,
      previewUrl: String?
    ) {
      self.trackName = trackName
      self.collectionName = collectionName
      self.artistName = artistName
      self.iconUrl = iconUrl
      self.previewUrl = previewUrl
    }
  }

  init(cells: [Cell]) {
    self.cells = cells
  }

  let cells: [Cell]
}
