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
  func presentData(response: Search.Model.Response.ResponseType) {}
}
