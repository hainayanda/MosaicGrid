//
//  UsingGrids.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@usableFromInline struct UsingGrids: LayoutValueKey {
    @usableFromInline static let defaultValue: MosaicGridSize = MosaicGridSize(width: 1, height: 1)
}

// MARK: - MosaicGridSize

/// Represents the size of a grid in terms of horizontal and vertical units.
@usableFromInline struct MosaicGridSize: Equatable {
    /// The width of the grid in horizontal units.
    @usableFromInline let width: Int
    /// The height of the grid in vertical units.
    @usableFromInline let height: Int
    
    // swiftlint:disable unneeded_synthesized_initializer
    @usableFromInline init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    // swiftlint:enable unneeded_synthesized_initializer
}
