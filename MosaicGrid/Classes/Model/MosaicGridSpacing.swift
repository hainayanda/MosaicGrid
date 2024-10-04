//
//  MosaicGridSpacing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

/// Horizontal and vertical spacing for Mosaic Grid
public struct MosaicGridSpacing: Equatable {
    /// Horizontal spacing
    public let horizontal: CGFloat
    
    /// Vertical spacing
    public let vertical: CGFloat
    
    /// Initialize `MosaicGridSpacing` with given horizontal and vertical spacing
    /// - Parameters:
    ///   - horizontal: Horizontal spacing
    ///   - vertical: Vertical spacing. Default value is zero
    @inlinable public init(h horizontal: CGFloat, v vertical: CGFloat = .zero) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// Initialize `MosaicGridSpacing` with given vertical spacing. Horizontal spacing will be zero.
    /// - Parameter vertical: Vertical spacing
    @inlinable public init(v vertical: CGFloat) {
        self.horizontal = .zero
        self.vertical = vertical
    }
    
    /// Initialize `MosaicGridSpacing` with same value for horizontal and vertical spacing.
    /// - Parameter spacing: Spacing used for both horizontal and vertical spacings.
    @inlinable public init(spacings: CGFloat) {
        self.horizontal = spacings
        self.vertical = spacings
    }
}

extension MosaicGridSpacing {
    @inlinable public static var zero: MosaicGridSpacing { .init(spacings: .zero) }
}
