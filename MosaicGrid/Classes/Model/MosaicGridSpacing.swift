//
//  MosaicGridSpacing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

public struct MosaicGridSpacing {
    public let horizontal: CGFloat
    public let vertical: CGFloat
    
    public init(h horizontal: CGFloat, v vertical: CGFloat = .zero) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public init(v vertical: CGFloat) {
        self.horizontal = .zero
        self.vertical = vertical
    }
    
    public init(spacing: CGFloat) {
        self.horizontal = spacing
        self.vertical = spacing
    }
}

extension MosaicGridSpacing {
    public static var zero: MosaicGridSpacing { .init(spacing: .zero) }
}

extension MosaicGridSpacing: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        self.init(spacing: value)
    }
    
}

extension MosaicGridSpacing: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(spacing: CGFloat(value))
    }
}
