//
//  MosaicGridEngine.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

struct MosaicGridEngine {
    
    let orientation: GridOrientation
    let crossOrientationCount: Int
    let spacing: MosaicGridSpacing
    
    init(orientation: GridOrientation, crossOrientationCount: Int, spacing: MosaicGridSpacing) {
        self.orientation = orientation
        self.crossOrientationCount = crossOrientationCount
        self.spacing = spacing
    }
    
    func calculateLayout(for items: [UnifiedMosaicLayoutItem], cache: [MappedMosaicTileLayoutItem] = []) -> (mapped: [MappedMosaicTileLayoutItem], size: CGSize) {
        
        let validCache = unmappedItemsWithValidCache(for: items, in: cache)
        let mappedItems = mapItems(cache: validCache.cache, validCache.unmappedItems)
        
        let gridSize = items.first?.gridSize ?? .zero
        
        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.column)) + (spacing.horizontal * CGFloat(mappedItems.column - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.rows)) + (spacing.vertical * CGFloat(mappedItems.rows - 1))
        
        return (mappedItems.mapped, CGSize(width: width, height: height))
    }
    
    // MARK: Private Implementation
    
    private func unmappedItemsWithValidCache(
        for items: [UnifiedMosaicLayoutItem], in cache: [MappedMosaicTileLayoutItem]
    ) -> (cache: [MappedMosaicTileLayoutItem], unmappedItems: [UnifiedMosaicLayoutItem]) {
        var mutableItems = items
        var validCache: [MappedMosaicTileLayoutItem] = []
        for mapped in cache {
            guard let item = mutableItems.first, mapped.sourceId == item.sourceId else {
                return (validCache, mutableItems)
            }
            mutableItems.removeFirst()
            validCache.append(mapped)
        }
        return (validCache, mutableItems)
    }
    
    private func mapItems(cache: [MappedMosaicTileLayoutItem], _ items: [UnifiedMosaicLayoutItem]) -> (mapped: [MappedMosaicTileLayoutItem], rows: Int, column: Int) {
        var mutableMatrix: any MutableLogicalMatrix
        if let lastCache = cache.last {
            mutableMatrix = lastCache.lastMatrix
        } else {
            mutableMatrix = makeMutableMatrix()
        }
        let results: [MappedMosaicTileLayoutItem] = items.map { item in
            put(item: item, into: &mutableMatrix)
        }
        return (cache + results, mutableMatrix.height, mutableMatrix.width)
    }
    
    private func makeMutableMatrix() -> any MutableLogicalMatrix {
        orientation == .vertical
        ? VMutableLogicalMatrix(width: crossOrientationCount)
        : HMutableLogicalMatrix(height: crossOrientationCount)
    }
    
    private func put(item: UnifiedMosaicLayoutItem, into matrix: inout any MutableLogicalMatrix) -> MappedMosaicTileLayoutItem {
        for (index, innerIndex, value) in matrix.iterateFromLastAvailableIndex() where !value {
            let coordinate = MosaicGridCoordinate(
                x: orientation == .vertical ? innerIndex : index,
                y: orientation == .vertical ? index : innerIndex
            )
            let toFills = item.mapToGridCoordinate(startFrom: coordinate)
            guard toFills.isValidToFill(matrix: matrix, orientation: orientation) else { continue }
            return mark(coordinate: coordinate, from: toFills, of: item, into: &matrix)
        }
        let fallbackCoordinate = MosaicGridCoordinate(
            x: orientation == .vertical ? .zero : matrix.width,
            y: orientation == .vertical ? matrix.height : .zero
        )
        let toFills = item.mapToGridCoordinate(startFrom: fallbackCoordinate)
        return mark(coordinate: fallbackCoordinate, from: toFills, of: item, into: &matrix)
    }
    
    // MARK: Helpers
    
    private func mark(
        coordinate: MosaicGridCoordinate,
        from coordinates: some Sequence<MosaicGridCoordinate>,
        of item: UnifiedMosaicLayoutItem,
        into matrix: inout any MutableLogicalMatrix) -> MappedMosaicTileLayoutItem {
            coordinates.forEach { coordinate in
                matrix[coordinate.x, coordinate.y] = true
            }
            let mapped = MappedMosaicTileLayoutItem(
                coordinate: coordinate,
                sourceId: item.sourceId,
                mosaicSize: item.mosaicSize,
                lastMatrix: matrix
            )
            return mapped
        }
}

// MARK: - Private Extension

private extension Sequence where Element == MosaicGridCoordinate {
    func isValidToFill(matrix: any MutableLogicalMatrix, orientation: GridOrientation) -> Bool {
        for coordinate in self {
            // Check bounds first - simplified logic
            if orientation == .vertical {
                if matrix.width <= coordinate.x { return false }
                if matrix.height <= coordinate.y { continue }
            } else {
                if matrix.height <= coordinate.y { return false }
                if matrix.width <= coordinate.x { continue }
            }
            
            // Check if filled
            if matrix[coordinate.x, coordinate.y] { return false }
        }
        return true
    }
}
