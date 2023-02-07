//
//  MosaicAxisDimensionGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicAxisDimensionGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let crossOrientationCount: Int
    let orientation: Axis.Set
    let spacing: MosaicGridSpacing
    let gridAxisDimension: CGFloat
    
    init(orientation: Axis.Set, crossGridCount: Int, gridAxisDimension: CGFloat, spacing: MosaicGridSpacing = .zero) {
        self.orientation = orientation
        self.crossOrientationCount = crossGridCount
        self.spacing = spacing
        self.gridAxisDimension = gridAxisDimension
    }
    
    func tilesSize(basedOn proposal: ProposedViewSize) -> CGSize {
        guard let proposedDimension = proposal.axisDimension(for: crossOrientation) else { return .zero }
        let usedDimension = proposedDimension - (crossAxisSpacing * CGFloat(crossOrientationCount - 1))
        let calculatedGridDimension = usedDimension / CGFloat(crossOrientationCount)
        return orientation == .vertical
        ? CGSize(width: calculatedGridDimension, height: gridAxisDimension)
        : CGSize(width: gridAxisDimension, height: calculatedGridDimension)
    }
}
