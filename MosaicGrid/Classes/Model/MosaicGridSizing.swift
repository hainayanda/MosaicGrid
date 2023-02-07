//
//  MosaicGridSizing.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

enum MosaicGridSizing {
    case aspectRatio(Double)
    case constantAxis(CGFloat)
    
    static var `default`: MosaicGridSizing { .aspectRatio(1) }
}
