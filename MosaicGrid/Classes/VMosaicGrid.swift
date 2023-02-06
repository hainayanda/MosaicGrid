//
//  VMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

public struct VMosaicGrid<Content>: View where Content: View {
    
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let hGridCount: Int
    
    let content: (MosaicGridSizeContext) -> Content
    
    init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, @ViewBuilder content: @escaping (MosaicGridSizeContext) -> Content) {
        self.content = content
        self.hGridCount = hGridCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
    init(hGridCount: Int, spacing: CGFloat, @ViewBuilder content: @escaping (MosaicGridSizeContext) -> Content) {
        self.init(
            hGridCount: hGridCount,
            hSpacing: spacing,
            vSpacing: spacing,
            content: content
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VMosaicGridLayout(gridHCount: hGridCount, hSpacing: hSpacing, vSpacing: vSpacing) {
                content(
                    MosaicGridSizeContext(
                        geometry: geometry,
                        orientation: .vertical,
                        gridCount: hGridCount,
                        hSpacing: hSpacing,
                        vSpacing: vSpacing
                    )
                )
            }
        }
    }
}

struct VMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VMosaicGrid(hGridCount: 5, spacing: 10) { gridSize in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(size: gridSize[h: 2])
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(size: gridSize[w: 2])
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(size: gridSize[w: 2, h: 2])
                Rectangle()
                    .foregroundColor(.green)
                    .frame(size: gridSize[w: 2])
                Rectangle()
                    .foregroundColor(.cyan)
                    .frame(size: gridSize[w: 2, h: 2])
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(size: gridSize[h: 2])
                Rectangle()
                    .foregroundColor(.purple)
                    .frame(size: gridSize[w: 2, h: 3])
                Rectangle()
                    .foregroundColor(.pink)
                    .frame(size: gridSize[w: 2, h: 2])
                Rectangle()
                    .foregroundColor(.red)
                    .frame(size: gridSize)
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(size: gridSize[w: 3])
            }
            .padding()
        }
    }
}

extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
    
    func frame(size gridSizeContext: MosaicGridSizeContext) -> some View {
        frame(size: gridSizeContext.singleGridSize)
    }
}
