//
//  View+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

extension View {
    
    /// Set the size of the tiles based on the number of the tiles used inside `VMosaicGrid` or `HMosaicGrid`.
    /// Keep in mind that this will not resize the view inside it. It will only proposed this size to the particular view.
    /// - Parameters:
    ///   - horizontal: Number of horizontal grid used. Default is 1.
    ///   - vertical: Number of vertical grid used. Default is 1.
    /// - Returns: View with tile size layout value.
    @inlinable public func usingGrids(h horizontal: Int = 1, v vertical: Int = 1) -> some View {
        return layoutValue(key: UsingGrids.self, value: MosaicGridSize(width: horizontal, height: vertical))
    }
}
