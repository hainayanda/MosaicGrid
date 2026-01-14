//
//  MosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import SwiftUI

struct MosaicGrid<Content>: View where Content: View {
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing
    let useCompatLayout: Bool
    private let content: () -> Content
    
    init(
        orientation: GridOrientation,
        spacing: MosaicGridSpacing,
        gridSizing: MosaicGridSizing,
        @ViewBuilder content: @escaping () -> Content) {
            self.orientation = orientation
            self.spacing = spacing
            self.gridSizing = gridSizing
            self.useCompatLayout = false
            self.content = content
        }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    init(
        orientation: GridOrientation,
        spacing: MosaicGridSpacing,
        gridSizing: MosaicGridSizing,
        useCompatLayout: Bool,
        @ViewBuilder content: @escaping () -> Content) {
            self.orientation = orientation
            self.spacing = spacing
            self.gridSizing = gridSizing
            self.useCompatLayout = useCompatLayout
            self.content = content
        }
    
    var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *), !useCompatLayout {
            switch gridSizing {
            case .aspectRatio(let ratio, let crossGridCount):
                mosaicRatioGridLayout(aspectRatio: ratio, crossGridCount: crossGridCount)
            case .constantAxis(let dimension, let crossGridCount):
                mosaicAxisDimensionGridLayout(axisDimension: dimension, crossGridCount: crossGridCount)
            case .constantSize(let size):
                mosaicSizedGridLayout(gridSize: size, minimumSpacing: spacing)
            case .flow(let alignment):
                flowGridLayout(spacing: spacing, alignment: alignment)
            }
        } else {
            MosaicGridCompat(
                orientation: orientation,
                spacing: spacing,
                gridSizing: gridSizing,
                content: content()
            )
        }
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func mosaicSizedGridLayout(gridSize: CGSize, minimumSpacing: MosaicGridSpacing) -> some View {
        MosaicSizedGridLayout(
            orientation: orientation,
            gridSize: gridSize,
            minimumSpacing: minimumSpacing
        ) {
            content()
        }
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func flowGridLayout(spacing: MosaicGridSpacing, alignment: FlowMosaicAlignment) -> some View {
        FlowMosaicGridLayout(
            orientation: orientation,
            spacing: spacing,
            alignment: alignment
        ) {
            content()
        }
    }
}

// MARK: Preview
#if DEBUG
#Preview(".constantSize") {
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
                    .foregroundColor(.blue)
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
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview(".constantSize compat") {
    ScrollView(.vertical) {
        MosaicGrid(
            orientation: .vertical,
            spacing: MosaicGridSpacing(spacings: 18),
            gridSizing: .constantSize(CGSize(width: 9, height: 9)),
            useCompatLayout: true
        ) {
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
                    .foregroundColor(.blue)
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
