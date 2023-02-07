//
//  MosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import SwiftUI

struct MosaicGrid<Content>: View where Content: View {
    let orientation: Axis.Set
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let crossGridCount: Int
    let gridSizing: MosaicGridSizing
    let content: () -> Content
    
    init(
        orientation: Axis.Set,
        hSpacing: CGFloat,
        vSpacing: CGFloat,
        crossGridCount: Int,
        gridSizing: MosaicGridSizing,
        @ViewBuilder content: @escaping () -> Content) {
            self.orientation = orientation
            self.hSpacing = hSpacing
            self.vSpacing = vSpacing
            self.crossGridCount = crossGridCount
            self.gridSizing = gridSizing
            self.content = content
        }
    
    init(
        orientation: Axis.Set,
        spacing: CGFloat,
        crossGridCount: Int,
        gridSizing: MosaicGridSizing,
        @ViewBuilder content: @escaping () -> Content) {
            self.orientation = orientation
            self.hSpacing = spacing
            self.vSpacing = spacing
            self.crossGridCount = crossGridCount
            self.gridSizing = gridSizing
            self.content = content
        }
    
    var body: some View {
        switch gridSizing {
        case .aspectRatio(let ratio):
            mosaicRatioGridLayout(aspectRatio: ratio)
        case .constantAxis(let dimension):
            mosaicConstantGridLayout(axisDimension: dimension)
        }
    }
    
    func mosaicRatioGridLayout(aspectRatio: Double) -> some View {
        MosaicRatioGridLayout(
            orientation: orientation,
            crossGridCount: crossGridCount,
            aspectRatio: aspectRatio,
            hSpacing: hSpacing,
            vSpacing: vSpacing
        ) {
            content()
        }
    }
    
    func mosaicConstantGridLayout(axisDimension: CGFloat) -> some View {
        MosaicConstantGridLayout(
            orientation: orientation,
            crossGridCount: crossGridCount,
            gridAxisDimension: axisDimension,
            hSpacing: hSpacing,
            vSpacing: vSpacing
        ) {
            content()
        }
    }
}

struct MosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical) {
            MosaicGrid(orientation: .vertical, spacing: 10, crossGridCount: 3, gridSizing: .default) {
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
