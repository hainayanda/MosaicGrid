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
            mosaicSizedGridLayout(gridSize: size, minimumSpacing: spacing)
        case .flow:
            flowGridLayout(minimumSpacing: spacing)
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
    
    func mosaicSizedGridLayout(gridSize: CGSize, minimumSpacing: MosaicGridSpacing) -> some View {
        MosaicSizedGridLayout(
            orientation: orientation,
            gridSize: gridSize,
            minimumSpacing: minimumSpacing
        ) {
            content()
        }
    }
    
    func flowGridLayout(minimumSpacing: MosaicGridSpacing) -> some View {
        FlowMosaicGridLayout(
            orientation: orientation,
            spacing: minimumSpacing
        ) {
            content()
        }
    }
}

// MARK: Preview
#if DEBUG
#Preview {
    ScrollView(.vertical) {
        MosaicGrid(orientation: .vertical, spacing: MosaicGridSpacing(spacings: 18), gridSizing: .constantSize(CGSize(width: 9, height: 9))) {
            ForEach(0..<50) { _ in
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(h: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids(v: 3)
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.cyan)
                    .usingGrids(h: 2, v: 2)
                Rectangle()
                    .foregroundColor(.blue)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.purple)
                    .usingGrids(h: 2, v: 3)
                Rectangle()
                    .foregroundColor(.pink)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.red)
                    .usingGrids(h: 3)
                Rectangle()
                    .foregroundColor(.orange)
                    .usingGrids(v: 2)
                Rectangle()
                    .foregroundColor(.yellow)
                    .usingGrids()
                Rectangle()
                    .foregroundColor(.green)
                    .usingGrids(h: 2)
            }
        }
        .padding()
    }
}
#endif
