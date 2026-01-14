//
//  FlowMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 1/10/24.
//

import Foundation
import SwiftUI

// MARK: - FlowMosaicGridLayoutCache

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct FlowMosaicGridLayoutCache {
    let proposal: ProposedViewSize
    let spacing: MosaicGridSpacing
    let calculatedSize: CGSize
    let items: [FlowMosaicLayoutItem]
    
    @inlinable static var empty: FlowMosaicGridLayoutCache {
        FlowMosaicGridLayoutCache(
            proposal: .zero, spacing: .zero, calculatedSize: .zero, items: []
        )
    }
    
    @inlinable func mightStillValid(with proposal: ProposedViewSize, spacing: MosaicGridSpacing) -> Bool {
        proposal == self.proposal && spacing == self.spacing
    }
}

// MARK: - FlowMosaicGridLayout

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct FlowMosaicGridLayout: Layout {
    
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let alignment: FlowMosaicAlignment
    
    @inlinable func makeCache(subviews: Subviews) -> FlowMosaicGridLayoutCache {
        .empty
    }
    
    @inlinable func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowMosaicGridLayoutCache) -> CGSize {
        let expandableViewSize = proposal.expandableViewSize(for: orientation)
        guard expandableViewSize.width > 0, expandableViewSize.height > 0 else {
            log(.info, "Calculated size is invalid. Width is \(expandableViewSize.width) and height is \(expandableViewSize.height). Will use zero instead.")
            return .zero
        }
        let sizeWithExtraSpace = expandableViewSize.withSpacing(spacing)
        
        var cacheItems: [FlowMosaicLayoutItem] = cache.mightStillValid(with: proposal, spacing: spacing) ? cache.items : []
        
        let newSubviews = invalidateInvalidCache(for: subviews, cache: &cacheItems)
        
        let calculatedSize = calculateSizeAndPlacement(
            for: newSubviews, proposal: proposal,
            viewSize: sizeWithExtraSpace,
            cache: &cacheItems
        )
        
        cache = FlowMosaicGridLayoutCache(
            proposal: proposal,
            spacing: spacing,
            calculatedSize: calculatedSize,
            items: cacheItems
        )
        
        let size = CGSize(
            width: orientation == .vertical ? (expandableViewSize.width) : (proposal.width ?? calculatedSize.width),
            height: orientation == .vertical ? (proposal.height ?? calculatedSize.height) : (expandableViewSize.height)
        )
        return size
    }
    
    @inlinable func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowMosaicGridLayoutCache) {
        let adjustedX: CGFloat = switch orientation {
        case .horizontal: max(.zero, (bounds.width - cache.calculatedSize.width) / 2)
        case .vertical:
            switch alignment {
            case .leading: .zero
            case .center: max(.zero, (bounds.width - cache.calculatedSize.width) / 2)
            case .trailing: max(.zero, bounds.width - cache.calculatedSize.width)
            }
        }
        let adjustedY: CGFloat = switch orientation {
        case .horizontal:
            switch alignment {
            case .leading: .zero
            case .center: max(.zero, (bounds.height - cache.calculatedSize.height) / 2)
            case .trailing: max(.zero, bounds.height - cache.calculatedSize.height)
            }
        case .vertical: max(.zero, (bounds.height - cache.calculatedSize.height) / 2)
        }
        cache.items.forEach { element in
            let realOrigin = CGPoint(
                x: bounds.minX + element.origin.x + adjustedX,
                y: bounds.minY + element.origin.y + adjustedY
            )
            element.view.place(at: realOrigin, proposal: ProposedViewSize(element.size))
        }
    }
    
    // MARK: Private Methods
    
    private func invalidateInvalidCache(for subviews: Subviews, cache: inout [FlowMosaicLayoutItem]) -> [LayoutSubview] {
        guard !cache.isEmpty else { return Array(subviews) }
        var subviews = Array(subviews)
        let endIndex = min(cache.endIndex, subviews.endIndex)
        var lastIndex: Int = -1
        for (index, subview) in subviews.enumerated() where index < endIndex {
            guard let element = cache[safe: index], element.view == subview else {
                break
            }
            lastIndex = index
        }
        guard lastIndex >= 0 else { return subviews }
        let subviewRemoveCount = subviews.count - lastIndex - 1
        let cacheRemoveCount = cache.count - lastIndex - 1
        if subviewRemoveCount > 0 {
            subviews.removeFirst(subviewRemoveCount)
        }
        if cacheRemoveCount > 0 {
            cache.removeLast(cacheRemoveCount)
        }
        return subviews
    }
    
    private func calculateSizeAndPlacement(
        for newSubviews: [LayoutSubview],
        proposal: ProposedViewSize,
        viewSize: CGSize,
        cache: inout [FlowMosaicLayoutItem]) -> CGSize {
            
            var coordinateCalculator = FlowCoordinateCalculator(
                orientation: orientation,
                cache: cache,
                viewSize: viewSize,
                spacing: spacing
            )
            
            for subview in newSubviews {
                let sizeThatFits = subview.sizeThatFits(proposal)
                let subviewSize = sizeThatFits.withSpacing(spacing)
                let available = coordinateCalculator.potentialCoordinate(for: subviewSize)
                var placed: Bool = false
                for placement in available {
                    let subviewRect = CGRect(origin: placement, size: subviewSize)
                    guard coordinateCalculator.isAvailable(subviewRect, inView: viewSize) else {
                        continue
                    }
                    coordinateCalculator.add(subviewRect, inView: viewSize)
                    cache.append(FlowMosaicLayoutItem(view: subview, size: sizeThatFits, origin: placement))
                    placed = true
                    break
                }
                if !placed {
                    let fallbackPlacement = coordinateCalculator.fallBackCoordinate
                    let subviewRect = CGRect(origin: fallbackPlacement, size: subviewSize)
                    log(.info, "Failed to place subview with size (\(sizeThatFits.height),\(sizeThatFits.width)), will put at fallback position at (\(fallbackPlacement.x),\(fallbackPlacement.y))")
                    coordinateCalculator.add(subviewRect, inView: viewSize)
                    cache.append(FlowMosaicLayoutItem(view: subview, size: sizeThatFits, origin: fallbackPlacement))
                }
            }
            
            return coordinateCalculator.calculatedSize
        }
}

// MARK: Private Extensions

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private extension ProposedViewSize {
    func expandableViewSize(for orientation: GridOrientation) -> CGSize {
        CGSize(
            width: orientation == .vertical ? (width ?? .zero) : .infinity,
            height: orientation == .vertical ? .infinity : (height ?? .zero)
        )
    }
}
