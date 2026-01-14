//
//  MosaicGridSizing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

/// Defines how the grid sizing should be calculated.
@usableFromInline enum MosaicGridSizing {
    /// Size based on aspect ratio with a specific cross-axis grid count.
    case aspectRatio(Double, crossGridCount: Int)
    /// Size based on a constant axis dimension with a specific cross-axis grid count.
    case constantAxis(CGFloat, crossGridCount: Int)
    /// Size based on a constant size for each grid item.
    case constantSize(CGSize)
    /// Flow layout with a specific alignment.
    case flow(FlowMosaicAlignment)
}
