//
//  TrackCell.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import Kingfisher
import UIKit

class TrackCell: UITableViewCell {
  static let reuseId = "TrackCell"

  @IBOutlet var trackNameLabel: UILabel!
  @IBOutlet var artistNameLabel: UILabel!
  @IBOutlet var collectionNameLabel: UILabel!
  @IBOutlet var trackImageView: UIImageView!
  @IBOutlet var addTrackButton: UIButton!

  private var cell: SearchViewModel.Cell?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    trackImageView.image = nil
  }

  /// Set received `viewModel` to ``TrackCell``.
  ///
  /// - Parameter viewModel: The cell of the ``SearchViewModel``.
  func set(viewModel: SearchViewModel.Cell) {
    cell = viewModel

    let savedTracks = UserDefaults.standard.getSavedTracks()

    let hasFavorite = savedTracks.firstIndex { cell in
      cell.trackName == self.cell?.trackName
        &&
        cell.artistName == self.cell?.artistName
    } != nil

    addTrackButton.isHidden = hasFavorite
      ? true
      : false

    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName

    guard let url = URL(string: viewModel.iconUrl ?? "") else { return }

    trackImageView.kf.setImage(with: url)
  }

  @IBAction func addTrackAction(_ sender: UIButton) {
    let defaults = UserDefaults.standard

    guard let cell else { return }

    addTrackButton.isHidden = true

    var listOfAddedCells = defaults.getSavedTracks()
    listOfAddedCells.append(cell)

    if let savedData = try? NSKeyedArchiver.archivedData(
      withRootObject: listOfAddedCells,
      requiringSecureCoding: false
    ) {
      defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
    }
  }
}
