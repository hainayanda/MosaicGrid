//
//  MosaicGridSizing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

@usableFromInline enum MosaicGridSizing {
    case aspectRatio(Double, crossGridCount: Int)
    case constantAxis(CGFloat, crossGridCount: Int)
    case constantSize(CGSize)
    case flow
}
