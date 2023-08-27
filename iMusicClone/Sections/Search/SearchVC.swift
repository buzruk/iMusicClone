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
  
  /// A footer of the table view
  private lazy var footerView = FooterView()
  
  /// The delegate for control track detail controller to minimize or maximaze.
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  // MARK: Interface builder outlet
  
  @IBOutlet var table: UITableView!
  
  // MARK: Routing
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupSearchBar()
    setupTableView()
    searchBar(searchController.searchBar, textDidChange: "maher zain")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let tabBarVC = Helper.getTabBarViewController()
    tabBarVC?.trackDetailView.trackMovingDelegate = self
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
      case .displayTracks(let searchViewModel):
        print("view controller: .displayTracks")
        self.searchViewModel = searchViewModel
        table.reloadData()
        footerView.hideLoader()
      case .displayFooterView:
        print("view controller: .displayFooterView")
        footerView.showLoader()
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
    
    table.tableFooterView = footerView
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
    tabBarDelegate?.maximizeTrackDetailController(searchViewModel: cellViewModel)
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    84
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    let label = UILabel()
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    searchViewModel.cells.count > 0
      ? 0
      : 250
  }
}

extension SearchVC: TrackMovingDelegate {
  func moveBack() -> SearchViewModel.Cell? {
    getTrack(for: .back)
  }
  
  func moveForward() -> SearchViewModel.Cell? {
    getTrack(for: .forward)
  }

  /// Get track from received music navigation state.
  ///
  /// - Parameter type: The state of the music navigation.
  /// - Returns: The cell of the ``SearchViewModel``.
  private func getTrack(for type: MusicNavigationState) -> SearchViewModel.Cell? {
    guard let indexPath = table.indexPathForSelectedRow
    else { return nil }
    
    var nextIndexPath: IndexPath!
    
    switch type {
      case .back:
        nextIndexPath = IndexPath(row: indexPath.row - 1,
                                  section: indexPath.section)
        if nextIndexPath.row == -1 {
          nextIndexPath.row = searchViewModel.cells.count - 1
        }
      case .forward:
        nextIndexPath = IndexPath(row: indexPath.row + 1,
                                  section: indexPath.section)
        if nextIndexPath.row == searchViewModel.cells.count {
          nextIndexPath.row = 0
        }
    }
    
    table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    let cellViewModel = searchViewModel.cells[nextIndexPath.row]
    return cellViewModel
  }
}
