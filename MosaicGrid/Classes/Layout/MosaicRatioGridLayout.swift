//
//  MosaicRatioGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicRatioGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let crossOrientationCount: Int
    let orientation: Axis.Set
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let aspectRatio: Double
    
    init(orientation: Axis.Set, crossGridCount: Int, aspectRatio: Double = 1, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
        self.orientation = orientation
        self.crossOrientationCount = crossGridCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.aspectRatio = aspectRatio
    }
    
    func gridSize(basedOn proposal: ProposedViewSize) -> CGSize {
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
