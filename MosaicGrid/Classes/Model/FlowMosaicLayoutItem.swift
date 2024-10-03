//
//  FlowMosaicLayoutItem.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 3/10/24.
//

import Foundation
import SwiftUI

struct FlowMosaicLayoutItem: Equatable {
    let view: LayoutSubview
    let size: CGSize
    let coordinate: CGPoint
    
    init(view: LayoutSubview, size: CGSize, coordinate: CGPoint) {
        self.view = view
        self.size = size
        self.coordinate = coordinate
    }
}
