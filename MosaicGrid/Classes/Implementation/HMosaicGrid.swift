//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

/// Horizontal Mosaic Grid View.
public struct HMosaicGrid<Content>: View where Content: View {
    
    private let underlyingMosaicGrid: MosaicGrid<Content>
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(spacing: MosaicGridSpacing, alignment: FlowMosaicAlignment, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .flow(alignment),
            content: content
        )
    }

    /// Initialize Horizontal Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Spacing on each item.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(spacing: MosaicGridSpacing, alignment: FlowMosaicAlignment, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .flow(alignment),
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the width of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of the vertical grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(vGridCount: Int, spacing: MosaicGridSpacing, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: vGridCount),
            content: content
        )
    }

    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the width of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of the vertical grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        vGridCount: Int,
        spacing: MosaicGridSpacing,
        gridAspectRatio: Double = 1,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .horizontal,
                spacing: spacing,
                gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: vGridCount),
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridWidth` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of the vertical grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridWidth: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(vGridCount: Int, spacing: MosaicGridSpacing, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .constantAxis(gridWidth, crossGridCount: vGridCount),
            content: content
        )
    }

    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridWidth` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of the vertical grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridWidth: Width of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        vGridCount: Int,
        spacing: MosaicGridSpacing,
        gridWidth: CGFloat,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .horizontal,
                spacing: spacing,
                gridSizing: .constantAxis(gridWidth, crossGridCount: vGridCount),
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: minimumSpacing,
            gridSizing: .constantSize(gridSize),
            content: content
        )
    }

    /// Initialize Horizontal Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Minimum spacing on each grid.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        gridSize: CGSize,
        minimumSpacing: MosaicGridSpacing = .zero,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .horizontal,
                spacing: minimumSpacing,
                gridSizing: .constantSize(gridSize),
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    public var body: some View {
        underlyingMosaicGrid
    }
}

// MARK: Preview
#if DEBUG
#Preview(".flow") {
    ScrollView(.horizontal) {
        HMosaicGrid(spacing: 10) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 200, height: 200)
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width: 200, height: 100)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 300)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 100, height: 100)
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 90, height: 410)
            }
        }
        .padding()
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".flow compat") {
    ScrollView(.horizontal) {
        HMosaicGrid(spacing: 10, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 200, height: 200)
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width: 200, height: 100)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 300)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 100, height: 100)
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 90, height: 410)
            }
        }
        .padding()
    }
}
#Preview(".aspectRatio") {
    ScrollView(.horizontal) {
        HMosaicGrid(vGridCount: 6, spacing: 10) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".aspectRatio compat") {
    ScrollView(.horizontal) {
        HMosaicGrid(vGridCount: 6, spacing: 10, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
#Preview(".constantSize") {
    ScrollView(.horizontal) {
        HMosaicGrid(gridSize: CGSize(width: 120, height: 120), minimumSpacing: 10) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".constantSize compat") {
    ScrollView(.horizontal) {
        HMosaicGrid(gridSize: CGSize(width: 120, height: 120), minimumSpacing: 10, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
#Preview(".constantAxis") {
    ScrollView(.horizontal) {
        HMosaicGrid(vGridCount: 6, spacing: 10, gridWidth: 120) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".constantAxis compat") {
    ScrollView(.horizontal) {
        HMosaicGrid(vGridCount: 6, spacing: 10, gridWidth: 120, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 1, v: 2)
            }
        }
    }
}
#endif
