//
//  MutableLogicalMatrixIterator.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

struct MutableLogicalMatrixIterator: IteratorProtocol {
    
    typealias Element = (index: Int, innerIndex: Int, value: Bool)
    
    let matrix: any MutableLogicalMatrix
    lazy var lastIndex: Int = matrix.startIndex
    var lastInnerIndex: Int = -1
    
    @inlinable mutating func next() -> (index: Int, innerIndex: Int, value: Bool)? {
        guard lastIndex < matrix.endIndex else { return nil }
        let nextInnerIndex = lastInnerIndex + 1
        guard let array = matrix[lastIndex],
              let value = array[safe: nextInnerIndex] else {
            lastIndex += 1
            lastInnerIndex = -1
            return next()
        }
        lastInnerIndex = nextInnerIndex
        return (lastIndex, nextInnerIndex, value)
    }
}
