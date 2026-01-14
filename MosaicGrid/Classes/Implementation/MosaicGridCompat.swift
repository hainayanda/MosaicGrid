//
//  MosaicGridCompat.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridCompat<Content>: View where Content: View {
    
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing
    let content: Content
    
    init(
        orientation: GridOrientation,
        spacing: MosaicGridSpacing,
        gridSizing: MosaicGridSizing,
        content: Content) {
            self.orientation = orientation
            self.spacing = spacing
            self.gridSizing = gridSizing
            self.content = content
        }
    
    var body: some View {
        _VariadicView.Tree(
            MosaicGridCompatRoot(
                orientation: orientation,
                spacing: spacing,
                gridSizing: gridSizing
            )
        ) {
            content
        }
    }
}

struct MosaicGridCompatRoot: _VariadicView_MultiViewRoot {

    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing

    func body(children: _VariadicView.Children) -> some View {
        switch gridSizing {
        case .flow(let alignment):
            FlowMosaicGridCompatWrapper(
                children: children,
                orientation: orientation,
                spacing: spacing,
                alignment: alignment
            )
        default:
            MosaicGridCompatContent(
                children: children,
                orientation: orientation,
                spacing: spacing,
                gridSizing: gridSizing
            )
        }
    }

    // MARK: - Calculation Methods for Testing

    func calculateGridSize(basedOn proposal: CGSize) -> CGSize {
        switch gridSizing {
        case .constantSize(let size):
            return size

        case .constantAxis(let dimension, let crossGridCount):
            return calculateAxisDimensionGridSize(proposal: proposal, dimension: dimension, count: crossGridCount)

        case .aspectRatio(let ratio, let crossGridCount):
            return calculateAspectRatioGridSize(proposal: proposal, ratio: ratio, count: crossGridCount)

        case .flow:
            return .zero
        }
    }

    func calculateAxisDimensionGridSize(proposal: CGSize, dimension: CGFloat, count: Int) -> CGSize {
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard count > 0 else { return .zero }

        let usedDimension = axisDimension - (crossAxisSpacing * CGFloat(count - 1))
        let calculatedGridDimension = usedDimension / CGFloat(count)

        return orientation == .vertical
            ? CGSize(width: calculatedGridDimension, height: dimension)
            : CGSize(width: dimension, height: calculatedGridDimension)
    }

    func calculateAspectRatioGridSize(proposal: CGSize, ratio: Double, count: Int) -> CGSize {
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard count > 0 else { return .zero }

        let usedDimension = axisDimension - (crossAxisSpacing * CGFloat(count - 1))
        let calculatedGridDimension = usedDimension / CGFloat(count)

        switch orientation {
        case .vertical:
            return CGSize(width: calculatedGridDimension, height: calculatedGridDimension / ratio)
        case .horizontal:
            return CGSize(width: calculatedGridDimension * ratio, height: calculatedGridDimension)
        }
    }

    func calculateCrossCount(for proposal: CGSize) -> Int {
        switch gridSizing {
        case .constantAxis(_, let count): return count
        case .aspectRatio(_, let count): return count
        case .constantSize:
            return calculateDynamicCrossCount(proposal: proposal)
        case .flow: return 1
        }
    }

    func calculateDynamicCrossCount(proposal: CGSize) -> Int {
        guard case .constantSize(let size) = gridSizing else { return 1 }

        let gridAxisDimension = size.axisDimension(for: orientation.cross)
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard gridAxisDimension > 0 else { return 1 }

        return max(1, Int((axisDimension + crossAxisSpacing) / (gridAxisDimension + crossAxisSpacing)))
    }
}

// MARK: - MosaicGridCompatContent

private struct MosaicGridCompatContent: View {
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

// MARK: - FlowMosaicGridCompatWrapper

private struct FlowMosaicGridCompatWrapper: View {
    let children: _VariadicView.Children
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let alignment: FlowMosaicAlignment

    @State private var contentSize: CGSize = .zero

    var body: some View {
        GeometryReader { proxy in
            FlowMosaicGridLayoutCompat(
                children: children,
                orientation: orientation,
                spacing: spacing,
                alignment: alignment,
                containerSize: proxy.size,
                onContentSizeChange: { size in
                    contentSize = size
                }
            )
        }
        .frame(
            width: orientation == .horizontal && contentSize.width > 0 ? contentSize.width : nil,
            height: orientation == .vertical && contentSize.height > 0 ? contentSize.height : nil
        )
    }
}

struct FlowMosaicGridLayoutCompat: View {
    let children: _VariadicView.Children
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let alignment: FlowMosaicAlignment
    let containerSize: CGSize
    let onContentSizeChange: (CGSize) -> Void

    @State private var childSizes: [AnyHashable: CGSize] = [:]

    var body: some View {
        let result = computePositions()

        ZStack(alignment: .topLeading) {
            ForEach(children) { child in
                child
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: ChildSizePreferenceKey.self,
                                value: [child.id: geo.size]
                            )
                        }
                    )
                    .alignmentGuide(.leading) { _ in
                        -(result.positions[child.id]?.x ?? 0)
                    }
                    .alignmentGuide(.top) { _ in
                        -(result.positions[child.id]?.y ?? 0)
                    }
            }
        }
        .onPreferenceChange(ChildSizePreferenceKey.self) { sizes in
            childSizes = sizes
        }
        .frame(
            width: orientation == .vertical ? containerSize.width : max(result.contentSize.width, 1),
            height: orientation == .vertical ? max(result.contentSize.height, 1) : containerSize.height,
            alignment: alignment.compatAlignment(for: orientation)
        )
        .onChange(of: result.contentSize) { newSize in
            onContentSizeChange(newSize)
        }
        .onAppear {
            onContentSizeChange(result.contentSize)
        }
    }

    private func computePositions() -> (positions: [AnyHashable: CGPoint], contentSize: CGSize) {
        let viewSize = CGSize(
            width: orientation == .vertical ? containerSize.width : .infinity,
            height: orientation == .vertical ? .infinity : containerSize.height
        ).withSpacing(spacing)

        var coordinator = FlowCoordinateCalculator(orientation: orientation)
        var positions: [AnyHashable: CGPoint] = [:]

        for child in children {
            let sizeThatFits = childSizes[child.id] ?? CGSize(width: 100, height: 100)
            let subviewSize = sizeThatFits.withSpacing(spacing)
            let available = coordinator.potentialCoordinate(for: subviewSize)

            var placed = false
            for placement in available {
                let subviewRect = CGRect(origin: placement, size: subviewSize)
                guard coordinator.isAvailable(subviewRect, inView: viewSize) else {
                    continue
                }
                coordinator.add(subviewRect, inView: viewSize)
                positions[child.id] = placement
                placed = true
                break
            }

            if !placed {
                let fallbackPlacement = coordinator.fallBackCoordinate
                let subviewRect = CGRect(origin: fallbackPlacement, size: subviewSize)
                coordinator.add(subviewRect, inView: viewSize)
                positions[child.id] = fallbackPlacement
            }
        }

        return (positions, coordinator.calculatedSize)
    }
}

private struct ChildSizePreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGSize] = [:]

    static func reduce(value: inout [AnyHashable: CGSize], nextValue: () -> [AnyHashable: CGSize]) {
        value.merge(nextValue()) { _, new in new }
    }
}

extension FlowMosaicGridLayoutCompat {
    static func computeFlowPositions(
        sizes: [CGSize],
        containerSize: CGSize,
        orientation: GridOrientation,
        spacing: MosaicGridSpacing
    ) -> [CGPoint] {
        var xCursor: CGFloat = 0
        var yCursor: CGFloat = 0
        var lineMax: CGFloat = 0
        var positions: [CGPoint] = []
        positions.reserveCapacity(sizes.count)
        
        for size in sizes {
            switch orientation {
            case .vertical:
                if xCursor + size.width > containerSize.width {
                    xCursor = 0
                    yCursor += lineMax + spacing.vertical
                    lineMax = 0
                }
                positions.append(CGPoint(x: xCursor, y: yCursor))
                xCursor += size.width + spacing.horizontal
                lineMax = max(lineMax, size.height)
            case .horizontal:
                if yCursor + size.height > containerSize.height {
                    yCursor = 0
                    xCursor += lineMax + spacing.horizontal
                    lineMax = 0
                }
                positions.append(CGPoint(x: xCursor, y: yCursor))
                yCursor += size.height + spacing.vertical
                lineMax = max(lineMax, size.width)
            }
        }
        
        return positions
    }
}

// Private extensions needed for calculation
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

private extension FlowMosaicAlignment {
    func compatAlignment(for orientation: GridOrientation) -> Alignment {
        switch (orientation, self) {
        case (.vertical, .leading): return .topLeading
        case (.vertical, .center): return .top
        case (.vertical, .trailing): return .topTrailing
        case (.horizontal, .leading): return .topLeading
        case (.horizontal, .center): return .leading
        case (.horizontal, .trailing): return .bottomLeading
        }
    }
}

// MARK: - ContentSizePreferenceKey

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        if next != .zero {
            value = next
        }
    }
}
