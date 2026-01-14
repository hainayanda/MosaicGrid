//
//  MosaicTileLayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct MosaicTileLayoutItem: Equatable {
    let view: LayoutSubview
    let sizeThatFits: CGSize
    let mosaicSize: MosaicGridSize
    let spacing: MosaicGridSpacing
    let gridSize: CGSize
    var usedGridsSize: CGSize { mosaicSize.usedGridsSize(for: gridSize, with: spacing) }
    
    @inlinable init(view: LayoutSubview, sizeThatFits: CGSize, gridSize: CGSize, mosaicSize: MosaicGridSize, spacing: MosaicGridSpacing) {
        self.view = view
        self.sizeThatFits = sizeThatFits
        self.mosaicSize = mosaicSize
        self.spacing = spacing
        self.gridSize = gridSize
    }
    
    @inlinable init(view: LayoutSubview, gridSize: CGSize, spacing: MosaicGridSpacing) {
        self.view = view
        self.spacing = spacing
        self.gridSize = gridSize
        let tilesSize = view[UsingGrids.self]
        let mosaicSizeProposal = tilesSize.proposalSize(for: gridSize, spacing: spacing)
        self.sizeThatFits = view.sizeThatFits(mosaicSizeProposal)
        self.mosaicSize = sizeThatFits.mosaicGridSize(using: gridSize, spacing: spacing)
    }
    
    @inlinable func maxedH(at height: Int) -> MosaicTileLayoutItem {
        MosaicTileLayoutItem(
            view: view,
            sizeThatFits: sizeThatFits,
            gridSize: gridSize,
            mosaicSize: MosaicGridSize(width: mosaicSize.width, height: min(mosaicSize.height, height)),
            spacing: spacing
        )
    }
    
    @inlinable func maxedW(at width: Int) -> MosaicTileLayoutItem {
        MosaicTileLayoutItem(
            view: view,
            sizeThatFits: sizeThatFits,
            gridSize: gridSize,
            mosaicSize: MosaicGridSize(width: min(mosaicSize.width, width), height: mosaicSize.height),
            spacing: spacing
        )
    }
    
    @inlinable func maxed(_ axis: GridOrientation, at max: Int) -> MosaicTileLayoutItem {
        switch axis {
        case .vertical:
            return maxedH(at: max)
        default:
            return maxedW(at: max)
        }
    }
    
    @inlinable func mapToGridCoordinate(startFrom coordinate: MosaicGridCoordinate) -> MosaicGridCoordinateSequence {
        MosaicGridCoordinateSequence(startFrom: coordinate, size: mosaicSize)
    }
}

struct MosaicGridCoordinateSequence: Sequence {
    let startX: Int
    let startY: Int
    let width: Int
    let height: Int
    
    @inlinable init(startFrom coordinate: MosaicGridCoordinate, size: MosaicGridSize) {
        self.startX = coordinate.x
        self.startY = coordinate.y
        self.width = size.width
        self.height = size.height
    }
    
    @inlinable func makeIterator() -> Iterator {
        Iterator(startX: startX, startY: startY, width: width, height: height)
    }
    
    struct Iterator: IteratorProtocol {
        let startX: Int
        let startY: Int
        let width: Int
        let height: Int
        var currentX: Int = 0
        var currentY: Int = 0
        
        @inlinable mutating func next() -> MosaicGridCoordinate? {
            if width == 0 || height == 0 { return nil }
            if currentY >= height { return nil }
            let coord = MosaicGridCoordinate(x: startX + currentX, y: startY + currentY)
            currentX += 1
            if currentX >= width {
                currentX = 0
                currentY += 1
            }
            return coord
        }
    }
}

private extension CGSize {
    
    func mosaicGridSize(using gridSize: CGSize, spacing: MosaicGridSpacing) -> MosaicGridSize {
        MosaicGridSize(
            width: calculateGridCount(for: width, gridDimension: gridSize.width, spacing: spacing.horizontal),
            height: calculateGridCount(for: height, gridDimension: gridSize.height, spacing: spacing.vertical)
        )
    }
    
    func calculateGridCount(for dimension: CGFloat, gridDimension: CGFloat, spacing: CGFloat) -> Int {
        let roughResult = (dimension / (gridDimension + spacing)).rounded(.up)
        let validation = (roughResult * gridDimension) + ((roughResult - 1) * spacing)
        let result = validation >= dimension ? roughResult: roughResult + 1
        return Int(result)
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private extension MosaicGridSize {
    
    func proposalSize(
        for gridSize: CGSize,
        spacing: MosaicGridSpacing) -> ProposedViewSize {
            let proposalWidth: CGFloat = (CGFloat(width) * gridSize.width) + (CGFloat(width - 1) * spacing.horizontal)
            let proposalHeight: CGFloat = (CGFloat(height) * gridSize.height) + (CGFloat(height - 1) * spacing.vertical)
            return ProposedViewSize(width: proposalWidth, height: proposalHeight)
        }
}
