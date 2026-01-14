//
//  ProposedViewSize+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ProposedViewSize {
    @inlinable func axisDimension(for axis: GridOrientation) -> CGFloat? {
        axis == .vertical ? height : width
    }
}
