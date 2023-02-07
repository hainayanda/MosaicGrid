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
    let sizeThatFits: CGSize
    let mosaicSize: MosaicGridSize
    let spacing: MosaicGridSpacing
    let gridSize: CGSize
    var idealSize: CGSize { mosaicSize.idealSize(for: gridSize, with: spacing) }
    
    init(view: LayoutSubview, sizeThatFits: CGSize, gridSize: CGSize, mosaicSize: MosaicGridSize, spacing: MosaicGridSpacing) {
        self.view = view
        self.sizeThatFits = sizeThatFits
        self.mosaicSize = mosaicSize
        self.spacing = spacing
        self.gridSize = gridSize
    }
    
    init(view: LayoutSubview, proposal: ProposedViewSize, gridSize: CGSize, spacing: MosaicGridSpacing) {
        self.view = view
        self.spacing = spacing
        self.gridSize = gridSize
        let tilesSize = view[MosaicTiles.self]
        let mosaicSizeProposal = tilesSize?.proposalSize(from: proposal, gridSize: gridSize, spacing: spacing) ?? .unspecified
        self.sizeThatFits = view.sizeThatFits(mosaicSizeProposal)
        self.mosaicSize = sizeThatFits.mosaicGridSize(using: gridSize, spacing: spacing)
    }
    
    func maxedH(at height: Int) -> MosaicGridLayoutItem {
        MosaicGridLayoutItem(
            view: view,
            sizeThatFits: sizeThatFits,
            gridSize: gridSize,
            mosaicSize: MosaicGridSize(width: mosaicSize.width, height: min(mosaicSize.height, height)),
            spacing: spacing
        )
    }
    
    func maxedW(at width: Int) -> MosaicGridLayoutItem {
        MosaicGridLayoutItem(
            view: view,
            sizeThatFits: sizeThatFits,
            gridSize: gridSize,
            mosaicSize: MosaicGridSize(width: min(mosaicSize.width, width), height: mosaicSize.height),
            spacing: spacing
        )
    }
    
    func maxed(_ axis: Axis.Set, at max: Int) -> MosaicGridLayoutItem {
        switch axis {
        case .vertical:
            return maxedH(at: max)
        default:
            return maxedW(at: max)
        }
    }
}

private extension CGSize {
    
    func mosaicGridSize(using gridSize: CGSize, spacing: MosaicGridSpacing) -> MosaicGridSize {
        MosaicGridSize(
            width: calculateGridCount(for: width, gridDimension: gridSize.width, spacing: spacing.horizontal),
            height: calculateGridCount(for: height, gridDimension: gridSize.height, spacing: spacing.vertical)
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
        spacing: MosaicGridSpacing) -> ProposedViewSize {
            let proposalWidth: CGFloat = (CGFloat(width) * gridSize.width) + (CGFloat(width - 1) * spacing.horizontal)
            let proposalHeight: CGFloat = (CGFloat(height) * gridSize.height) + (CGFloat(height - 1) * spacing.vertical)
            return ProposedViewSize(width: proposalWidth, height: proposalHeight)
        }
    
    func idealSize(for gridSize: CGSize, with spacing: MosaicGridSpacing) -> CGSize {
        let sizeWidth = (CGFloat(width) * gridSize.width) + (CGFloat(width - 1) * spacing.horizontal)
        let sizeHeight = (CGFloat(height) * gridSize.height) + (CGFloat(height - 1) * spacing.vertical)
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
}
