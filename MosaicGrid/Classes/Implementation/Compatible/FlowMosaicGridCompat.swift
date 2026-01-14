//
//  FlowMosaicGridCompat.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct FlowMosaicGridCompatWrapper: View {
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
