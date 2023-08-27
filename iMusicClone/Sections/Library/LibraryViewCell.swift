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
          .font(.system(size: 17, weight: .medium))
          .lineLimit(1)

        Text("\(cell.artistName)")
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.init(hex: "7E7E85"))
          .lineLimit(1)
        if cell.collectionName != nil {
          Text("\(cell.collectionName!)")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.init(hex: "7E7E85"))
            .lineLimit(1)
        }
      } // VStack
    } // HStack
  } // body
}

struct LibraryViewCell_Previews: PreviewProvider {
  static var previews: some View {
    LibraryViewCell(cell: SearchViewModel.Cell(
      trackName: "Mawlaya",
      collectionName: "Best Islamic Arabic Songs",
      artistName: "Maher Zain",
      iconUrl: nil,
      previewUrl: nil))
  }
}
