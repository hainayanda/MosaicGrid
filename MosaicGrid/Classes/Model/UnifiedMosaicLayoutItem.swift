//
//  UnifiedMosaicLayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

// This struct replaces `MosaicTileLayoutItem` for use in the Engine,
// or we adapt `MosaicTileLayoutItem` to use this.
// To avoid breaking changes, we might make a protocol or intermediate struct.

protocol MosaicLayoutItemSource {
    var sizeThatFits: CGSize { get }
    var mosaicSize: MosaicGridSize { get }
    var gridSpacing: MosaicGridSpacing { get }
    var gridSize: CGSize { get }
    
    // We don't need the view itself in the Engine calculation, just its dimensions.
}

struct UnifiedMosaicLayoutItem {
    let sourceId: AnyHashable
    let sizeThatFits: CGSize
    let mosaicSize: MosaicGridSize
    let spacing: MosaicGridSpacing
    let gridSize: CGSize
    
    var usedGridsSize: CGSize { mosaicSize.usedGridsSize(for: gridSize, with: spacing) }
    
    func mapToGridCoordinate(startFrom coordinate: MosaicGridCoordinate) -> MosaicGridCoordinateSequence {
        MosaicGridCoordinateSequence(startFrom: coordinate, size: mosaicSize)
    }
    
    func maxedH(at height: Int) -> UnifiedMosaicLayoutItem {
        UnifiedMosaicLayoutItem(
            sourceId: sourceId,
            sizeThatFits: sizeThatFits,
            mosaicSize: MosaicGridSize(width: mosaicSize.width, height: min(mosaicSize.height, height)),
            spacing: spacing,
            gridSize: gridSize
        )
    }
    
    func maxedW(at width: Int) -> UnifiedMosaicLayoutItem {
        UnifiedMosaicLayoutItem(
            sourceId: sourceId,
            sizeThatFits: sizeThatFits,
            mosaicSize: MosaicGridSize(width: min(mosaicSize.width, width), height: mosaicSize.height),
            spacing: spacing,
            gridSize: gridSize
        )
    }
    
    func maxed(_ axis: GridOrientation, at max: Int) -> UnifiedMosaicLayoutItem {
        switch axis {
        case .vertical:
            return maxedH(at: max)
        default:
            return maxedW(at: max)
        }
    }
}


