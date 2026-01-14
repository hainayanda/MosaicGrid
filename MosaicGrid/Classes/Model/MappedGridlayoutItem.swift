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
    
    // We can't proxy properties anymore, users of this struct must look up info via the sourceId or valid cache logic.
    @inlinable var minX: Int { coordinate.x }
    @inlinable var minY: Int { coordinate.y }
}
