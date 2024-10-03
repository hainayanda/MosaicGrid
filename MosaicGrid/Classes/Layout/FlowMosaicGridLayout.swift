//
//  FlowMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 1/10/24.
//

import Foundation
import SwiftUI

// MARK: FlowMosaicGridLayoutCache

struct FlowMosaicGridLayoutCache {
    let proposal: ProposedViewSize
    let spacing: MosaicGridSpacing
    let calculatedSize: CGSize
    let items: [FlowMosaicLayoutItem]
    
    static var empty: FlowMosaicGridLayoutCache {
        FlowMosaicGridLayoutCache(
            proposal: .zero, spacing: .zero, calculatedSize: .zero, items: []
        )
    }
    
    func mightStillValid(with proposal: ProposedViewSize, spacing: MosaicGridSpacing) -> Bool {
        proposal == self.proposal && spacing == self.spacing
    }
}

// MARK: FlowMosaicGridLayout

struct FlowMosaicGridLayout: Layout {
    
    let orientation: Axis.Set
    let spacing: MosaicGridSpacing
    
    func makeCache(subviews: Subviews) -> FlowMosaicGridLayoutCache {
        .empty
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowMosaicGridLayoutCache) -> CGSize {
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
        
        return CGSize(
            width: orientation == .vertical ? (expandableViewSize.width) : calculatedSize.width,
            height: orientation == .vertical ? calculatedSize.height : (expandableViewSize.height)
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout FlowMosaicGridLayoutCache) {
        let adjustedX = (bounds.width - cache.calculatedSize.width) / 2
        let adjustedY = (bounds.height - cache.calculatedSize.height) / 2
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
        for newSubviews: [LayoutSubview], proposal: ProposedViewSize,
        viewSize: CGSize, cache: inout [FlowMosaicLayoutItem]) -> CGSize {
        
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
            for placement in available {
                let subviewRect = CGRect(origin: placement, size: subviewSize)
                guard coordinateCalculator.isAvailable(subviewRect, inView: viewSize) else {
                    continue
                }
                coordinateCalculator.add(subviewRect, inView: viewSize)
                cache.append(FlowMosaicLayoutItem(view: subview, size: sizeThatFits, origin: placement))
                break
            }
        }
        
        return coordinateCalculator.calculatedSize
    }
}

// MARK: FlowCoordinateCalculator

private struct FlowCoordinateCalculator {
    private var potentialX: SortedSet<CGFloat>
    private var potentialY: SortedSet<CGFloat>
    private var xTaken: [CGFloat: [CGRect]] = [:]
    private var yTaken: [CGFloat: [CGRect]] = [:]
    private var takens: [CGRect] = []
    
    let orientation: Axis.Set
    
    var calculatedSize: CGSize {
        CGSize(width: calculatedWidth, height: calculatedHeight)
    }
    
    var calculatedWidth: CGFloat {
        takens.width
    }
    
    var calculatedHeight: CGFloat {
        takens.height
    }
    
    init(orientation: Axis.Set) {
        self.orientation = orientation
        self.potentialX = SortedSet(
            orientation == .vertical ? .descending : .ascending,
            .zero
        )
        self.potentialY = SortedSet(
            orientation == .vertical ? .ascending : .descending,
            .zero
        )
    }
    
    init (orientation: Axis.Set, cache: [FlowMosaicLayoutItem], viewSize: CGSize, spacing: MosaicGridSpacing) {
        self.init(orientation: orientation)
        cache.forEach { element in
            add(
                CGRect(
                    origin: element.origin,
                    size: element.size.withSpacing(spacing)
                ),
                inView: viewSize
            )
        }
    }
    
    func potentialCoordinate(for size: CGSize) -> [CGPoint] {
        switch orientation {
        case .vertical:
            return potentialY.flatMap { y in
                potentialX.compactMap { x in
                    coordinateFilter(x: x, y: y, viewSize: size)
                }
            }
        default:
            return potentialX.flatMap { x in
                potentialY.compactMap { y in
                    coordinateFilter(x: x, y: y, viewSize: size)
                }
            }
        }
    }
    
    mutating func add(_ rect: CGRect, inView size: CGSize) {
        takens.append(rect)
        var rectInY = yTaken[rect.maxY] ?? []
        var rectInX = xTaken[rect.maxX] ?? []
        rectInY.append(rect)
        rectInX.append(rect)
        yTaken[rect.maxY] = rectInY
        xTaken[rect.maxX] = rectInX
        if size.width > rect.maxX {
            potentialX.insert(rect.maxX)
        } else {
            potentialY.remove(rect.minY)
        }
        if size.height > rect.maxY {
            potentialY.insert(rect.maxY)
        } else {
            potentialX.remove(rect.minX)
        }
    }
    
    func isAvailable(_ rect: CGRect, inView size: CGSize) -> Bool {
        switch orientation {
        case .vertical:
            if rect.maxX > size.width { return false }
        default:
            if rect.maxY > size.height { return false }
        }
        return !takens.intersect(with: rect)
    }
    
    private func hasRectToTheLeftAndAbove(for rect: CGRect) -> Bool {
        guard let leftRects = xTaken[rect.minX],
              let aboveRects = yTaken[rect.minY] else { return false }
        let hasLeft = leftRects.contains { leftRect in
            leftRect.maxY > rect.minY && rect.maxY > leftRect.minY
        }
        guard hasLeft else { return false }
        return aboveRects.contains { aboveRect in
            aboveRect.maxX > rect.minX && rect.maxX > aboveRect.minX
        }
    }
    
    private func coordinateFilter(x: CGFloat, y: CGFloat, viewSize: CGSize) -> CGPoint? {
        let point = CGPoint(x: x, y: y)
        let rect = CGRect(origin: point, size: viewSize)
        if x == .zero || y == .zero, !takens.contains(point: point) {
            return point
        } else if hasRectToTheLeftAndAbove(for: rect) {
            return point
        }
        return nil
    }
}

// MARK: Private Extensions

private extension ProposedViewSize {
    func expandableViewSize(for orientation: Axis.Set) -> CGSize {
        CGSize(
            width: orientation == .vertical ? (width ?? .zero) : .infinity,
            height: orientation == .vertical ? .infinity : (height ?? .zero)
        )
    }
}

private extension Sequence where Element == CGRect {
    func contains(point: CGPoint) -> Bool {
        for rect in self {
            if rect.minX < point.x, rect.maxX > point.x, rect.minY < point.y, rect.maxY > point.y {
                return true
            }
        }
        return false
    }
    
    func intersect(with rectangle: CGRect) -> Bool {
        for rect in self where rect.intersects(rectangle) {
            return true
        }
        return false
    }
    
    var height: CGFloat {
        reduce(.zero) { partialResult, element in
            Swift.max(partialResult, element.maxY)
        }
    }
    
    var width: CGFloat {
        reduce(.zero) { partialResult, element in
            Swift.max(partialResult, element.maxX)
        }
    }
}

private extension CGSize {
    func withSpacing(_ spacing: MosaicGridSpacing) -> CGSize {
        return CGSize(width: width + spacing.horizontal, height: height + spacing.vertical)
    }
}
