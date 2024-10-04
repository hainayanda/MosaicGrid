//
//  VMutableLogicalMatrix.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

struct VMutableLogicalMatrix: MutableLogicalMatrix {
    
    let width: Int
    var height: Int { twoDArray.count }
    let startIndex: Int = .zero
    var endIndex: Int { height }
    private(set) var lastAvailableIndex: Int = 0
    
    private var twoDArray: [[Bool]] = []
    
    @inlinable init(width: Int) {
        self.width = width
    }
    
    @inlinable subscript(_ index: Int) -> [Bool]? {
        twoDArray[safe: index]
    }
    
    subscript(_ column: Int, _ row: Int) -> Bool? {
        @inlinable get {
            guard let rowArray = twoDArray[safe: row] else {
                log(.error, "Try to get item out of its matrix bounds. [\(column),\(row)] while matrix size is [\(width), \(height)]")
                return nil
            }
            return rowArray[safe: column] ?? false
        }
        @inlinable set {
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
            twoDArray[row][column] = newValue ?? false
            lastAvailableIndex = calculateLastAvailableIndexAfter(set: newValue ?? false, at: row)
        }
    }
}
