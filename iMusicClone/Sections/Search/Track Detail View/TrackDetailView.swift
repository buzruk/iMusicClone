//
//  TrackDetailView.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import AVKit
import Kingfisher
import UIKit

/// A delegate that control moving musics back or forward.
protocol TrackMovingDelegate {
  /// Move back previous track.
  ///
  /// - Returns: The cell of the track that moved.
  func moveBack() -> SearchViewModel.Cell?

  /// Move forward previous track.
  ///
  /// - Returns: The cell of the track that moved.
  func moveForward() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
  @IBOutlet var maximizedTrackView: UIStackView!
  @IBOutlet var trackImageView: UIImageView!
  @IBOutlet var currentTimeSlider: UISlider!
  @IBOutlet var currentTimeLabel: UILabel!
  @IBOutlet var durationLabel: UILabel!
  @IBOutlet var trackTitleLabel: UILabel!
  @IBOutlet var artistTitleLabel: UILabel!
  @IBOutlet var musicStateButton: UIButton!
  @IBOutlet var volumeSlider: UISlider!
  
  @IBOutlet var minimizedTrackView: UIView!
  @IBOutlet var miniGoForwardButton: UIButton!
  @IBOutlet var miniTrackImageView: UIImageView!
  @IBOutlet var miniMusicStateButton: UIButton!
  @IBOutlet var miniTrackTitleLabel: UILabel!
  
  /// A delegate for moving music back or forward.
  var trackMovingDelegate: TrackMovingDelegate?
  
  /// A delegate that control minimize or maximize track detail.
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  /// An object that provides the interface to control the player’s
  /// transport behavior.
  private let player: AVPlayer = {
    let player = AVPlayer()
    player.automaticallyWaitsToMinimizeStalling = false
    return player
  }()
  
  // MARK: awakeFromNib
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let scale: CGFloat = 0.8
    trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    trackImageView.layer.cornerRadius = 5
    
    miniMusicStateButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
    
    setupGestures()
  }
  
  /// Set view model for ``TrackDetailView``.
  ///
  /// - Parameter viewModel: The cell of the ``SearchViewModel``.
  func set(viewModel: SearchViewModel.Cell) {
    trackTitleLabel.text = viewModel.trackName
    artistTitleLabel.text = viewModel.artistName
    miniTrackTitleLabel.text = viewModel.trackName
    
    playTrack(viewModel.previewUrl)
    monitorStartTime()
    observePlayerCurrentTime()
    musicStateButton.setImage(UIImage(named: "pause"), for: .normal)
    miniMusicStateButton.setImage(UIImage(named: "pause"), for: .normal)
    
    let iconUrl600 = viewModel.iconUrl?.replacingOccurrences(of: "100x100",
                                                             with: "600x600")
    guard let url = URL(string: iconUrl600 ?? "") else { return }
    
    trackImageView.kf.setImage(with: url)
    miniTrackImageView.kf.setImage(with: url)
  }

  // MARK: - Interface builder actions
  
  @IBAction func dragDownButtonTapped(_ sender: UIButton) {
    tabBarDelegate?.minimizeTrackDetailController()
  }
  
  @IBAction func handleCurrentTime(_ sender: UISlider) {
    let percentage = currentTimeSlider.value
    
    guard let duration = player.currentItem?.duration else { return }
    
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds,
                                         preferredTimescale: 1)
    player.seek(to: seekTime)
  }
  
  @IBAction func HandleVolume(_ sender: UISlider) {
    player.volume = volumeSlider.value
  }
  
  @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
    let cellViewModel = trackMovingDelegate?.moveBack()
    
    guard let cellViewModel else { return }
    
    set(viewModel: cellViewModel)
  }
  
  @IBAction func nextTrackButtonTapped(_ sender: Any) {
    let cellViewModel = trackMovingDelegate?.moveForward()
    
    guard let cellViewModel else { return }
    
    set(viewModel: cellViewModel)
  }
  
  @IBAction func musicStateAction(_ sender: UIButton) {
    player.timeControlStatus == .paused
      ? setupMusicState(for: .paused)
      : setupMusicState(for: .playing)
  }
}

private extension TrackDetailView {
  /// Play received preview urls music.
  ///
  /// - Parameter previewUrl: The url of the preview track.
  func playTrack(_ previewUrl: String?) {
    guard let url = URL(string: previewUrl ?? "") else { return }
    
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  /// Setup music state for received `type`.
  ///
  /// - Parameter type: Indicate the state of playback control.
  func setupMusicState(for type: AVPlayer.TimeControlStatus) {
    switch type {
      case .paused:
        player.pause()
        musicStateButton.setImage(UIImage(named: "play"), for: .normal)
        miniMusicStateButton.setImage(UIImage(named: "play"), for: .normal)
        setTrackImageScale(for: .paused)
      case .playing:
        player.play()
        musicStateButton.setImage(UIImage(named: "pause"), for: .normal)
        miniMusicStateButton.setImage(UIImage(named: "pause"), for: .normal)
        setTrackImageScale(for: .playing)
      default: break
    }
  }
}

private extension TrackDetailView {
  /// Set track image scale for `type`.
  ///
  /// - Parameter type: Indicate the state of playback control.
  func setTrackImageScale(for type: AVPlayer.TimeControlStatus) {
    switch type {
      case .playing:
        Helper.animate {
          self.trackImageView.transform = .identity
        }
      case .paused:
        Helper.animate {
          let scale: CGFloat = 0.8
          self.trackImageView.transform = CGAffineTransform(scaleX: scale,
                                                            y: scale)
        }
      default: break
    }
  }
}
 
// MARK: Time Setup

private extension TrackDetailView {
  /// Requests the invocation of a block when specified times are
  /// traversed during normal playback.
  func monitorStartTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    
    player.addBoundaryTimeObserver(
      forTimes: times,
      queue: .main)
    { [weak self] in
      self?.setTrackImageScale(for: .playing)
    }
  }
  
  /// Requests the periodic invocation of a given block during playback
  /// to report changing time.
  func observePlayerCurrentTime() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(
      forInterval: interval,
      queue: .main)
    { [weak self] time in
      self?.currentTimeLabel.text = time.toString()
      
      let duration = self?.player.currentItem?.duration
      let currentDuration = duration ?? CMTimeMake(value: 1, timescale: 1) - time
      
      self?.durationLabel.text = "-\(currentDuration.toString())"
      self?.updateCurrentTimeSlider()
    }
  }
  
  /// Update slider fo current time.
  func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    
    let percentage = Float(currentTimeSeconds / durationSeconds)
    currentTimeSlider.value = percentage
  }
}

// MARK: Gestures

private extension TrackDetailView {
  /// Set gestures to detail view.
  func setupGestures() {
    minimizedTrackView.addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(handleTapMaximized)))
    
    minimizedTrackView.addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(handlePan)))
    
    addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(handleDismissalPan)))
  }
  
  /// Handle maximzed track detail controller.
  @objc func handleTapMaximized() {
    tabBarDelegate?.maximizeTrackDetailController(searchViewModel: nil)
  }
  
  /// Handle pan gesture from received `gesture`.
  ///
  /// - Parameter gesture: A continuous gesture recognizer that
  /// interprets panning gestures.
  @objc func handlePan(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
      case .changed: handlePanChanged(gesture: gesture)
      case .ended: handlePanEnded(gesture: gesture)
      default: break
    }
  }
  
  /// Handle dismissal pan from received gesture.
  ///
  /// - Parameter gesture: A continuous gesture recognizer that
  /// interprets panning gestures.
  @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: superview)
    
    switch gesture.state {
      case .changed:
        maximizedTrackView.transform = CGAffineTransform(translationX: 0,
                                                         y: translation.y)
      case .ended:
        Helper.animate(options: .curveEaseOut) {
          self.maximizedTrackView.transform = .identity
          if translation.y > 50 {
            self.tabBarDelegate?.minimizeTrackDetailController()
          }
        }
      default: break
    }
  }
  
  /// Handle pan in gestures changed state.
  ///
  /// - Parameter gesture: A continuous gesture recognizer that
  /// interprets panning gestures.
  func handlePanChanged(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: superview)
    transform = CGAffineTransform(translationX: 0, y: translation.y)
    
    let newAlpha = 1 + translation.y / 200
    minimizedTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
    maximizedTrackView.alpha = -translation.y / 200
  }
  
  /// Handle pan in gestures ended state.
  ///
  /// - Parameter gesture: A continuous gesture recognizer that
  /// interprets panning gestures.
  func handlePanEnded(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: superview)
    let velocity = gesture.velocity(in: superview)
    
    Helper.animate(options: .curveEaseOut) {
      self.transform = .identity
      
      if translation.y < -200 || velocity.y < -500 {
        self.tabBarDelegate?.maximizeTrackDetailController(searchViewModel: nil)
      } else {
        self.minimizedTrackView.alpha = 1
        self.maximizedTrackView.alpha = 0
      }
    }
  }
}
