//
//  MosaicGridCompat.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridCompat<Content>: View where Content: View {
    
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing
    let content: Content
    
    init(
        orientation: GridOrientation,
        spacing: MosaicGridSpacing,
        gridSizing: MosaicGridSizing,
        content: Content) {
            self.orientation = orientation
            self.spacing = spacing
            self.gridSizing = gridSizing
            self.content = content
        }
    
    var body: some View {
        _VariadicView.Tree(
            MosaicGridCompatRoot(
                orientation: orientation,
                spacing: spacing,
                gridSizing: gridSizing
            )
        ) {
            content
        }
    }
}
