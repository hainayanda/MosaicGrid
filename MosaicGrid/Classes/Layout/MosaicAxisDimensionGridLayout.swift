//
//  MosaicAxisDimensionGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

// MARK: - MosaicAxisDimensionGridLayout

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct MosaicAxisDimensionGridLayout: MosaicGridLayout {
    
    typealias Cache = MosaicGridLayoutCache
    
    let crossOrientationCount: Int
    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridAxisDimension: CGFloat
    
    @inlinable init(orientation: GridOrientation, crossGridCount: Int, gridAxisDimension: CGFloat, spacing: MosaicGridSpacing = .zero) {
        self.orientation = orientation
        self.crossOrientationCount = crossGridCount
        self.spacing = spacing
        self.gridAxisDimension = gridAxisDimension
    }
    
    @inlinable func calculateGridSize(basedOn proposal: ProposedViewSize) -> CGSize {
        guard let proposedDimension = proposal.axisDimension(for: crossOrientation), proposedDimension.isNormal else { return .zero }
        let usedDimension = proposedDimension - (crossAxisSpacing * CGFloat(crossOrientationCount - 1))
        let calculatedGridDimension = usedDimension / CGFloat(crossOrientationCount)
        return orientation == .vertical
        ? CGSize(width: calculatedGridDimension, height: gridAxisDimension)
        : CGSize(width: gridAxisDimension, height: calculatedGridDimension)
    }
}
