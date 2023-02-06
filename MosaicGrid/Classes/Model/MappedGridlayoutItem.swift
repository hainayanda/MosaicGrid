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
    
    var maxX: Int { coordinate.x + item.hGridCount - 1 }
    var maxY: Int { coordinate.y + item.vGridCount - 1 }
    var minX: Int { coordinate.x }
    var minY: Int { coordinate.y }
}
