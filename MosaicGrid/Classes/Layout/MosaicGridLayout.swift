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
    var orientation: Axis.Set { get }
    
    func calculateGridSize(basedOn proposal: ProposedViewSize) -> CGSize
}

// MARK: MosaicGridLayout + Extensions

extension MosaicGridLayout {
    
    @inlinable var crossOrientation: Axis.Set {
        orientation == .vertical ? .horizontal: .vertical
    }
    
    @inlinable var crossAxisSpacing: CGFloat {
        orientation == .vertical ? spacing.horizontal: spacing.vertical
    }
}

struct MosaicGridLayoutCache {
    let proposal: ProposedViewSize
    let mapped: [MappedMosaicTileLayoutItem]
    
    static var empty: MosaicGridLayoutCache { .init(proposal: .unspecified, mapped: [])}
}

// MARK: Default Implementation

extension MosaicGridLayout where Cache == MosaicGridLayoutCache {
    
    @inlinable func makeCache(subviews: Subviews) -> MosaicGridLayoutCache { .empty }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) -> CGSize {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Widht is \(gridSize.width) and height is \(gridSize.height). Will use zero instead.")
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
        
        // only used cache if the proposal size is the same as cache.
        let mappedCache: [MappedMosaicTileLayoutItem] = cache.proposal == proposal ? cache.mapped: []
        
        // get valid items in cache
        let itemsCachePairs = unmappedItemsWithValidCache(for: items, in: mappedCache)
        
        // map items but skip the already mapped items in cache
        let mappedItems = mapItems(cache: itemsCachePairs.cache, itemsCachePairs.unmappedItems)
        
        // store the new mapped items in cache
        cache = .init(proposal: proposal, mapped: mappedItems.mapped)
        
        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.column)) + (spacing.horizontal * CGFloat(mappedItems.column - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.rows)) + (spacing.vertical * CGFloat(mappedItems.rows - 1))
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Widht is \(gridSize.width) and height is \(gridSize.height). Will not place a subview")
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
    
    private func makeMutableMatrix() -> MutableLogicalMatrix {
        orientation == .vertical
        ? VMutableLogicalMatrix(width: crossOrientationCount)
        : HMutableLogicalMatrix(height: crossOrientationCount)
    }
    
    private func nextCoordinate(for item: MosaicTileLayoutItem, lastCoordinate: MosaicGridCoordinate) -> MosaicGridCoordinate {
        let lastCrossAxis = lastCoordinate.value(of: crossOrientation)
        let lastAxis = lastCoordinate.value(of: orientation)
        let crossAxisCount = item.gridCount(of: crossOrientation)
        
        let shifting = lastCrossAxis + crossAxisCount >= crossOrientationCount
        
        let crossAxis = shifting ? 0: lastCrossAxis + 1
        let axis = shifting ? lastAxis + 1: lastAxis
        
        if crossAxis + crossAxisCount > crossOrientationCount {
            return orientation == .vertical
            ? MosaicGridCoordinate(x: 0, y: axis + 1)
            : MosaicGridCoordinate(x: axis + 1, y: 0)
        }
        return orientation == .vertical
        ? MosaicGridCoordinate(x: max(crossAxis, 0), y: max(axis, 0))
        : MosaicGridCoordinate(x: max(axis, 0), y: max(crossAxis, 0))
    }
    
    private func mapItems(cache: [MappedMosaicTileLayoutItem], _ items: [MosaicTileLayoutItem]) -> (mapped: [MappedMosaicTileLayoutItem], rows: Int, column: Int) {
        var mutableMatrix: MutableLogicalMatrix
        var currentCoordinate: MosaicGridCoordinate
        if let lastCache = cache.last {
            mutableMatrix = lastCache.lastMatrix
            currentCoordinate = lastCache.coordinate
        } else {
            mutableMatrix = makeMutableMatrix()
            currentCoordinate = MosaicGridCoordinate(x: -1, y: -1)
        }
        let results: [MappedMosaicTileLayoutItem] = items.map { item in
            while true {
                let coordinate = nextCoordinate(for: item, lastCoordinate: currentCoordinate)
                currentCoordinate = coordinate
                
                let toFills = item.mapToGridCoordinate(startFrom: coordinate)
                
                guard toFills.isValidToFill(matrix: mutableMatrix) else { continue }
                
                toFills.forEach { coordinate in
                    mutableMatrix[coordinate.x, coordinate.y] = true
                }
                
                let mapped = MappedMosaicTileLayoutItem(coordinate: coordinate, layoutItem: item, lastMatrix: mutableMatrix)
                currentCoordinate = orientation == .vertical
                ? MosaicGridCoordinate(x: mapped.maxX, y: mapped.minY)
                : MosaicGridCoordinate(x: mapped.minX, y: mapped.maxY)
                return mapped
            }
        }
        return (cache + results, mutableMatrix.height, mutableMatrix.width)
    }
}

// MARK: Private Extensions

private extension Sequence where Element == MosaicGridCoordinate {
    func isValidToFill(matrix: MutableLogicalMatrix) -> Bool {
        for coordinate in self where matrix.isValid(coordinate.x, coordinate.y) {
            let isFilled = matrix[coordinate.x, coordinate.y] ?? false
            if isFilled { return false }
        }
        return true
    }
}

private extension MosaicTileLayoutItem {
    
    func gridCount(of axis: Axis.Set) -> Int {
        switch axis {
        case .vertical:
            return mosaicSize.height
        default:
            return mosaicSize.width
        }
    }
    
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

private extension MosaicGridCoordinate {
    
    func value(of axis: Axis.Set) -> Int {
        axis == .vertical ? y: x
    }
}
