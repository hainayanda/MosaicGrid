//
//  TraitsCompat.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridSizeTrait: _ViewTraitKey {
    static let defaultValue: MosaicGridSize = MosaicGridSize(width: 1, height: 1)
}

extension View {
    func mosaicGridSize(_ size: MosaicGridSize) -> some View {
        _trait(MosaicGridSizeTrait.self, size)
    }
}
