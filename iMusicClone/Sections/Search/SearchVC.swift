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
  
  /// A view controller that manages the display of search results
  /// based on interactions with a search bar.
  private let searchController = UISearchController(searchResultsController: nil)
  
  /// A timer that fires after a certain time interval has elapsed,
  ///  sending a specified message to a target object.
  private var timer: Timer? = nil

  // MARK: Interface builder outlet
  
  @IBOutlet var table: UITableView!
  
  // MARK: Routing
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupSearchBar()
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
      case .displayTracks(let searchViewModel):
        print("view controller: .displayTracks")
        self.searchViewModel = searchViewModel
        table.reloadData()
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
  
  /// Setup search bar.
  func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
  }
  
  /// Setup table view.
  func setupTableView() {
    table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    
    let nib = UINib(nibName: TrackCell.reuseId, bundle: nil)
    table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
  }
}

extension SearchVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    timer?.invalidate()
    timer = Timer.scheduledTimer(
      withTimeInterval: 0.5,
      repeats: false,
      block: { _ in
        self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
      }
    )
  }
}

// MARK: - Table view delegate and data source

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    searchViewModel.cells.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId,
                                         for: indexPath) as! TrackCell
    let cellViewModel = searchViewModel.cells[indexPath.row]
    cell.set(viewModel: cellViewModel)
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let cellViewModel = searchViewModel.cells[indexPath.row]
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    84
  }
}
