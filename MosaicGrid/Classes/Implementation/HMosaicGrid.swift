//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

/// <#Description#>
public struct HMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    /// <#Description#>
    /// - Parameters:
    ///   - vGridCount: <#vGridCount description#>
    ///   - spacing: <#spacing description#>
    ///   - gridAspectRatio: <#gridAspectRatio description#>
    ///   - content: <#content description#>
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: vGridCount),
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - vGridCount: <#vGridCount description#>
    ///   - spacings: <#spacings description#>
    ///   - gridAspectRatio: <#gridAspectRatio description#>
    ///   - content: <#content description#>
    public init(vGridCount: Int, spacings: CGFloat, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            vGridCount: vGridCount,
            spacing: .init(spacings: spacings),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - vGridCount: <#vGridCount description#>
    ///   - spacing: <#spacing description#>
    ///   - gridHeight: <#gridHeight description#>
    ///   - content: <#content description#>
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .constantAxis(gridHeight, crossGridCount: vGridCount),
            content: content
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - vGridCount: <#vGridCount description#>
    ///   - spacings: <#spacings description#>
    ///   - gridHeight: <#gridHeight description#>
    ///   - content: <#content description#>
    public init(vGridCount: Int, spacings: CGFloat, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            vGridCount: vGridCount,
            spacing: .init(spacings: spacings),
            gridHeight: gridHeight,
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
            orientation: .horizontal,
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

struct HMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            HMosaicGrid(vGridCount: 6, spacing: 10) {
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
            .padding()
        }
    }
}
