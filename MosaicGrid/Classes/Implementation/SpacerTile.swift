//
//  SpaceTile.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 2/2/24.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
/// Creates a clear rectangle with a given tile size.
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
