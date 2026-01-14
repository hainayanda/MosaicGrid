//
//  FlowMosaicLayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 3/10/24.
//

import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct FlowMosaicLayoutItem: Equatable {
    let view: LayoutSubview
    let size: CGSize
    let origin: CGPoint
}
