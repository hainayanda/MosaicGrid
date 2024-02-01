//
//  MosaicRatioGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicRatioGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicTileLayoutItem]
    
    let crossOrientationCount: Int
    let orientation: Axis.Set
    let spacing: MosaicGridSpacing
    let aspectRatio: Double
    
    init(orientation: Axis.Set, crossGridCount: Int, aspectRatio: Double = 1, spacing: MosaicGridSpacing = .zero) {
        self.orientation = orientation
        self.crossOrientationCount = crossGridCount
        self.spacing = spacing
        self.aspectRatio = aspectRatio
    }
    
    @inlinable func tilesSize(basedOn proposal: ProposedViewSize) -> CGSize {
        guard let proposedDimension = proposal.axisDimension(for: crossOrientation) else { return .zero }
        let usedDimension = proposedDimension - (crossAxisSpacing * CGFloat(crossOrientationCount - 1))
        let calculatedGridDimension = usedDimension / CGFloat(crossOrientationCount)
        switch orientation {
        case .vertical:
            let height = calculatedGridDimension / aspectRatio
            let width = calculatedGridDimension
            return CGSize(width: width, height: height)
        default:
            let width = calculatedGridDimension * aspectRatio
            let height = calculatedGridDimension
            return CGSize(width: width, height: height)
        }
    }
}
