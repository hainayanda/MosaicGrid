//
//  Tiles.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

@usableFromInline struct UsingGrids: LayoutValueKey {
    @usableFromInline static let defaultValue: MosaicGridSize = MosaicGridSize(width: 1, height: 1)
}

@usableFromInline struct MosaicGridSize: Equatable {
    let width: Int
    let height: Int
    
    // swiftlint:disable unneeded_synthesized_initializer
    @usableFromInline init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    // swiftlint:enable unneeded_synthesized_initializer
}
