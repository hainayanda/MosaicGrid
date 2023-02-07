//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

public struct VMosaicGrid<Content>: View where Content: View {
    
    let mosaicGrid: MosaicGrid<Content>
    
    public init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            hSpacing: hSpacing,
            vSpacing: vSpacing,
            crossGridCount: hGridCount,
            gridSizing: .aspectRatio(gridAspectRatio),
            content: content
        )
    }
    
    public init(hGridCount: Int, spacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            crossGridCount: hGridCount,
            gridSizing: .aspectRatio(gridAspectRatio),
            content: content
        )
    }
    
    public init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            hSpacing: hSpacing,
            vSpacing: vSpacing,
            crossGridCount: hGridCount,
            gridSizing: .constantAxis(gridHeight),
            content: content
        )
    }
    
    public init(hGridCount: Int, spacing: CGFloat = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.mosaicGrid = MosaicGrid(
            orientation: .vertical,
            spacing: spacing,
            crossGridCount: hGridCount,
            gridSizing: .constantAxis(gridHeight),
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
