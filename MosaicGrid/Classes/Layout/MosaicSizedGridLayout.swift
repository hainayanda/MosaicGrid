//
//  MosaicSizedGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

struct MosaicSizedGridLayout: MosaicGridLayout {
    
    typealias Cache = MosaicGridLayoutCache
    
    let orientation: Axis.Set
    let tileSize: CGSize
    let minimumSpacing: MosaicGridSpacing
    
    @Mutable private(set) var crossOrientationCount: Int = 1
    @Mutable private(set) var spacing: MosaicGridSpacing = .zero
    
    init(orientation: Axis.Set, tileSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero) {
        self.orientation = orientation
        self.tileSize = tileSize
        self.minimumSpacing = minimumSpacing
    }
    
    @inlinable func tilesSize(basedOn proposal: ProposedViewSize) -> CGSize {
        let tileAxisDimension = tileSize.axisDimension(for: crossOrientation)
        let axisDimension = proposal.axisDimension(for: crossOrientation) ?? tileAxisDimension
        let crossAxisSpacing = minimumSpacing.axisSpacing(for: crossOrientation)
        let axisSpacing = minimumSpacing.axisSpacing(for: orientation)
        
        self.crossOrientationCount = max(1, Int((axisDimension + crossAxisSpacing) / (tileAxisDimension + crossAxisSpacing)))
        
        if crossOrientationCount == 1 {
            self.spacing = minimumSpacing
        } else {
            let realSpacing = (axisDimension - (tileAxisDimension * CGFloat(crossOrientationCount))) / CGFloat(crossOrientationCount - 1)
            self.spacing = MosaicGridSpacing(axis: axisSpacing, crossAxis: realSpacing, for: orientation)
        }
        
        return tileSize
    }
}

// MARK: Private Extensions

private extension CGSize {
    func axisDimension(for axis: Axis.Set) -> CGFloat {
        axis == .vertical ? height: width
    }
}

private extension MosaicGridSpacing {
    
    init(axis: CGFloat, crossAxis: CGFloat, for orientation: Axis.Set) {
        switch orientation {
        case .horizontal:
            self.init(h: axis, v: crossAxis)
        default:
            self.init(h: crossAxis, v: axis)
        }
    }
    
    func axisSpacing(for axis: Axis.Set) -> CGFloat {
        axis == .vertical ? vertical: horizontal
    }
}
