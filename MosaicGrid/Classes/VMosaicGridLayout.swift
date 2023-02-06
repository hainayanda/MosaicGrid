//
//  VMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

struct VMosaicGridLayout: Layout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let gridHCount: Int
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    
    init(gridHCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
        self.gridHCount = gridHCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
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
            ).maxedH(at: gridHCount)
        }
        let mappedItems = mapItems(items)
        cache = mappedItems.mapped
        let width: CGFloat = (gridSize.width * CGFloat(gridHCount)) + (hSpacing * CGFloat(gridHCount - 1))
        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.numberOfRow)) + (vSpacing * CGFloat(mappedItems.numberOfRow - 1))
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
            
            let innerX = CGFloat(item.x) * (gridSize.width + hSpacing)
            let innerY = CGFloat(item.y) * (gridSize.height + vSpacing)
            
            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
            
            let realSize = item.item.view.sizeThatFits(ProposedViewSize(idealSize))
            let widthDifference = idealSize.width - realSize.width
            let heightDifference = idealSize.height - realSize.height
            
            let realOrigin = CGPoint(x: idealOrigin.x + (widthDifference / 2), y: idealOrigin.y + (heightDifference / 2))
            
            item.item.view.place(at: realOrigin, proposal: ProposedViewSize(realSize))
        }
    }
    
    private func gridSize(basedOn proposal: ProposedViewSize) -> CGSize {
        guard let proposedWidth = proposal.width else { return .zero }
        let usedWidth = proposedWidth - (hSpacing * CGFloat(gridHCount - 1))
        let singleGridDimension = usedWidth / CGFloat(gridHCount)
        return CGSize(width: singleGridDimension, height: singleGridDimension)
    }
    
    private func nextCoordinate(for item: MosaicGridLayoutItem, lastX: Int, lastY: Int) -> (x: Int, y: Int) {
        guard item.hGridCount <= gridHCount else { fatalError("width should be less or equal to gridHCount") }

        let goingDown = lastX + item.hGridCount >= gridHCount

        let x = goingDown ? 0: lastX + 1
        let y = goingDown ? lastY + 1: lastY

        if x + item.hGridCount > gridHCount {
            return (0, y + 1)
        }
        return (max(x, 0), max(y, 0))
    }

    private func coordinateToFill(for item: MosaicGridLayoutItem, x: Int, y: Int) -> [(x: Int, y: Int)] {
        (y ..< y + item.vGridCount).reduce([]) { partialResult, currentY in
            var mutableResult = partialResult
            let rows: [(Int, Int)] = (x ..< x + item.hGridCount).reduce([]) { partialRow, currentX in
                var mutableRow = partialRow
                mutableRow.append((currentX, currentY))
                return mutableRow
            }
            mutableResult.append(contentsOf: rows)
            return mutableResult
        }
    }
    
    private func mapItems(_ items: [MosaicGridLayoutItem]) -> (mapped: [MappedMosaicGridLayoutItem], numberOfRow: Int) {
        let modelMatrix = VMutableLogicalMatrix(width: gridHCount)
        var currentCoordinate: (x: Int, y: Int) = (-1, -1)
        
        let mapped: [MappedMosaicGridLayoutItem] = items.map { item in
            while true {
                let coordinate = nextCoordinate(for: item, lastX: currentCoordinate.x, lastY: currentCoordinate.y)
                currentCoordinate = coordinate
                let toFills = coordinateToFill(for: item, x: coordinate.x, y: coordinate.y)
                
                var isSafe = true
                for coordinate in toFills {
                    guard let isFilled = modelMatrix[coordinate.x, coordinate.y] else {
                        break
                    }
                    guard !isFilled else {
                        isSafe = false
                        break
                    }
                }
                guard isSafe else { continue }
                
                toFills.forEach { (x, y) in
                    modelMatrix[x, y] = true
                }
                return MappedMosaicGridLayoutItem(x: coordinate.x, y: coordinate.y, item: item)
            }
        }
        return (mapped, modelMatrix.height)
    }
    
}
