//
//  Array+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
