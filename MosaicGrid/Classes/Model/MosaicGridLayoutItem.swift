//
//  MosaicGridLayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation
import SwiftUI

struct MosaicGridLayoutItem {
    let view: LayoutSubview
    let hGridCount: Int
    let vGridCount: Int
    
    init(view: LayoutSubview, hGridCount: Int, vGridCount: Int) {
        self.view = view
        self.hGridCount = hGridCount
        self.vGridCount = vGridCount
    }
    
    init(view: LayoutSubview, proposal: ProposedViewSize, gridSize: CGSize, hSpacing: CGFloat, vSpacing: CGFloat) {
        self.view = view
        let mosaicSizeProposal = view[MosaicTiles.self]?
            .proposalSize(from: proposal, gridSize: gridSize, hSpacing: hSpacing, vSpacing: vSpacing)
        ?? ProposedViewSize(width: nil, height: nil)
        let mosaicGridSize = view.sizeThatFits(mosaicSizeProposal)
            .mosaicGridSize(using: gridSize, hSpacing: hSpacing, vSpacing: vSpacing)
        hGridCount = mosaicGridSize.width
        vGridCount = mosaicGridSize.height
    }
}

private extension CGSize {
    func mosaicGridSize(using gridSize: CGSize, hSpacing: CGFloat, vSpacing: CGFloat) -> MosaicGridSize {
        MosaicGridSize(
            width: calculateGridCount(for: width, gridDimension: gridSize.width, spacing: hSpacing),
            height: calculateGridCount(for: height, gridDimension: gridSize.height, spacing: vSpacing)
        )
    }
    
    private func calculateGridCount(for dimension: CGFloat, gridDimension: CGFloat, spacing: CGFloat) -> Int {
        let roughResult = (dimension / (gridDimension + spacing)).rounded(.up)
        let validation = (roughResult * gridDimension) + ((roughResult - 1) * spacing)
        let result = validation >= dimension ? roughResult: roughResult + 1
        return Int(result)
    }
}

private extension MosaicGridSize {
    
    func proposalSize(
        from containerProposal: ProposedViewSize,
        gridSize: CGSize,
        hSpacing: CGFloat,
        vSpacing: CGFloat) -> ProposedViewSize {
            let proposalWidth: CGFloat = (CGFloat(width) * gridSize.width) + (CGFloat(width - 1) * hSpacing)
            let proposalHeight: CGFloat = (CGFloat(height) * gridSize.height) + (CGFloat(height - 1) * vSpacing)
            return ProposedViewSize(width: proposalWidth, height: proposalHeight)
        }
}
