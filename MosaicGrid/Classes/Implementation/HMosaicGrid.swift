//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

public struct HMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    public init(vGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            hSpacing: hSpacing,
            vSpacing: vSpacing,
            crossGridCount: vGridCount,
            gridSizing: .aspectRatio(gridAspectRatio),
            content: content
        )
    }
    
    public init(vGridCount: Int, spacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            hSpacing: spacing,
            vSpacing: spacing,
            crossGridCount: vGridCount,
            gridSizing: .aspectRatio(gridAspectRatio),
            content: content
        )
    }
    
    public init(vGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            hSpacing: hSpacing,
            vSpacing: vSpacing,
            crossGridCount: vGridCount,
            gridSizing: .constantAxis(gridWidth),
            content: content
        )
    }
    
    public init(vGridCount: Int, spacing: CGFloat = .zero, gridWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .horizontal,
            hSpacing: spacing,
            vSpacing: spacing,
            crossGridCount: vGridCount,
            gridSizing: .constantAxis(gridWidth),
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
