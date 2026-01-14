//
//  MosaicSupportCompat.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridSizePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: MosaicGridSize] = [:]
    
    static func reduce(value: inout [Int: MosaicGridSize], nextValue: () -> [Int: MosaicGridSize]) {
        value.merge(nextValue()) { $1 }
    }
}

struct MosaicGridSizePreferenceView: View {
    let id: Int
    let size: MosaicGridSize
    
    var body: some View {
        Color.clear
            .preference(key: MosaicGridSizePreferenceKey.self, value: [id: size])
            .frame(width: 0, height: 0)
    }
}
