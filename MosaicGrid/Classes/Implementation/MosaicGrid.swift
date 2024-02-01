//
//  MosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import SwiftUI

struct MosaicGrid<Content>: View where Content: View {
    let orientation: Axis.Set
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing
    private let content: () -> Content
    
    init(
        orientation: Axis.Set,
        spacing: MosaicGridSpacing,
        gridSizing: MosaicGridSizing,
        @ViewBuilder content: @escaping () -> Content) {
            self.orientation = orientation
            self.spacing = spacing
            self.gridSizing = gridSizing
            self.content = content
        }
    
    var body: some View {
        switch gridSizing {
        case .aspectRatio(let ratio, let crossGridCount):
            mosaicRatioGridLayout(aspectRatio: ratio, crossGridCount: crossGridCount)
        case .constantAxis(let dimension, let crossGridCount):
            mosaicAxisDimensionGridLayout(axisDimension: dimension, crossGridCount: crossGridCount)
        case .constantSize(let size):
            mosaicSizedGridLayout(tileSize: size, minimumSpacing: spacing)
        }
    }
    
    func mosaicRatioGridLayout(aspectRatio: Double, crossGridCount: Int) -> some View {
        MosaicRatioGridLayout(
            orientation: orientation,
            crossGridCount: crossGridCount,
            aspectRatio: aspectRatio,
            spacing: spacing
        ) {
            content()
        }
    }
    
    func mosaicAxisDimensionGridLayout(axisDimension: CGFloat, crossGridCount: Int) -> some View {
        MosaicAxisDimensionGridLayout(
            orientation: orientation,
            crossGridCount: crossGridCount,
            gridAxisDimension: axisDimension,
            spacing: spacing
        ) {
            content()
        }
    }
    
    func mosaicSizedGridLayout(tileSize: CGSize, minimumSpacing: MosaicGridSpacing) -> some View {
        MosaicSizedGridLayout(
            orientation: orientation,
            tileSize: tileSize,
            minimumSpacing: minimumSpacing
        ) {
            content()
        }
    }
}

// MARK: Preview

struct MosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical) {
            MosaicGrid(orientation: .vertical, spacing: 20, gridSizing: .constantSize(CGSize(width: 50, height: 50))) {
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
