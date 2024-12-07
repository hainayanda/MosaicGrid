//
//  VMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

// MARK: MosaicGridLayout

protocol MosaicGridLayout: Layout {
    var spacing: MosaicGridSpacing { get }
    var crossOrientationCount: Int { get }
    var orientation: GridOrientation { get }
    
    func calculateGridSize(basedOn proposal: ProposedViewSize) -> CGSize
}

// MARK: MosaicGridLayout + Extensions

extension MosaicGridLayout {
    
    @inlinable var crossOrientation: GridOrientation {
        orientation == .vertical ? .horizontal: .vertical
    }
    
    @inlinable var crossAxisSpacing: CGFloat {
        orientation == .vertical ? spacing.horizontal: spacing.vertical
    }
}

// MARK: MosaicGridLayoutCache

struct MosaicGridLayoutCache {
    let proposal: ProposedViewSize
    let gridSize: CGSize
    let spacing: MosaicGridSpacing
    let mapped: [MappedMosaicTileLayoutItem]
    
    @inlinable static var empty: MosaicGridLayoutCache {
        MosaicGridLayoutCache(
            proposal: .unspecified,
            gridSize: .zero,
            spacing: .zero,
            mapped: []
        )
    }
    
    @inlinable func mightStillValid(with proposal: ProposedViewSize, gridSize: CGSize, spacing: MosaicGridSpacing) -> Bool {
        proposal == self.proposal && gridSize == self.gridSize && spacing == self.spacing
    }
}

// MARK: Default Implementation

extension MosaicGridLayout where Cache == MosaicGridLayoutCache {
    
    @inlinable func makeCache(subviews: Subviews) -> MosaicGridLayoutCache { .empty }
    
    @inlinable func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) -> CGSize {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Width is \(gridSize.width) and height is \(gridSize.height). Will use zero instead.")
            return .zero
        }
        let items = subviews.map { subview in
            MosaicTileLayoutItem(
                view: subview,
                gridSize: gridSize,
                spacing: spacing
            )
            .maxed(crossOrientation, at: crossOrientationCount)
        }
        
        // only used cache if the proposal size, grid size and spacing is the same as cache.
        let mappedCache: [MappedMosaicTileLayoutItem] = cache.mightStillValid(with: proposal, gridSize: gridSize, spacing: spacing) ? cache.mapped: []
        
        // get valid items in cache
        let itemsCachePairs = unmappedItemsWithValidCache(for: items, in: mappedCache)
        
        // map items but skip the already mapped items in cache
        let mappedItems = mapItems(cache: itemsCachePairs.cache, itemsCachePairs.unmappedItems)
        
        // store the new mapped items in cache
        cache = MosaicGridLayoutCache(proposal: proposal, gridSize: gridSize, spacing: spacing, mapped: mappedItems.mapped)
        
        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.column)) + (spacing.horizontal * CGFloat(mappedItems.column - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.rows)) + (spacing.vertical * CGFloat(mappedItems.rows - 1))
        return CGSize(width: width, height: height)
    }
    
    @inlinable func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Width is \(gridSize.width) and height is \(gridSize.height). Will not place a subview")
            return
        }
        let origin = bounds.origin
        cache.mapped.forEach { item in
            let idealSize = item.usedGridsSize
            let innerX = CGFloat(item.minX) * (gridSize.width + spacing.horizontal)
            let innerY = CGFloat(item.minY) * (gridSize.height + spacing.vertical)
            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
            
            let realSize = item.sizeThatFits
            let widthDifference = idealSize.width - realSize.width
            let heightDifference = idealSize.height - realSize.height
            
            let realOrigin = CGPoint(x: idealOrigin.x + (widthDifference / 2), y: idealOrigin.y + (heightDifference / 2))
            
            item.view.place(at: realOrigin, proposal: ProposedViewSize(realSize))
        }
    }
    
    // MARK: Private Methods
    
    private func unmappedItemsWithValidCache(
        for items: [MosaicTileLayoutItem], in cache: [MappedMosaicTileLayoutItem]
    ) -> (cache: [MappedMosaicTileLayoutItem], unmappedItems: [MosaicTileLayoutItem]) {
        var mutableItems = items
        var validCache: [MappedMosaicTileLayoutItem] = []
        for mapped in cache {
            guard let item = mutableItems.first, mapped.layoutItem == item else {
                return (validCache, mutableItems)
            }
            mutableItems.removeFirst()
            validCache.append(mapped)
        }
        return (validCache, mutableItems)
    }
    
    private func makeMutableMatrix() -> any MutableLogicalMatrix {
        orientation == .vertical
        ? VMutableLogicalMatrix(width: crossOrientationCount)
        : HMutableLogicalMatrix(height: crossOrientationCount)
    }
    
    private func mapItems(cache: [MappedMosaicTileLayoutItem], _ items: [MosaicTileLayoutItem]) -> (mapped: [MappedMosaicTileLayoutItem], rows: Int, column: Int) {
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
    
    private func put(item: MosaicTileLayoutItem, into matrix: inout any MutableLogicalMatrix) -> MappedMosaicTileLayoutItem {
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
    
    private func mark(
        coordinate: MosaicGridCoordinate,
        from coordinates: [MosaicGridCoordinate],
        of item: MosaicTileLayoutItem,
        into matrix: inout any MutableLogicalMatrix) -> MappedMosaicTileLayoutItem {
        coordinates.forEach { coordinate in
            matrix[coordinate.x, coordinate.y] = true
        }
        let mapped = MappedMosaicTileLayoutItem(
            coordinate: coordinate,
            layoutItem: item,
            lastMatrix: matrix
        )
        return mapped
    }
}

// MARK: Private Extensions

private extension Sequence where Element == MosaicGridCoordinate {
    func isValidToFill(matrix: any MutableLogicalMatrix, orientation: GridOrientation) -> Bool {
        for coordinate in self {
            switch orientation {
            case .vertical:
                if matrix.width <= coordinate.x {
                    return false
                } else if matrix.height <= coordinate.y { continue }
            case .horizontal:
                if matrix.height <= coordinate.y {
                    return false
                } else if matrix.width <= coordinate.x { continue }
            }
            let isFilled = matrix[coordinate.x, coordinate.y]
            if isFilled { return false }
        }
        return true
    }
}

private extension MosaicTileLayoutItem {
    
    func mapToGridCoordinate(startFrom coordinate: MosaicGridCoordinate) -> [MosaicGridCoordinate] {
        let x = coordinate.x
        let y = coordinate.y
        return (y ..< y + mosaicSize.height).flatMap { currentY in
            (x ..< x + mosaicSize.width).map { currentX in
                MosaicGridCoordinate(x: currentX, y: currentY)
            }
        }
    }
}
