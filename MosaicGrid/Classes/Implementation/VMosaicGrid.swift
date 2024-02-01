//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

/// Vertical Mosaic Grid View.
public struct VMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each others.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of horizontal grid.
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: hGridCount),
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each others.
    /// `gridHeight` then will be used as height of single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of horizontal grid.
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridHeight: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .constantAxis(gridHeight, crossGridCount: hGridCount),
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as a size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each others.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Minimum spacing on each grid. The default is zero.
    ///   - content: iew that will be used as this Mosaic Grid Content
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: minimumSpacing,
            gridSizing: .constantSize(gridSize),
            content: content
        )
    }
    
    public var body: some View {
        mosaicGrid
    }
}

// MARK: Preview

struct VMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical) {
            VMosaicGrid(hGridCount: 3, spacing: 10) {
                ForEach(0..<10) { _ in
                    Rectangle()
                        .foregroundColor(.red)
                        .tileSized(w: 2, h: 2)
                    Rectangle()
                        .foregroundColor(.orange)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.yellow)
                        .tileSized(h: 2)
                    Rectangle()
                        .foregroundColor(.green)
                        .tileSized(w: 2)
                    Rectangle()
                        .foregroundColor(.cyan)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.blue)
                        .tileSized(w: 2)
                    Rectangle()
                        .foregroundColor(.purple)
                        .tileSized(w: 2, h: 3)
                    Rectangle()
                        .foregroundColor(.pink)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.red)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.orange)
                        .tileSized()
                }
            }
            .padding()
        }
    }
}
