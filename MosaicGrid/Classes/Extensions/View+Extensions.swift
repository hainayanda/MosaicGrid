//
//  View+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 6/2/23.
//

import Foundation
import SwiftUI

extension View {
    public func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
    
    public func frame(size gridSizeContext: MosaicGridSizeContext) -> some View {
        frame(size: gridSizeContext.singleGridSize)
    }
}
