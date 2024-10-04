//
//  MutableLogicalMatrixSplice.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

struct MutableLogicalMatrixSplice: MutableLogicalMatrix {
    
    private var underlyingMatrix: any MutableLogicalMatrix
    
    @inlinable var width: Int { underlyingMatrix.width }
    @inlinable var height: Int { underlyingMatrix.height }
    @inlinable var startIndex: Int { underlyingMatrix.lastAvailableIndex }
    @inlinable var endIndex: Int { underlyingMatrix.endIndex }
    @inlinable var lastAvailableIndex: Int { underlyingMatrix.lastAvailableIndex }
    
    @inlinable subscript(index: Int) -> [Bool]? {
        underlyingMatrix[index]
    }
    
    @inlinable subscript(column: Int, row: Int) -> Bool? {
        get {
            underlyingMatrix[column, row]
        }
        set {
            underlyingMatrix[column, row] = newValue
        }
    }
    
    @inlinable init(underlyingMatrix: any MutableLogicalMatrix) {
        self.underlyingMatrix = underlyingMatrix
    }
}
