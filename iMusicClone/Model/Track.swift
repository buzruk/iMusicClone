//
//  Track.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

struct Track: Decodable {
  let trackName: String
  let collectionName: String?
  let artistName: String
  let artworkUrl100: String?
  let previewUrl: String?
}

struct SearchResponse: Decodable {
  var resultCount: Int
  var results: [Track]
}
