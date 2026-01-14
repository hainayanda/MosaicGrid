//
//  VMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

// MARK: MosaicGridLayout

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
protocol MosaicGridLayout: Layout {
    var spacing: MosaicGridSpacing { get }
    var crossOrientationCount: Int { get }
    var orientation: GridOrientation { get }
    
    func calculateGridSize(basedOn proposal: ProposedViewSize) -> CGSize
}

// MARK: MosaicGridLayout + Extensions

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension MosaicGridLayout {
    
    @inlinable var crossOrientation: GridOrientation {
        orientation == .vertical ? .horizontal: .vertical
    }
    
    @inlinable var crossAxisSpacing: CGFloat {
        orientation == .vertical ? spacing.horizontal: spacing.vertical
    }
}

// MARK: MosaicGridLayoutCache

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension MosaicGridLayout where Cache == MosaicGridLayoutCache {
    
    @inlinable func makeCache(subviews: Subviews) -> MosaicGridLayoutCache { .empty }
    
    @inlinable func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) -> CGSize {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            log(.info, "Calculated grid size is invalid. Width is \(gridSize.width) and height is \(gridSize.height). Will use zero instead.")
            return .zero
        }
        
        // Convert LayoutSubviews -> MosaicTileLayoutItem -> UnifiedMosaicLayoutItem
        let unifiedItems: [UnifiedMosaicLayoutItem] = subviews.enumerated().map { index, subview in
            let item = MosaicTileLayoutItem(
                view: subview, // We keep the view in the original item for ID and placement
                gridSize: gridSize,
                spacing: spacing
            )
            .maxed(crossOrientation, at: crossOrientationCount)
            
            return UnifiedMosaicLayoutItem(
                sourceId: AnyHashable(index), // Use index for identity for cache key
                sizeThatFits: item.sizeThatFits,
                mosaicSize: item.mosaicSize,
                spacing: spacing,
                gridSize: gridSize
            )
        }
        
        // Use Grid Engine (Shared)
        let engine = MosaicGridEngine(
            orientation: orientation,
            crossOrientationCount: crossOrientationCount,
            spacing: spacing
        )
        
        let reuseCache = cache.mightStillValid(with: proposal, gridSize: gridSize, spacing: spacing) ? cache.mapped : []
        let result = engine.calculateLayout(for: unifiedItems, cache: reuseCache)
        
        cache = MosaicGridLayoutCache(proposal: proposal, gridSize: gridSize, spacing: spacing, mapped: result.mapped)
        
        return result.size
    }
    
    @inlinable func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout MosaicGridLayoutCache) {
        let gridSize = calculateGridSize(basedOn: proposal)
        guard gridSize.width > .zero, gridSize.height > .zero else {
            return
        }
        let origin = bounds.origin
        
        let cacheLookup = cache.mapped
        
        for (index, subview) in subviews.enumerated() {
            guard let cacheIndex = cacheLookup.firstIndex(where: { $0.sourceId == AnyHashable(index) }) else { continue }
            let mappedItem = cacheLookup[cacheIndex]
            
            // Calculate placement
            let idealSize = mappedItem.mosaicSize.usedGridsSize(for: gridSize, with: spacing)
            let innerX = CGFloat(mappedItem.minX) * (gridSize.width + spacing.horizontal)
            let innerY = CGFloat(mappedItem.minY) * (gridSize.height + spacing.vertical)
            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
            
            let realSize = subview.sizeThatFits(ProposedViewSize(idealSize))
            
            let widthDifference = idealSize.width - realSize.width
            let heightDifference = idealSize.height - realSize.height
            
            let realOrigin = CGPoint(x: idealOrigin.x + (widthDifference / 2), y: idealOrigin.y + (heightDifference / 2))
            
            subview.place(at: realOrigin, proposal: ProposedViewSize(realSize))
        }
    }
}

// Helper for mapped item extensions if needed to recover lost helpers






