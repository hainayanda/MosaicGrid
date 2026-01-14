//
//  MosaicSizedGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct MosaicSizedGridLayout: MosaicGridLayout {
    
    typealias Cache = MosaicGridLayoutCache
    
    let orientation: GridOrientation
    let gridSize: CGSize
    let minimumSpacing: MosaicGridSpacing
    
    @Mutable private(set) var crossOrientationCount: Int = 1
    @Mutable private(set) var spacing: MosaicGridSpacing = .zero
    
    @inlinable init(orientation: GridOrientation, gridSize: CGSize, minimumSpacing: MosaicGridSpacing = .zero) {
        self.orientation = orientation
        self.gridSize = gridSize
        self.minimumSpacing = minimumSpacing
    }
    
    @inlinable func calculateGridSize(basedOn proposal: ProposedViewSize) -> CGSize {
        let gridAxisDimension = gridSize.axisDimension(for: crossOrientation)
        let axisDimension = proposal.axisDimension(for: crossOrientation) ?? gridAxisDimension
        let crossAxisSpacing = minimumSpacing.axisSpacing(for: crossOrientation)
        let axisSpacing = minimumSpacing.axisSpacing(for: orientation)
        
        guard gridAxisDimension.isNormal, axisDimension.isNormal else {
            return .zero
        }
        
        self.crossOrientationCount = max(1, Int((axisDimension + crossAxisSpacing) / (gridAxisDimension + crossAxisSpacing)))
        
        if crossOrientationCount == 1 {
            self.spacing = minimumSpacing
        } else {
            let realSpacing = (axisDimension - (gridAxisDimension * CGFloat(crossOrientationCount))) / CGFloat(crossOrientationCount - 1)
            self.spacing = MosaicGridSpacing(axis: axisSpacing, crossAxis: realSpacing, for: orientation)
        }
        
        return gridSize
    }
}

// MARK: Private Extensions

private extension CGSize {
    func axisDimension(for axis: GridOrientation) -> CGFloat {
        axis == .vertical ? height: width
    }
}

private extension MosaicGridSpacing {
    
    init(axis: CGFloat, crossAxis: CGFloat, for orientation: GridOrientation) {
        switch orientation {
        case .horizontal:
            self.init(h: axis, v: crossAxis)
        default:
            self.init(h: crossAxis, v: axis)
        }
    }
    
    func axisSpacing(for axis: GridOrientation) -> CGFloat {
        axis == .vertical ? vertical: horizontal
    }
}
