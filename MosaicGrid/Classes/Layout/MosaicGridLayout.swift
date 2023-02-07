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
    var hSpacing: CGFloat { get }
    var vSpacing: CGFloat { get }
    var crossOrientationCount: Int { get }
    var orientation: Axis.Set { get }
    
    func gridSize(basedOn proposal: ProposedViewSize) -> CGSize
}

// MARK:  MosaicGridLayout + Extensions

extension MosaicGridLayout {
    
    var crossOrientation: Axis.Set {
        orientation == .vertical ? .horizontal: .vertical
    }
    
    var axisSpacing: CGFloat {
        orientation == .vertical ? vSpacing: hSpacing
    }
    
    var crossAxisSpacing: CGFloat {
        orientation == .vertical ? hSpacing: vSpacing
    }
    
    func gridSize(basedOn geometry: GeometryProxy) -> CGSize {
        gridSize(basedOn: ProposedViewSize(geometry.size))
    }
}

extension MosaicGridLayout where Cache == [MappedMosaicGridLayoutItem] {
    
    // MARK: Default Layout Implementation
    
    func makeCache(subviews: Subviews) -> [MappedMosaicGridLayoutItem] { [] }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) -> CGSize {
        let gridSize = gridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else { return .zero }
        let items = subviews.map { subview in
            MosaicGridLayoutItem(
                view: subview,
                proposal: proposal,
                gridSize: gridSize,
                hSpacing: hSpacing,
                vSpacing: vSpacing
            ).maxed(crossOrientation, at: crossOrientationCount)
        }
        let mappedItems = mapItems(items)
        cache = mappedItems.mapped
        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.column)) + (hSpacing * CGFloat(mappedItems.column - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.rows)) + (vSpacing * CGFloat(mappedItems.rows - 1))
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) {
        let gridSize = gridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else { return }
        let origin = bounds.origin
        cache.forEach { item in
            let hGridCount = CGFloat(item.item.hGridCount)
            let vGridCount = CGFloat(item .item.vGridCount)
            let width = (gridSize.width * hGridCount) + (hSpacing * (hGridCount - 1))
            let height = (gridSize.height * vGridCount) + (vSpacing * (vGridCount - 1))
            
            let idealSize = CGSize(width: width, height: height)
            
            let innerX = CGFloat(item.minX) * (gridSize.width + hSpacing)
            let innerY = CGFloat(item.minY) * (gridSize.height + vSpacing)
            
            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
            
            let realSize = item.item.view.sizeThatFits(ProposedViewSize(idealSize))
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
        guard item.hGridCount <= crossOrientationCount else { fatalError("width should be less or equal to gridHCount") }
        
        let lastCrossAxis = lastCoordinate.value(of: crossOrientation)
        let lastAxis = lastCoordinate.value(of: orientation)
        let crossAxisCount = item.gridCount(of: crossOrientation)
        
        let shifting = lastCrossAxis + crossAxisCount >= crossOrientationCount
        
        let crossAxis = shifting ? 0: lastCrossAxis + 1
        let axis = shifting ? lastAxis + 1: lastAxis
        
        if crossAxis + crossAxisCount > crossOrientationCount {
            return orientation == .vertical ? MosaicGridCoordinate(x: 0, y: axis + 1): MosaicGridCoordinate(x: axis + 1, y: 0)
        }
        return orientation == .vertical ? MosaicGridCoordinate(x: max(crossAxis, 0), y: max(axis, 0)): MosaicGridCoordinate(x: max(axis, 0), y: max(crossAxis, 0))
    }
    
    private func coordinateToFill(for item: MosaicGridLayoutItem, coordinate: MosaicGridCoordinate) -> [MosaicGridCoordinate] {
        let x = coordinate.x
        let y = coordinate.y
        return (y ..< y + item.vGridCount).reduce([]) { partialResult, currentY in
            var mutableResult = partialResult
            let rows: [MosaicGridCoordinate] = (x ..< x + item.hGridCount).reduce([]) { partialRow, currentX in
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
            return vGridCount
        default:
            return hGridCount
        }
    }
    
    func maxedV(at maxV: Int) -> MosaicGridLayoutItem {
        MosaicGridLayoutItem(view: view, hGridCount: hGridCount, vGridCount: min(vGridCount, maxV))
    }
    
    func maxedH(at maxH: Int) -> MosaicGridLayoutItem {
        MosaicGridLayoutItem(view: view, hGridCount: min(hGridCount, maxH), vGridCount: vGridCount)
    }
    
    func maxed(_ axis: Axis.Set, at max: Int) -> MosaicGridLayoutItem {
        switch axis {
        case .vertical:
            return maxedV(at: max)
        default:
            return maxedH(at: max)
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
