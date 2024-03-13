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
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
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
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridHeight: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
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
    ///   - minimumSpacing: Minimum spacing on each grid. The default is zero.
    ///   - content: the view that will be used as this Mosaic Grid Content
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
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
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid. The default is zero.
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
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid. The default is zero.
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
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Both horizontal and vertical minimum spacing on each grid. The default is zero.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @inlinable init(gridSize: CGSize, minimumSpacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(spacings: minimumSpacing),
            content: content
        )
    }
}

// MARK: Preview
#if DEBUG
struct VMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical) {
            VMosaicGrid(hGridCount: 3, spacing: 10) {
                ForEach(0..<50) { _ in
                    Rectangle()
                        .foregroundColor(.red)
                        .usingGrids(h: 2, v: 2)
                    Rectangle()
                        .foregroundColor(.orange)
                        .usingGrids()
                    Rectangle()
                        .foregroundColor(.yellow)
                        .usingGrids(v: 2)
                    Rectangle()
                        .foregroundColor(.green)
                        .usingGrids(h: 2)
                    Rectangle()
                        .foregroundColor(.cyan)
                        .usingGrids()
                    Rectangle()
                        .foregroundColor(.blue)
                        .usingGrids(h: 2)
                    Rectangle()
                        .foregroundColor(.purple)
                        .usingGrids(h: 2, v: 3)
                    Rectangle()
                        .foregroundColor(.pink)
                        .usingGrids()
                    Rectangle()
                        .foregroundColor(.red)
                        .usingGrids()
                    Rectangle()
                        .foregroundColor(.orange)
                        .usingGrids()
                }
            }
            .padding()
        }
    }
}
#endif
