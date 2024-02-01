//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

/// Horizontal Mosaic Grid View.
public struct HMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each others.
    /// `gridAspectRatio` then will be used to calculate the width of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of vertical grid.
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: vGridCount),
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will divide the height of the view with `vGridCount` to get the height of single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each others.
    /// `gridWidth` then will be used as height of single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - vGridCount: Count of vertical grid.
    ///   - spacing: Spacing on each grid. The default is zero.
    ///   - gridWidth: Width of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .constantAxis(gridWidth, crossGridCount: vGridCount),
            content: content
        )
    }
    
    /// Initialize Horizontal Mosaic Grid View.
    /// It will use `gridSize` as a size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each others.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Minimum spacing on each grid. The default is zero.
    ///   - content: iew that will be used as this Mosaic Grid Content
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
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

struct HMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            HMosaicGrid(vGridCount: 6, spacing: 10) {
                ForEach(0..<10) { _ in
                    Rectangle()
                        .foregroundColor(.red)
                        .tileSized(w: 2, h: 2)
                    Rectangle()
                        .foregroundColor(.orange)
                        .tileSized(w: 2)
                    Rectangle()
                        .foregroundColor(.yellow)
                        .tileSized(h: 3)
                    Rectangle()
                        .foregroundColor(.green)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.cyan)
                        .tileSized(w: 3, h: 2)
                    Rectangle()
                        .foregroundColor(.blue)
                        .tileSized()
                    Rectangle()
                        .foregroundColor(.purple)
                        .tileSized(w: 2, h: 3)
                    Rectangle()
                        .foregroundColor(.pink)
                        .tileSized(w: 2)
                    Rectangle()
                        .foregroundColor(.red)
                        .tileSized(h: 2)
                    Rectangle()
                        .foregroundColor(.orange)
                        .tileSized(h: 3)
                }
            }
            .padding()
        }
    }
}
