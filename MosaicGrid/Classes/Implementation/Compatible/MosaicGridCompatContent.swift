//
//  MosaicGridCompatContent.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridCompatContent: View {
    let children: _VariadicView.Children
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing

    @State private var contentSize: CGSize = .zero

    var body: some View {
        GeometryReader { proxy in
            let proposal = proxy.size
            let root = MosaicGridCompatRoot(orientation: orientation, spacing: spacing, gridSizing: gridSizing)
            let gridSize = root.calculateGridSize(basedOn: proposal)
            let result = calculatePlacementsWithSize(for: children, gridSize: gridSize, proposal: proposal)

            ZStack(alignment: .topLeading) {
                ForEach(children) { child in
                    if let placement = result.placements[child.id] {
                        child
                            .frame(width: placement.width, height: placement.height)
                            .offset(x: placement.minX, y: placement.minY)
                    }
                }
            }
            .preference(key: ContentSizePreferenceKey.self, value: result.contentSize)
        }
        .onPreferenceChange(ContentSizePreferenceKey.self) { size in
            contentSize = size
        }
        .frame(
            width: orientation == .horizontal && contentSize.width > 0 ? contentSize.width : nil,
            height: orientation == .vertical && contentSize.height > 0 ? contentSize.height : nil
        )
    }

    // MARK: Calculation Helpers
    
    func calculatePlacementsWithSize(for children: _VariadicView.Children, gridSize: CGSize, proposal: CGSize) -> (placements: [AnyHashable: CGRect], contentSize: CGSize) {
        guard gridSize.width > 0, gridSize.height > 0 else { return ([:], .zero) }

        // Calculate adjusted spacing to match MosaicSizedGridLayout behavior
        let adjustedSpacing = calculateAdjustedSpacing(for: gridSize, proposal: proposal)

        let unifiedItems: [UnifiedMosaicLayoutItem] = children.map { child in
            let mosaicSize = child[MosaicGridSizeTrait.self]
            let usedGridsSize = mosaicSize.usedGridsSize(for: gridSize, with: adjustedSpacing)

            return UnifiedMosaicLayoutItem(
                sourceId: child.id,
                sizeThatFits: usedGridsSize,
                mosaicSize: mosaicSize,
                spacing: adjustedSpacing,
                gridSize: gridSize
            )
        }

        // Use Grid Engine
        let root = MosaicGridCompatRoot(orientation: orientation, spacing: spacing, gridSizing: gridSizing)
        let engine = MosaicGridEngine(
            orientation: orientation,
            crossOrientationCount: root.calculateCrossCount(for: proposal),
            spacing: adjustedSpacing
        )

        let result = engine.calculateLayout(for: unifiedItems)

        var placements: [AnyHashable: CGRect] = [:]
        let origin = CGPoint.zero

        for mappedItem in result.mapped {
            let idealSize = mappedItem.mosaicSize.usedGridsSize(for: gridSize, with: adjustedSpacing)
            let innerX = CGFloat(mappedItem.minX) * (gridSize.width + adjustedSpacing.horizontal)
            let innerY = CGFloat(mappedItem.minY) * (gridSize.height + adjustedSpacing.vertical)
            let rect = CGRect(origin: CGPoint(x: origin.x + innerX, y: origin.y + innerY), size: idealSize)

            placements[mappedItem.sourceId] = rect
        }

        return (placements, result.size)
    }

    func calculateAdjustedSpacing(for gridSize: CGSize, proposal: CGSize) -> MosaicGridSpacing {
        // Only adjust spacing for constantSize mode to match MosaicSizedGridLayout
        guard case .constantSize = gridSizing else {
            return spacing
        }

        let root = MosaicGridCompatRoot(orientation: orientation, spacing: spacing, gridSizing: gridSizing)
        let crossCount = root.calculateCrossCount(for: proposal)

        // If only one column/row, use minimum spacing
        guard crossCount > 1 else {
            return spacing
        }

        let gridAxisDimension = gridSize.axisDimension(for: orientation.cross)
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let axisSpacing = spacing.axisSpacing(for: orientation)

        // Calculate real spacing to fill container width/height
        let realSpacing = (axisDimension - (gridAxisDimension * CGFloat(crossCount))) / CGFloat(crossCount - 1)

        return orientation == .vertical
        ? MosaicGridSpacing(h: realSpacing, v: axisSpacing)
        : MosaicGridSpacing(h: axisSpacing, v: realSpacing)
    }
}

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        if next != .zero {
            value = next
        }
    }
}

// MARK: - Private Extensions

private extension CGSize {
    func axisDimension(for axis: GridOrientation) -> CGFloat {
        axis == .vertical ? height : width
    }
}

private extension GridOrientation {
    var cross: GridOrientation {
        self == .vertical ? .horizontal : .vertical
    }
}

private extension MosaicGridSpacing {
    func axisSpacing(for axis: GridOrientation) -> CGFloat {
        axis == .vertical ? vertical : horizontal
    }
}
