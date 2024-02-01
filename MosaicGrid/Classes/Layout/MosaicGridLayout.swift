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
    
    func tilesSize(basedOn proposal: ProposedViewSize) -> CGSize
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

// MARK: Default Implementation

extension MosaicGridLayout where Cache == [MappedMosaicTileLayoutItem] {
    
    @inlinable func makeCache(subviews: Subviews) -> [MappedMosaicTileLayoutItem] { [] }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicTileLayoutItem]) -> CGSize {
        let gridSize = tilesSize(basedOn: proposal)
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
        let mappedItems = mapItems(items)
        cache = mappedItems.mapped
        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.column)) + (spacing.horizontal * CGFloat(mappedItems.column - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.rows)) + (spacing.vertical * CGFloat(mappedItems.rows - 1))
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicTileLayoutItem]) {
        let gridSize = tilesSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Widht is \(gridSize.width) and height is \(gridSize.height). Will not place a subview")
            return
        }
        let origin = bounds.origin
        cache.forEach { item in
            let idealSize = item.tileSize
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
    
    private func mapItems(_ items: [MosaicTileLayoutItem]) -> (mapped: [MappedMosaicTileLayoutItem], rows: Int, column: Int) {
        let modelMatrix = makeMutableMatrix()
        var currentCoordinate: MosaicGridCoordinate = MosaicGridCoordinate(x: -1, y: -1)
        let mapped: [MappedMosaicTileLayoutItem] = items.map { item in
            while true {
                let coordinate = nextCoordinate(for: item, lastCoordinate: currentCoordinate)
                currentCoordinate = coordinate
                
                let toFills = item.mapToGridCoordinate(startFrom: coordinate)
                
                guard toFills.isValid(in: modelMatrix) else { continue }
                
                toFills.forEach { coordinate in
                    modelMatrix[coordinate.x, coordinate.y] = true
                }
                
                let mapped = MappedMosaicTileLayoutItem(coordinate: coordinate, layoutItem: item)
                currentCoordinate = orientation == .vertical
                ? MosaicGridCoordinate(x: mapped.maxX, y: mapped.minY)
                : MosaicGridCoordinate(x: mapped.minX, y: mapped.maxY)
                return mapped
            }
        }
        return (mapped, modelMatrix.height, modelMatrix.width)
    }
}

// MARK: Private Extensions

private extension Sequence where Element == MosaicGridCoordinate {
    func isValid(in matrix: MutableLogicalMatrix) -> Bool {
        for coordinate in self {
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
