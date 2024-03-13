//
//  SpaceTile.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 2/2/24.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
/// Create a clear rectangle with a given tile size.
/// - Parameters:
///   - width: number of horizontal tiles used.
///   - height: number of vertical tiles used.
/// - Returns: View with given tile size
@available(*, deprecated, renamed: "SpacerTile(h:v:)")
public func SpacerTile(w width: Int = 1, h height: Int = 1) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .tileSized(w: width, h: height)
}

/// Create a clear rectangle with a given tile size.
/// - Parameters:
///   - horizontal: number of horizontal tiles used.
///   - vertical: number of vertical tiles used.
/// - Returns: View with given tile size
public func SpacerTile(h horizontal: Int = 1, v vertical: Int = 1) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .usingGrids(h: horizontal, v: vertical)
}
// swiftlint:enable identifier_name
