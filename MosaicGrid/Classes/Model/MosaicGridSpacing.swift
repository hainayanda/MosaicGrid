//
//  MosaicGridSpacing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

/// <#Description#>
public struct MosaicGridSpacing {
    /// <#Description#>
    public let horizontal: CGFloat
    
    /// <#Description#>
    public let vertical: CGFloat
    
    /// <#Description#>
    /// - Parameters:
    ///   - horizontal: <#horizontal description#>
    ///   - vertical: <#vertical description#>
    public init(h horizontal: CGFloat, v vertical: CGFloat = .zero) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    /// <#Description#>
    /// - Parameter vertical: <#vertical description#>
    public init(v vertical: CGFloat) {
        self.horizontal = .zero
        self.vertical = vertical
    }
    
    /// <#Description#>
    /// - Parameter spacing: <#spacing description#>
    public init(spacings: CGFloat) {
        self.horizontal = spacings
        self.vertical = spacings
    }
}

extension MosaicGridSpacing {
    public static var zero: MosaicGridSpacing { .init(spacings: .zero) }
}

extension MosaicGridSpacing: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        self.init(spacings: value)
    }
}

extension MosaicGridSpacing: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(spacings: CGFloat(value))
    }
}
