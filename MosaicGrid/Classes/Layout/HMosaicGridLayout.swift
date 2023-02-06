//
//  HMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation
import SwiftUI

struct HMosaicGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let crossOrientationCount: Int
    var orientation: Axis.Set { .horizontal }
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    
    init(gridVCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
        self.crossOrientationCount = gridVCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
}
