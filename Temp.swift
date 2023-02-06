//
//  Temp.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation
//import SwiftUI
//
//// MARK:  MosaicGridLayout
//
//protocol MosaicGridLayout: Layout {
//    var hSpacing: CGFloat { get }
//    var vSpacing: CGFloat { get }
//    var maxAxisCount: Int { get }
//    var axis: Axis.Set { get }
//
//    func gridSize(basedOn proposal: ProposedViewSize) -> CGSize
//}
//
//// MARK:  MosaicGridLayout + Extensions
//
//extension MosaicGridLayout where Cache == [MappedMosaicGridLayoutItem] {
//
//    var axisSpacing: CGFloat {
//        switch axis {
//        case .horizontal:
//            return vSpacing
//        default:
//            return hSpacing
//        }
//    }
//
//    var crossAxis: Axis.Set {
//        switch axis {
//        case .horizontal:
//            return .vertical
//        default:
//            return .horizontal
//        }
//    }
//
//    var crossAxisSpacing: CGFloat {
//        switch crossAxis {
//        case .horizontal:
//            return hSpacing
//        default:
//            return vSpacing
//        }
//    }
//
//    func makeCache(subviews: Subviews) -> [MappedMosaicGridLayoutItem] { [] }
//
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) {
//        let gridSize = gridSize(basedOn: proposal)
//        guard gridSize.width > .zero, gridSize.height > .zero else { return }
//        let origin = bounds.origin
//        cache.forEach { item in
//            let hGridCount = CGFloat(item.item.hGridCount)
//            let vGridCount = CGFloat(item .item.vGridCount)
//            let width = (gridSize.width * hGridCount) + (hSpacing * (hGridCount - 1))
//            let height = (gridSize.height * vGridCount) + (vSpacing * (vGridCount - 1))
//
//            let idealSize = CGSize(width: width, height: height)
//
//            let innerX = CGFloat(item.x) * (gridSize.width + hSpacing)
//            let innerY = CGFloat(item.y) * (gridSize.height + vSpacing)
//
//            let idealOrigin = CGPoint(x: origin.x + innerX, y: origin.y + innerY)
//
//            let realSize = item.item.view.sizeThatFits(ProposedViewSize(idealSize))
//            let widthDifference = idealSize.width - realSize.width
//            let heightDifference = idealSize.height - realSize.height
//
//            let realOrigin = CGPoint(x: idealOrigin.x + (widthDifference / 2), y: idealOrigin.y + (heightDifference / 2))
//
//            item.item.view.place(at: realOrigin, proposal: ProposedViewSize(realSize))
//        }
//    }
//
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout [MappedMosaicGridLayoutItem]) -> CGSize {
//        let gridSize = gridSize(basedOn: proposal)
//        guard gridSize.width > .zero, gridSize.height > .zero else { return .zero }
//        let items = subviews.map { subview in
//            MosaicGridLayoutItem(
//                view: subview,
//                proposal: proposal,
//                gridSize: gridSize,
//                hSpacing: hSpacing,
//                vSpacing: vSpacing
//            ).maxed(crossAxis, at: maxAxisCount)
//        }
//        let mappedItems = mapItems(items)
//        cache = mappedItems.mapped
//        let width: CGFloat = (gridSize.width * CGFloat(mappedItems.numberOfColumn)) + (hSpacing * CGFloat(mappedItems.numberOfColumn - 1))
//        let height: CGFloat = (gridSize.height * CGFloat(mappedItems.numberOfRow)) + (vSpacing * CGFloat(mappedItems.numberOfRow - 1))
//        return CGSize(width: width, height: height)
//    }
//
//    func gridSize(basedOn proposal: ProposedViewSize) -> CGSize {
//        guard let proposedDimension = proposal.dimension(of: axis) else { return .zero }
//        let usedDimension = proposedDimension - (crossAxisSpacing * CGFloat(maxAxisCount - 1))
//        let singleGridDimension = usedDimension / CGFloat(maxAxisCount)
//        return CGSize(width: singleGridDimension, height: singleGridDimension)
//    }
//
//    private func nextCoordinate(for item: MosaicGridLayoutItem, lastCoordinate: MosaicGridCoordinate) -> MosaicGridCoordinate {
//        let lastCrossAxis = lastCoordinate.value(of: self.crossAxis)
//        let lastAxis = lastCoordinate.value(of:  self.axis)
//        let gridCount = item.gridCount(for:  self.crossAxis)
//        guard gridCount <= maxAxisCount else { fatalError("count should be less or equal to gridCount") }
//
//        let shouldShift = lastCrossAxis + 1 + gridCount >= maxAxisCount
//
//        let crossAxis = shouldShift ? 0: lastCrossAxis + 1
//        let axis = shouldShift ? lastAxis + 1: lastAxis
//
//        if crossAxis + gridCount > maxAxisCount {
//            switch self.axis {
//            case .vertical:
//                return MosaicGridCoordinate(x: 0, y: axis + 1)
//            default:
//                return MosaicGridCoordinate(x: axis + 1, y: 0)
//            }
//        }
//        switch self.axis {
//        case .vertical:
//            return MosaicGridCoordinate(x: max(crossAxis, 0), y: max(axis, 0))
//        default:
//            return MosaicGridCoordinate(x: max(axis, 0), y: max(crossAxis, 0))
//        }
//    }
//
//    private func mapItems(_ items: [MosaicGridLayoutItem]) -> (mapped: [MappedMosaicGridLayoutItem], numberOfRow: Int, numberOfColumn: Int) {
//        let modelMatrix = VMutableLogicalMatrix(width: maxAxisCount)
//        var currentCoordinate = MosaicGridCoordinate(x: -1, y: -1)
//
//        let mapped: [MappedMosaicGridLayoutItem] = items.map { item in
//            while true {
//                let coordinate = nextCoordinate(for: item, lastCoordinate: currentCoordinate)
//                currentCoordinate = coordinate
//                let toFills = coordinateToFill(for: item, coordinate: coordinate)
//
//                var isSafe = true
//                for coordinate in toFills {
//                    guard let isFilled = modelMatrix[coordinate.x, coordinate.y] else {
//                        break
//                    }
//                    guard !isFilled else {
//                        isSafe = false
//                        break
//                    }
//                }
//                guard isSafe else { continue }
//
//                toFills.forEach { coordinate in
//                    modelMatrix[coordinate.x, coordinate.y] = true
//                }
//                return MappedMosaicGridLayoutItem(x: coordinate.x, y: coordinate.y, item: item)
//            }
//        }
//        return (mapped, modelMatrix.height, modelMatrix.width)
//    }
//
//    private func coordinateToFill(for item: MosaicGridLayoutItem, coordinate: MosaicGridCoordinate) -> [MosaicGridCoordinate] {
//        let crossAxis = coordinate.value(of: self.crossAxis)
//        let axis = coordinate.value(of: self.axis)
//        return (axis ..< axis + item.count(of: self.axis)).reduce([]) { partialResult, currentAxis in
//            var mutableResult = partialResult
//            let rows: [MosaicGridCoordinate] = (crossAxis ..< crossAxis + item.count(of: self.crossAxis)).reduce([]) { partialRow, currentCrossAxis in
//                var mutableRow = partialRow
//                let coordinate: MosaicGridCoordinate
//                switch self.axis {
//                case .vertical:
//                    coordinate = MosaicGridCoordinate(x: currentCrossAxis, y: currentAxis)
//                default:
//                    coordinate = MosaicGridCoordinate(x: currentAxis, y: currentCrossAxis)
//                }
//                mutableRow.append(coordinate)
//                return mutableRow
//            }
//            mutableResult.append(contentsOf: rows)
//            return mutableResult
//        }
//    }
//}
//
//// MARK: Private Extensions
//
//private extension ProposedViewSize {
//    func dimension(of axis: Axis.Set) -> CGFloat? {
//        switch axis {
//        case .vertical:
//            return height
//        default:
//            return width
//        }
//    }
//}
//
//private extension MosaicGridLayoutItem {
//    func gridCount(for axis: Axis.Set) -> Int {
//        switch axis {
//        case .vertical:
//            return vGridCount
//        default:
//            return hGridCount
//        }
//    }
//}
//
//// MARK: Private Model
//
//struct MosaicGridCoordinate {
//    let x: Int
//    let y: Int
//
//    func value(of axis: Axis.Set) -> Int {
//        switch axis {
//        case .vertical:
//            return y
//        default:
//            return x
//        }
//    }
//}
//
//// MARK:  MosaicGridLayout Implementation
//
//struct VMosaicGridLayout: MosaicGridLayout {
//
//    typealias Cache = [MappedMosaicGridLayoutItem]
//
//    let hSpacing: CGFloat
//    let vSpacing: CGFloat
//    var maxAxisCount: Int
//    var axis: Axis.Set { .vertical }
//
//    init(gridHCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
//        self.maxAxisCount = gridHCount
//        self.hSpacing = hSpacing
//        self.vSpacing = vSpacing
//    }
//}
//
//struct HMosaicGridLayout: MosaicGridLayout {
//
//    typealias Cache = [MappedMosaicGridLayoutItem]
//
//    let hSpacing: CGFloat
//    let vSpacing: CGFloat
//    var maxAxisCount: Int
//    var axis: Axis.Set { .horizontal }
//
//    init(gridVCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
//        self.maxAxisCount = gridVCount
//        self.hSpacing = hSpacing
//        self.vSpacing = vSpacing
//    }
//}
