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
        let viewSize = view.sizeThatFits(proposal)
        hGridCount = calculateGridCount(for: viewSize.width, gridDimension: gridSize.width, spacing: hSpacing)
        vGridCount = calculateGridCount(for: viewSize.height, gridDimension: gridSize.height, spacing: vSpacing)
    }
}

private func calculateGridCount(for dimension: CGFloat, gridDimension: CGFloat, spacing: CGFloat) -> Int {
    let roughResult = (dimension / (gridDimension + spacing)).rounded(.up)
    let validation = (roughResult * gridDimension) + ((roughResult - 1) * spacing)
    let result = validation >= dimension ? roughResult: roughResult + 1
    return Int(result)
}
