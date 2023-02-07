//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

/// <#Description#>
public struct VMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    /// <#Description#>
    /// - Parameters:
    ///   - hGridCount: <#hGridCount description#>
    ///   - spacing: <#spacing description#>
    ///   - gridAspectRatio: <#gridAspectRatio description#>
    ///   - content: <#content description#>
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: hGridCount),
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - hGridCount: <#hGridCount description#>
    ///   - spacings: <#spacings description#>
    ///   - gridAspectRatio: <#gridAspectRatio description#>
    ///   - content: <#content description#>
    public init(hGridCount: Int, spacings: CGFloat, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: .init(spacings: spacings),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - hGridCount: <#hGridCount description#>
    ///   - spacing: <#spacing description#>
    ///   - gridWidth: <#gridWidth description#>
    ///   - content: <#content description#>
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .constantAxis(gridWidth, crossGridCount: hGridCount),
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - hGridCount: <#hGridCount description#>
    ///   - spacings: <#spacings description#>
    ///   - gridWidth: <#gridWidth description#>
    ///   - content: <#content description#>
    public init(hGridCount: Int, spacings: CGFloat, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: .init(spacings: spacings),
            gridWidth: gridWidth,
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - gridSize: <#tileSize description#>
    ///   - minimumSpacing: <#minimumSpacing description#>
    ///   - content: <#content description#>
    public init(gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: minimumSpacing,
            gridSizing: .constantSize(gridSize),
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - gridSize: <#gridSize description#>
    ///   - minimumSpacings: <#minimumSpacings description#>
    ///   - content: <#content description#>
    public init(gridSize: CGSize, minimumSpacings: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: .init(spacings: minimumSpacings),
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
            .padding()
        }
    }
}
