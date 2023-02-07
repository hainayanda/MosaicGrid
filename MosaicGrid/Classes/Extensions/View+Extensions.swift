//
//  View+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

extension View {
    /// <#Description#>
    /// - Parameters:
    ///   - width: <#width description#>
    ///   - height: <#height description#>
    /// - Returns: <#description#>
    public func tileSized(w width: Int = 1, h height: Int = 1) -> some View {
        return layoutValue(key: MosaicTiles.self, value: MosaicGridSize(width: width, height: height))
    }
}
