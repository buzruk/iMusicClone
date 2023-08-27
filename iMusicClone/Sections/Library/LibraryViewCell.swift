//
//  LibraryViewCell.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import Kingfisher
import SwiftUI

struct LibraryViewCell: View {
  var cell: SearchViewModel.Cell

  var body: some View {
    HStack {
      KFImage(URL(string: self.cell.iconUrl ?? ""))
        .resizable()
        .frame(width: 60, height: 60)
        .cornerRadius(2)
      VStack(alignment: .leading) {
        Text("\(cell.trackName)")
        Text("\(cell.artistName)")
      } // VStack
    } // HStack
  } // body
}

struct LibraryViewCell_Previews: PreviewProvider {
  static var previews: some View {
    LibraryViewCell(cell: SearchViewModel.Cell(
      trackName: "Mawlaya",
      collectionName: nil,
      artistName: "Maher Zain",
      iconUrl: nil,
      previewUrl: nil))
  }
}
