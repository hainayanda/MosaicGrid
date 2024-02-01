//
//  ProposedViewSize+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

extension ProposedViewSize {
    @inlinable func axisDimension(for axis: Axis.Set) -> CGFloat? {
        axis == .vertical ? height: width
    }
}
