//
//  VMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

// MARK:  MosaicGridLayout

protocol MosaicGridLayout: Layout {
    var spacing: MosaicGridSpacing { get }
    var crossOrientationCount: Int { get }
    var orientation: Axis.Set { get }
    
    func tilesSize(basedOn proposal: ProposedViewSize) -> CGSize
}

// MARK:  MosaicGridLayout + Extensions

extension MosaicGridLayout {
    
    var crossOrientation: Axis.Set {
        orientation == .vertical ? .horizontal: .vertical
    }
    
    var axisSpacing: CGFloat {
        orientation == .vertical ? spacing.vertical: spacing.horizontal
    }
    
    var crossAxisSpacing: CGFloat {
        orientation == .vertical ? spacing.horizontal: spacing.vertical
    }
}

extension MosaicGridLayout where Cache == [MappedMosaicGridLayoutItem] {
    
    // MARK: Default Layout Implementation
    
    func makeCache(subviews: Subviews) -> [MappedMosaicGridLayoutItem] { [] }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) -> CGSize {
        let gridSize = tilesSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else { return .zero }
        let items = subviews.map { subview in
            MosaicGridLayoutItem(
                view: subview,
                proposal: proposal,
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
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) {
        let gridSize = tilesSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else { return }
        let origin = bounds.origin
        cache.forEach { item in
            let idealSize = item.item.idealSize
            let innerX = CGFloat(item.minX) * (gridSize.width + spacing.horizontal)
            let innerY = CGFloat(item.minY) * (gridSize.height + spacing.vertical)
            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
            
            let realSize = item.item.sizeThatFits
            let widthDifference = idealSize.width - realSize.width
            let heightDifference = idealSize.height - realSize.height
            
            let realOrigin = CGPoint(x: idealOrigin.x + (widthDifference / 2), y: idealOrigin.y + (heightDifference / 2))
            
            item.item.view.place(at: realOrigin, proposal: ProposedViewSize(realSize))
        }
    }
    
    // MARK: Private Methods
    
    private func makeMatrix() -> MutableLogicalMatrix {
        orientation == .vertical ? VMutableLogicalMatrix(width: crossOrientationCount): HMutableLogicalMatrix(height: crossOrientationCount)
    }
    
    private func nextCoordinate(for item: MosaicGridLayoutItem, lastCoordinate: MosaicGridCoordinate) -> MosaicGridCoordinate {
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
    
    private func coordinateToFill(for item: MosaicGridLayoutItem, coordinate: MosaicGridCoordinate) -> [MosaicGridCoordinate] {
        let x = coordinate.x
        let y = coordinate.y
        return (y ..< y + item.mosaicSize.height).reduce([]) { partialResult, currentY in
            var mutableResult = partialResult
            let rows: [MosaicGridCoordinate] = (x ..< x + item.mosaicSize.width).reduce([]) { partialRow, currentX in
                var mutableRow = partialRow
                mutableRow.append(MosaicGridCoordinate(x: currentX, y: currentY))
                return mutableRow
            }
            mutableResult.append(contentsOf: rows)
            return mutableResult
        }
    }
    
    private func mapItems(_ items: [MosaicGridLayoutItem]) -> (mapped: [MappedMosaicGridLayoutItem], rows: Int, column: Int) {
        let modelMatrix = makeMatrix()
        var currentCoordinate: MosaicGridCoordinate = MosaicGridCoordinate(x: -1, y: -1)
        
        let mapped: [MappedMosaicGridLayoutItem] = items.map { item in
            while true {
                let coordinate = nextCoordinate(for: item, lastCoordinate: currentCoordinate)
                currentCoordinate = coordinate
                let toFills = coordinateToFill(for: item, coordinate: coordinate)
                
                var isSafe = true
                for coordinate in toFills {
                    let isFilled = modelMatrix[coordinate.x, coordinate.y] ?? false
                    guard !isFilled else {
                        isSafe = false
                        break
                    }
                }
                guard isSafe else { continue }
                
                toFills.forEach { coordinate in
                    modelMatrix[coordinate.x, coordinate.y] = true
                }
                let mapped = MappedMosaicGridLayoutItem(coordinate: coordinate, item: item)
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

private extension MosaicGridLayoutItem {
    
    func gridCount(of axis: Axis.Set) -> Int {
        switch axis {
        case .vertical:
            return mosaicSize.height
        default:
            return mosaicSize.width
        }
    }
}

private extension MosaicGridCoordinate {
    
    init(orientation: Axis.Set, axis: Int, crossAxis: Int) {
        switch orientation {
        case .horizontal:
            self.y = axis
            self.x = crossAxis
        default:
            self.x = axis
            self.y = crossAxis
        }
    }
    
    func value(of axis: Axis.Set) -> Int {
        axis == .vertical ? y: x
    }
}
