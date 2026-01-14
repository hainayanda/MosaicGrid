//
//  FlowCoordinateCalculator.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

import SwiftUI

// MARK: - FlowCoordinateCalculator

struct FlowCoordinateCalculator {
    private var potentialX: SortedSet<CGFloat>
    private var potentialY: SortedSet<CGFloat>
    private var xTaken: [CGFloat: [CGRect]] = [:]
    private var yTaken: [CGFloat: [CGRect]] = [:]
    private var takens: [CGRect] = []
    
    let orientation: GridOrientation
    
    @inlinable var calculatedSize: CGSize {
        CGSize(width: calculatedWidth, height: calculatedHeight)
    }
    
    @inlinable var calculatedWidth: CGFloat {
        takens.width
    }
    
    @inlinable var calculatedHeight: CGFloat {
        takens.height
    }
    
    @inlinable var fallBackCoordinate: CGPoint {
        CGPoint(
            x: orientation == .vertical ? .zero : calculatedWidth,
            y: orientation == .vertical ? calculatedHeight : .zero
        )
    }
    
    @inlinable init(orientation: GridOrientation) {
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
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init (orientation: GridOrientation, cache: [FlowMosaicLayoutItem], viewSize: CGSize, spacing: MosaicGridSpacing) {
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
    
    @inlinable func potentialCoordinate(for size: CGSize) -> [CGPoint] {
        switch orientation {
        case .vertical:
            return potentialY.flatMap { y in
                potentialX.compactMap { x in
                    coordinateFilter(x: x, y: y, viewSize: size)
                }
            }
        case .horizontal:
            return potentialX.flatMap { x in
                potentialY.compactMap { y in
                    coordinateFilter(x: x, y: y, viewSize: size)
                }
            }
        }
    }
    
    @inlinable mutating func add(_ rect: CGRect, inView size: CGSize) {
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
    
    @inlinable func isAvailable(_ rect: CGRect, inView size: CGSize) -> Bool {
        switch orientation {
        case .vertical:
            if rect.maxX > size.width { return false }
        case .horizontal:
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
