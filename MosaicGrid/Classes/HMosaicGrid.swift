//
//  HMosaicGrid.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import SwiftUI

public struct HMosaicGrid<Content>: View where Content: View {
    
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let vGridCount: Int
    
    let content: (MosaicGridSizeContext) -> Content
    
    init(vGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, @ViewBuilder content: @escaping (MosaicGridSizeContext) -> Content) {
        self.content = content
        self.vGridCount = vGridCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
    init(vGridCount: Int, spacing: CGFloat, @ViewBuilder content: @escaping (MosaicGridSizeContext) -> Content) {
        self.init(
            vGridCount: vGridCount,
            hSpacing: spacing,
            vSpacing: spacing,
            content: content
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HMosaicGridLayout(gridVCount: vGridCount, hSpacing: hSpacing, vSpacing: vSpacing) {
                content(
                    MosaicGridSizeContext(
                        geometry: geometry,
                        orientation: .horizontal,
                        gridCount: vGridCount,
                        hSpacing: hSpacing,
                        vSpacing: vSpacing
                    )
                )
            }
        }
    }
}

struct HMosaicGrid_Previews: PreviewProvider {
    static var previews: some View {
//        ScrollView {
            HMosaicGrid(vGridCount: 5, spacing: 10) { gridSize in
                Rectangle()
                    .foregroundColor(.red)
                    .frame(size: gridSize)
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
//        }
    }
}
