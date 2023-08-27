//
//  SearchPresenter.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// Logic of the ``SearchPresenter`` for presenting data.
protocol SearchPresentationLogic {
  /// Presenting received `response` from ``SearchInteractor``.
  ///
  /// - Parameter response: The response type of the search model.
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?

  /// Presenting received `response` from ``SearchInteractor``.
  ///
  /// - Parameter response: The response type of the search model.
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
      case .presentTracks(let searchResults):
        print("presenter .presentTracks")
        let cells = searchResults?.results.map { track in
          cellViewModel(from: track)
        } ?? []
        let searchViewModel = SearchViewModel(cells: cells)
        viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
      case .presentFooterView:
        print("presenter .presentFooterView")
        viewController?.displayData(viewModel: .displayFooterView)
    }
  }
}

private extension SearchPresenter {
  /// Make cell of the cell view model for received `track` .
  ///
  /// - Parameter track: A track for creating cell.
  /// - Returns: The cell of the ``SearchViewModel``.
  func cellViewModel(from track: Track) -> SearchViewModel.Cell {
    return SearchViewModel.Cell(
      trackName: track.trackName,
      collectionName: track.collectionName,
      artistName: track.artistName,
      iconUrl: track.artworkUrl100,
      previewUrl: track.previewUrl)
  }
}
