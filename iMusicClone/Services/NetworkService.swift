//
//  NetworkService.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import Alamofire
import UIKit

class NetworkService {
  /// Fetch tracks from `searchText` and
  /// return detected tracks to completion if it exists.
  ///
  /// - Parameters:
  ///   - searchText: A string value for searching tracks.
  ///   - completion: Return array of the tracks if it exists.
  func fetchTracks(from searchText: String, completion: @escaping (SearchResponse?) -> Void) {
    let url = "https://itunes.apple.com/search"
    let parameteres = [
      "term": "(\(searchText)",
      "limit": "50",
      "media": "music"
    ]

    AF.request(url,
               method: .get,
               parameters: parameteres)
      .responseData { dataRespone in
        if let error = dataRespone.error {
          print("Error received requesting data: \(error.localizedDescription)")
          completion(nil)
          return
        }

        guard let data = dataRespone.data else { return }

        let decoder = JSONDecoder()
        do {
          let objects = try decoder.decode(SearchResponse.self, from: data)
          completion(objects)
        } catch let jsonError {
          print("Falied to decode JSON", jsonError)
          completion(nil)
        }
      }
  }
}
