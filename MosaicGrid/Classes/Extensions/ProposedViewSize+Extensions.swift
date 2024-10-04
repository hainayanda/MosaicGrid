//
//  ProposedViewSize+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation
import SwiftUI

extension ProposedViewSize {
    func axisDimension(for axis: GridOrientation) -> CGFloat? {
        axis == .vertical ? height : width
    }
}
