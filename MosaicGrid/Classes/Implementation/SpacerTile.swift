//
//  SpaceTile.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 2/2/24.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
public func SpacerTile(w width: Int = 1, h height: Int = 1) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .tileSized(w: width, h: height)
}
// swiftlint:enable identifier_name
