//
//  MappedGridlayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation

@dynamicMemberLookup
struct MappedMosaicTileLayoutItem {
    let coordinate: MosaicGridCoordinate
    let layoutItem: MosaicTileLayoutItem
    
    var maxX: Int { coordinate.x + layoutItem.mosaicSize.width - 1 }
    var maxY: Int { coordinate.y + layoutItem.mosaicSize.height - 1 }
    var minX: Int { coordinate.x }
    var minY: Int { coordinate.y }
    
    public subscript<Property>(
        dynamicMember keyPath: KeyPath<MosaicTileLayoutItem, Property>) -> Property {
            layoutItem[keyPath: keyPath]
        }
}
