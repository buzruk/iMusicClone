//
//  SearchViewController.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// Logic of the ``SearchVC`` for displaying data.
protocol SearchDisplayLogic: AnyObject {
  /// Displaying data from received `viewModel`.
  ///
  /// - Parameter viewModel: The viewModel data of the search model
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchVC: UIViewController, SearchDisplayLogic {
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
  
  /// view model for search section of the app.
  private var searchViewModel = SearchViewModel(cells: [])

  // MARK: Interface builder outlet
  
  @IBOutlet var table: UITableView!
  
  // MARK: Routing
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
      case .displayTracks(let searchViewModel):
        print("view controller: .displayTracks")
        self.searchViewModel = searchViewModel
    }
  }
}

// MARK: - Setup
  
private extension SearchVC {
  /// Setup ``SearchVC`` for clean swift pattern.
  func setup() {
    let viewController = self
    let interactor = SearchInteractor()
    let presenter = SearchPresenter()
    let router = SearchRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
  }
}
