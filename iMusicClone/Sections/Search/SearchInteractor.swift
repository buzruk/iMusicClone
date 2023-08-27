//
//  SearchInteractor.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// Logic of the  ``SearchInteractor`` for making request.
protocol SearchBusinessLogic {
  /// Make request from received `request`.
  ///
  /// - Parameter request: The request type of the search model.
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  /// The service that fetch track from iTunes Search API.
  private var networkService = NetworkService()

  /// Make request from recevied `request`.
  ///
  /// - Parameter request: The request type of the search model.
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }

    switch request {
      case .getTracks(let searchTerm):
        print("interactor .getTracks")
        presenter?.presentData(response: .presentFooterView)
        networkService.fetchTracks(
          from: searchTerm
        ) { [weak self] searchResponese in
          self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponese))
        }
    }
  }
}
