//
//  VMosaicGridLayout.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation
import SwiftUI

struct VMosaicGridLayout: MosaicGridLayout {
    
    typealias Cache = [MappedMosaicGridLayoutItem]
    
    let crossOrientationCount: Int
    var orientation: Axis.Set { .vertical }
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    
    init(gridHCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero) {
        self.crossOrientationCount = gridHCount
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
}
