//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

public struct VMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .aspectRatio(gridAspectRatio, crossGridCount: hGridCount),
            content: content
        )
    }
    
    public init(hGridCount: Int, spacing: MosaicGridSpacing = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            gridSizing: .constantAxis(gridHeight, crossGridCount: hGridCount),
            content: content
        )
    }
    
    public init(tileSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: minimumSpacing,
            gridSizing: .constantSize(tileSize),
            content: content
        )
    }
    
    public var body: some View {
        mosaicGrid
    }
}

struct VMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VMosaicGrid(hGridCount: 3, spacing: 10) {
                Rectangle()
                    .foregroundColor(.red)
                    .mosaicTiles(w: 2, h: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.yellow)
                    .mosaicTiles(h: 2)
                Rectangle()
                    .foregroundColor(.green)
                    .mosaicTiles(w: 2)
                Rectangle()
                    .foregroundColor(.cyan)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.blue)
                    .mosaicTiles(w: 2)
                Rectangle()
                    .foregroundColor(.purple)
                    .mosaicTiles(w: 2, h: 3)
                Rectangle()
                    .foregroundColor(.pink)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.red)
                    .mosaicTiles()
                Rectangle()
                    .foregroundColor(.orange)
                    .mosaicTiles()
            }
            .padding()
        }
    }
}
