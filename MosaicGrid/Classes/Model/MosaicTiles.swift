//
//  Tiles.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicTiles: LayoutValueKey {
    static let defaultValue: MosaicGridSize? = nil
}

struct MosaicGridSize {
    let width: Int
    let height: Int
}
