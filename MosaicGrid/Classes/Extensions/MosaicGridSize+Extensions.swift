//
//  MosaicGridSize+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import CoreGraphics

extension MosaicGridSize {
    @inlinable func usedGridsSize(for gridSize: CGSize, with spacing: MosaicGridSpacing) -> CGSize {
        let sizeWidth = (CGFloat(width) * gridSize.width) + (CGFloat(width - 1) * spacing.horizontal)
        let sizeHeight = (CGFloat(height) * gridSize.height) + (CGFloat(height - 1) * spacing.vertical)
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
}
