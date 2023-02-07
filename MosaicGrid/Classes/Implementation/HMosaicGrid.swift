//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

public struct HMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: vGridCount),
            content: content
        )
    }
    
    public init(vGridCount: Int, spacing: MosaicGridSpacing = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: spacing,
            gridSizing: .constantAxis(gridHeight, crossGridCount: vGridCount),
            content: content
        )
    }
    
    public init(tileSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            spacing: minimumSpacing,
            gridSizing: .constantSize(tileSize),
            content: content
        )
    }
    
    public var body: some View {
        mosaicGrid
    }
}

struct HMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            HMosaicGrid(vGridCount: 6, spacing: 10) {
                Rectangle()
                    .foregroundColor(.red)
                    .mosaicTiles(w: 2, h: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .mosaicTiles(w: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .mosaicTiles(h: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.cyan)
                    .mosaicTiles(w: 3, h: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.purple)
                    .mosaicTiles(w: 2, h: 3)
                Rectangle()
                    .foregroundColor(.pink)
                    .mosaicTiles(w: 2)
                Rectangle()
                    .foregroundColor(.red)
                    .mosaicTiles(h: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .mosaicTiles(h: 3)
            }
            .padding()
        }
    }
}
