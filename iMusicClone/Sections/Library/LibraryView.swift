//
//  LibraryView.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import SwiftUI

struct LibraryView: View {
  @State var savedTracks = UserDefaults.standard.getSavedTracks()
  @State private var showingAlert = false
  @State private var track: SearchViewModel.Cell!

  var tabBarDelegate: MainTabBarControllerDelegate?

  var body: some View {
    NavigationView {
      VStack {
        GeometryReader { geometry in
          HStack(spacing: 20) {
            Button {
              if savedTracks.isEmpty { return }
              self.track = self.savedTracks[0]
              self.tabBarDelegate?.maximizeTrackDetailController(searchViewModel: self.track)
            } label: {
              Image(systemName: "play.fill")
                .frame(width: geometry.size.width / 2 - 10, height: 50)
                .accentColor(Color(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333))
                .background(Color(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928))
                .cornerRadius(10)
            } // Button
            Button {
              self.savedTracks = UserDefaults.standard.getSavedTracks()
            } label: {
              Image(systemName: "arrow.2.circlepath")
                .frame(width: geometry.size.width / 2 - 10, height: 50)
                .accentColor(Color(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333))
                .background(Color(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928))
                .cornerRadius(10)
            } // Button
          } // HStack
        } // GeometryReader
        .padding(.horizontal)
        .frame(height: 50)

        Divider()
          .padding(.top)
          .padding(.horizontal)

        List {
          ForEach(savedTracks) { track in
            LibraryViewCell(cell: track)
              .gesture(
                LongPressGesture()
                  .onEnded { _ in
                    print("Pressed!")
                    self.track = track
                    self.showingAlert = true
                  }
                  .simultaneously(with: TapGesture()
                    .onEnded { _ in
                      let tabBarVC = Helper.getTabBarViewController()
                      tabBarVC?.trackDetailView.trackMovingDelegate = self

                      self.track = track
                      self.tabBarDelegate?.maximizeTrackDetailController(searchViewModel: self.track)
                    }))
          } // ForEach
          .onDelete(perform: delete)
        } // List
        .listStyle(.inset)
      } // VStack
      .actionSheet(isPresented: $showingAlert) {
        ActionSheet(
          title: Text("Are you sure you want to delete this track?"),
          buttons: [
            .destructive(Text("Delete")) {
              print("Deleting: \(self.track.trackName)")
              self.delete(track: self.track)
            },
            .cancel(),
          ])
      } // actionSheet
    } // NavigationView
  } // body
}

private extension LibraryView {
  /// Removes all the elements at the specified offsets from the collection.
  ///
  /// - Parameter offsets: The range of valid integer values is 0..<INT_MAX-1.
  /// Anything outside this range is an error.
  func delete(at offsets: IndexSet) {
    savedTracks.remove(atOffsets: offsets)

    if let savedData = try? NSKeyedArchiver.archivedData(
      withRootObject: savedTracks,
      requiringSecureCoding: false)
    {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
    }
  }

  /// Delete received `track`.
  ///
  /// - Parameter track: The cell of the track.
  func delete(track: SearchViewModel.Cell) {
    let index = savedTracks.firstIndex(of: track)

    guard let myIndex = index else { return }

    savedTracks.remove(at: myIndex)

    if let savedData = try? NSKeyedArchiver.archivedData(
      withRootObject: savedTracks,
      requiringSecureCoding: false)
    {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
    }
  }
}

extension LibraryView: TrackMovingDelegate {
  /// Move back previous track.
  ///
  /// - Returns: The cell of the track that moved.
  func moveBack() -> SearchViewModel.Cell? {
    movePreviousTrack(for: .back)
  }

  /// Move forward previous track.
  ///
  /// - Returns: The cell of the track that moved.
  func moveForward() -> SearchViewModel.Cell? {
    movePreviousTrack(for: .forward)
  }

  /// Moves previous track from received music navigation state.
  ///
  /// - Parameter type: The type of the music navigatoin state.
  /// - Returns: The cell of the track.
  func movePreviousTrack(
    for type: MusicNavigationState
  ) -> SearchViewModel.Cell? {
    let index = savedTracks.firstIndex(of: track)

    guard let index else { return nil }

    var nextTrack: SearchViewModel.Cell

    switch type {
      case .back:
        nextTrack = index - 1 == -1
          ? savedTracks[savedTracks.count - 1]
          : savedTracks[index - 1]
      case .forward:
        nextTrack = index + 1 == savedTracks.count
          ? savedTracks[0]
          : savedTracks[index + 1]
    }

    track = nextTrack
    return nextTrack
  }
}

struct LibraryView_Previews: PreviewProvider {
  static var previews: some View {
    LibraryView()
  }
}
