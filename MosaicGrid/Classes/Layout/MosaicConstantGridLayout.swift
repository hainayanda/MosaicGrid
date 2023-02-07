//
//  MosaicConstantGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicConstantGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let crossOrientationCount: Int
    let orientation: Axis.Set
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let gridAxisDimension: CGFloat
    
    init(orientation: Axis.Set, crossGridCount: Int, gridAxisDimension: CGFloat, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
        self.orientation = orientation
        self.crossOrientationCount = crossGridCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.gridAxisDimension = gridAxisDimension
    }
    
    func gridSize(basedOn proposal: ProposedViewSize) -> CGSize {
        guard let proposedDimension = proposal.axisDimension(for: crossOrientation) else { return .zero }
        let usedDimension = proposedDimension - (crossAxisSpacing * CGFloat(crossOrientationCount - 1))
        let calculatedGridDimension = usedDimension / CGFloat(crossOrientationCount)
        return orientation == .vertical
        ? CGSize(width: calculatedGridDimension, height: gridAxisDimension)
        : CGSize(width: gridAxisDimension, height: calculatedGridDimension)
    }
}
