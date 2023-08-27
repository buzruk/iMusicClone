//
//  SearchViewModel.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import Foundation

class SearchViewModel: NSObject, NSCoding {
  func encode(with coder: NSCoder) {
    coder.encode(cells, forKey: "cells")
  }

  required init?(coder: NSCoder) {
    cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
  }

  @objc(_TtCC11iMusicClone15SearchViewModel4Cell)class Cell: NSObject, NSCoding, Identifiable {
    let id = UUID()
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

    func encode(with coder: NSCoder) {
      coder.encode(trackName, forKey: "trackName")
      coder.encode(collectionName, forKey: "collectionName")
      coder.encode(artistName, forKey: "artistName")
      coder.encode(iconUrl, forKey: "iconUrl")
      coder.encode(previewUrl, forKey: "previewUrl")
    }

    required init?(coder: NSCoder) {
      trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
      collectionName = coder.decodeObject(forKey: "collectionName") as? String? ?? ""
      artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
      iconUrl = coder.decodeObject(forKey: "iconUrl") as? String ?? ""
      previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
    }
  }

  init(cells: [Cell]) {
    self.cells = cells
  }

  let cells: [Cell]
}
