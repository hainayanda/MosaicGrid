//
//  VMutableLogicalMatrix.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

struct VMutableLogicalMatrix: MutableLogicalMatrix {
    
    let width: Int
    @inlinable var height: Int { twoDArray.count }
    let startIndex: Int = .zero
    @inlinable var endIndex: Int { height }
    private(set) var lastAvailableIndex: Int = 0
    
    private var twoDArray: [[Bool]] = []
    
    @inlinable init(width: Int) {
        self.width = width
    }
    
    @inlinable subscript(_ index: Int) -> [Bool]? {
        twoDArray[safe: index]
    }
    
    @inlinable subscript(_ column: Int, _ row: Int) -> Bool {
        get {
            guard let rowArray = twoDArray[safe: row] else {
                let message = "Try to get item out of its matrix bounds. [\(column),\(row)] while matrix size is [\(width), \(height)]"
                log(.error, message)
                assertionFailure(message)
                return false
            }
            return rowArray[safe: column] ?? false
        }
        set {
            guard column < width else {
                let message = "Column should be less than matrix width. Column is \(column), while width is \(width)"
                log(.error, message)
                assertionFailure(message)
                return
            }
            if row >= twoDArray.count {
                let numberOfArrayNeeded = row - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    [Bool].init(repeating: false, count: width)
                }
                twoDArray.append(contentsOf: newArrays)
            }
            twoDArray[row][column] = newValue
            lastAvailableIndex = calculateLastAvailableIndexAfter(set: newValue, at: row)
        }
    }
}
