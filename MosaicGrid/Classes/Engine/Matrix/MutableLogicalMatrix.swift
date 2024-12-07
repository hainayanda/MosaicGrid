//
//  MutableLogicalMatrix.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation

protocol MutableLogicalMatrix: Sequence where Iterator == MutableLogicalMatrixIterator {
    var width: Int { get }
    var height: Int { get }
    var startIndex: Int { get }
    var endIndex: Int { get }
    var lastAvailableIndex: Int { get }
    subscript(_ index: Int) -> [Bool]? { get }
    subscript(_ column: Int, _ row: Int) -> Bool { get set }
}

extension MutableLogicalMatrix {
    
    @inlinable func iterateFromLastAvailableIndex() -> any MutableLogicalMatrix {
        MutableLogicalMatrixSplice(underlyingMatrix: self)
    }
    
    @inlinable func makeIterator() -> Iterator {
        MutableLogicalMatrixIterator(matrix: self)
    }
    
    @inlinable func calculateLastAvailableIndexAfter(set value: Bool, at updatedIndex: Int) -> Int {
        if !value, lastAvailableIndex > updatedIndex {
            return updatedIndex
        } else if value, lastAvailableIndex == updatedIndex {
            for index in (updatedIndex ..< height) {
                guard let oneDMatrix = self[index] else {
                    return index
                }
                guard oneDMatrix.contains(false) else {
                    continue
                }
                return index
            }
            return height
        }
        return lastAvailableIndex
    }
}
