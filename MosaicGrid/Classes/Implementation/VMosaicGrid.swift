//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

/// Vertical Mosaic Grid View.
public struct VMosaicGrid<Content>: View where Content: View {
    
    private let underlyingMosaicGrid: MosaicGrid<Content>
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(spacing: MosaicGridSpacing, alignment: FlowMosaicAlignment, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .flow(alignment),
            content: content
        )
    }

    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Spacing on each item.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(spacing: MosaicGridSpacing, alignment: FlowMosaicAlignment, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .flow(alignment),
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: hGridCount),
            content: content
        )
    }

    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        hGridCount: Int,
        spacing: MosaicGridSpacing,
        gridAspectRatio: Double = 1,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .vertical,
                spacing: spacing,
                gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: hGridCount),
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridHeight: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .constantAxis(gridHeight, crossGridCount: hGridCount),
            content: content
        )
    }

    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Spacing on each grid.
    ///   - gridHeight: Width of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(
        hGridCount: Int,
        spacing: MosaicGridSpacing,
        gridHeight: CGFloat,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .vertical,
                spacing: spacing,
                gridSizing: .constantAxis(gridHeight, crossGridCount: hGridCount),
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: minimumSpacing,
            gridSizing: .constantSize(gridSize),
            content: content
        )
    }

    /// Initialize Vertical Mosaic Grid View.
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
        minimumSpacing: MosaicGridSpacing,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.underlyingMosaicGrid = MosaicGrid(
                orientation: .vertical,
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

// MARK: - Preview

#if DEBUG
#Preview(".flow") {
    ScrollView(.vertical) {
        VMosaicGrid(spacing: 10, alignment: .center) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 200, height: 200)
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width: 100, height: 100)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 300)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 200, height: 100)
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 100)
            }
        }
        .padding()
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".flow compat") {
    ScrollView(.vertical) {
        VMosaicGrid(spacing: 10, alignment: .center, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 200, height: 200)
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width: 100, height: 100)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 300)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 200, height: 100)
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 100)
            }
        }
        .padding()
    }
}
#Preview(".aspectRatio") {
    ScrollView(.vertical) {
        VMosaicGrid(hGridCount: 6, spacing: 10) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 6)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 4, v: 2)
            }
        }
        .padding()
    }
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".aspectRatio compat") {
    ScrollView(.vertical) {
        VMosaicGrid(hGridCount: 6, spacing: 10, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 6)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 4, v: 2)
            }
        }
        .padding()
    }
}
#Preview(".constantSize") {
    ScrollView(.vertical) {
        VMosaicGrid(gridSize: CGSize(width: 115, height: 115), minimumSpacing: 10) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 2)
            }
        }
    }
    .padding()
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".constantSize compat") {
    ScrollView(.vertical) {
        VMosaicGrid(gridSize: CGSize(width: 115, height: 115), minimumSpacing: 10, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 2)
            }
        }
    }
    .padding()
}
#Preview(".constantAxis") {
    ScrollView(.vertical) {
        VMosaicGrid(hGridCount: 3, spacing: 10, gridHeight: 120) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 2)
            }
        }
    }
    .padding()
}
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".constantAxis compat") {
    ScrollView(.vertical) {
        VMosaicGrid(hGridCount: 3, spacing: 10, gridHeight: 120, useCompatLayout: true) {
            ForEach(0..<10) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids(h: 2)
            }
        }
    }
    .padding()
}
#endif
