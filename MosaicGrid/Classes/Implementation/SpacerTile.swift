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
public func SpacerTile(w width: Int, h height: Int) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .tileSized(w: width, h: height)
}

/// Create a clear rectangle with a given tile size.
/// - Parameter width: number of horizontal tiles used.
/// - Returns: View with given tile size
@available(*, deprecated, renamed: "SpacerTile(h:v:)")
public func SpacerTile(w width: Int) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .tileSized(w: width, h: 1)
}

/// Create a clear rectangle with a given tile size.
/// - Parameter height: number of vertical tiles used.
/// - Returns: View with given tile size
@available(*, deprecated, renamed: "SpacerTile(h:v:)")
public func SpacerTile(h height: Int) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .tileSized(w: 1, h: height)
}

/// Create a clear rectangle with a given tile size.
/// - Parameters:
///   - horizontal: number of horizontal tiles used.
///   - vertical: number of vertical tiles used.
/// - Returns: View with given tile size
@inlinable public func SpacerTile(h horizontal: Int = 1, v vertical: Int = 1) -> some View {
    Rectangle()
        .foregroundColor(.clear)
        .usingGrids(h: horizontal, v: vertical)
}
// swiftlint:enable identifier_name
