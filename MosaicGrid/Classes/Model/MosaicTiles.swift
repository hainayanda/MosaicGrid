//
//  Tiles.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicTiles: LayoutValueKey {
    static let defaultValue: MosaicGridSize = MosaicGridSize(width: 1, height: 1)
}

struct MosaicGridSize: Equatable {
    let width: Int
    let height: Int
}
