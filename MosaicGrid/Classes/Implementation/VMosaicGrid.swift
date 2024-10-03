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
    public init(spacing: MosaicGridSpacing, @ViewBuilder content: @escaping () -> Content) {
        self.underlyingMosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .flow,
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
    
    public var body: some View {
        underlyingMosaicGrid
    }
}

public extension VMosaicGrid {
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Both horizontal and vertical spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            spacing: MosaicGridSpacing(h: spacing, v: spacing),
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - hSpacing: Horizontal spacing on each item.
    ///   - vSpacing: Vertical spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the width of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the vertical grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid. 
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the width of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the vertical grid.
    ///   - hSpacing: Horizontal spacing on each grid. 
    ///   - vSpacing: Vertical spacing on each grid. 
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the vertical grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid. 
    ///   - gridHeight: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridHeight: gridHeight,
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the vertical grid.
    ///   - hSpacing: Horizontal spacing on each grid. 
    ///   - vSpacing: Vertical spacing on each grid. 
    ///   - gridHeight: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridHeight: gridHeight,
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Both horizontal and vertical minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @inlinable init(gridSize: CGSize, minimumSpacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(spacings: minimumSpacing),
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumHSpacing: Horizontal minimum spacing on each grid.
    ///   - minimumVSpacing: Vertical minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @inlinable init(gridSize: CGSize, minimumHSpacing: CGFloat = .zero, minimumVSpacing: CGFloat = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(h: minimumHSpacing, v: minimumVSpacing),
            content: content
        )
    }
}

// MARK: Preview
#if DEBUG
#Preview(".flow") {
    ScrollView(.vertical) {
        VMosaicGrid(spacing: 10) {
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
                    .foregroundColor(.cyan)
                    .frame(width: 200, height: 100)
            }
        }
        .padding()
    }
}
#Preview(".aspectRatio") {
    ScrollView(.vertical) {
        VMosaicGrid(hGridCount: 3, spacing: 10) {
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
                    .foregroundColor(.cyan)
                    .usingGrids(h: 2)
            }
        }
    }
}
#Preview(".constantSize") {
    ScrollView(.vertical) {
        VMosaicGrid(gridSize: CGSize(width: 120, height: 120), minimumSpacing: 10) {
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
                    .foregroundColor(.cyan)
                    .usingGrids(h: 2)
            }
        }
    }
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
                    .foregroundColor(.cyan)
                    .usingGrids(h: 2)
            }
        }
    }
}
#endif
