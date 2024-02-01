//
//  View+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

extension View {
    /// Set the size of the tiles based on the number of the grid used inside `VMosaicGrid` or `HMosaicGrid`.
    /// - Parameters:
    ///   - width: Number of horizontal grid used. Default is 1.
    ///   - height: Number of vertical grid used. Default is 1.
    /// - Returns: View with tile size layout value.
    public func tileSized(w width: Int = 1, h height: Int = 1) -> some View {
        return layoutValue(key: MosaicTiles.self, value: MosaicGridSize(width: width, height: height))
    }
}
