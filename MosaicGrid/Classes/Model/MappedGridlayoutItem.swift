//
//  MappedGridlayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation

struct MappedMosaicGridLayoutItem {
    let coordinate: MosaicGridCoordinate
    let item: MosaicGridLayoutItem
    
    var maxX: Int { coordinate.x + item.mosaicSize.width - 1 }
    var maxY: Int { coordinate.y + item.mosaicSize.height - 1 }
    var minX: Int { coordinate.x }
    var minY: Int { coordinate.y }
}
