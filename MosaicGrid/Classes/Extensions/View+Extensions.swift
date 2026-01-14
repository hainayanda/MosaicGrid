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
        let size = MosaicGridSize(width: horizontal, height: vertical)
        return self.modifier(UsingGridsModifier(size: size))
    }
}

@usableFromInline struct UsingGridsModifier: ViewModifier {
    @usableFromInline let size: MosaicGridSize
    
    @usableFromInline init(size: MosaicGridSize) {
        self.size = size
    }
    
    @usableFromInline func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            content
                .layoutValue(key: UsingGrids.self, value: size)
                .mosaicGridSize(size) // Apply trait too just in case we share logic or fallback
        } else {
            content
                .mosaicGridSize(size)
        }
    }
}
