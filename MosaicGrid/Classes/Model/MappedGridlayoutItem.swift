//
//  MappedGridlayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation

struct MappedMosaicTileLayoutItem {
    let coordinate: MosaicGridCoordinate
    let sourceId: AnyHashable
    let mosaicSize: MosaicGridSize
    let lastMatrix: any MutableLogicalMatrix
    @inlinable var minX: Int { coordinate.x }
    @inlinable var minY: Int { coordinate.y }
}
