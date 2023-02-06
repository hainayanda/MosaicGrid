//
//  MosaicGridSizeContext.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 5/2/23.
//

import Foundation
import SwiftUI

public struct MosaicGridSizeContext {
    let singleGridSize: CGSize
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    
    public var gridWidth: CGFloat { singleGridSize.width }
    public var gridHeight: CGFloat { singleGridSize.height }
    
    init(geometry: GeometryProxy, orientation: Axis.Set, gridCount: Int, hSpacing: CGFloat, vSpacing: CGFloat) {
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        let spacing: CGFloat = orientation == .vertical ? hSpacing: vSpacing
        let dimension: CGFloat = orientation == .vertical ? geometry.size.width: geometry.size.height
        let usedDimension = dimension - (spacing * CGFloat(gridCount - 1))
        let singleGridDimension = usedDimension / CGFloat(gridCount)
        singleGridSize = CGSize(width: singleGridDimension, height: singleGridDimension)
    }
    
    public subscript(w width: Int = 1, h height: Int = 1) -> CGSize {
        gridsSize(w: width, h: height)
    }
    
    func gridsSize(w width: Int, h height: Int) -> CGSize {
        return CGSize(width: gridsWidth(count: width), height: gridsHeight(count: height))
    }
    
    func gridsWidth(count: Int) -> CGFloat {
        (singleGridSize.width * CGFloat(count)) + (hSpacing * CGFloat(count - 1))
    }
    
    func gridsHeight(count: Int) -> CGFloat {
        (singleGridSize.height * CGFloat(count)) + (vSpacing * CGFloat(count - 1))
    }
}
