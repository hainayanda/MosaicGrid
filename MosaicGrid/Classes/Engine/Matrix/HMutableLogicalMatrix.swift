//
//  HMutableLogicalMatrix.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

struct HMutableLogicalMatrix: MutableLogicalMatrix {
    
    @inlinable var width: Int { twoDArray.count }
    let height: Int
    let startIndex: Int = .zero
    @inlinable var endIndex: Int { width }
    private(set) var lastAvailableIndex: Int = 0
    
    private var twoDArray: [[Bool]] = []
    
    @inlinable init(height: Int) {
        self.height = height
    }
    
    @inlinable subscript(_ index: Int) -> [Bool]? {
        twoDArray[safe: index]
    }
    
    @inlinable subscript(_ column: Int, _ row: Int) -> Bool {
        get {
            guard let columnArray = twoDArray[safe: column] else {
                let message = "Try to get item out of its matrix bounds. [\(column),\(row)] while matrix size is [\(width), \(height)]"
                log(.error, message)
                assertionFailure(message)
                return false
            }
            return columnArray[safe: row] ?? false
        }
        set {
            guard row < height else {
                let message = "Row should be less than matrix width. Row is \(row), while height is \(height)"
                log(.error, message)
                assertionFailure(message)
                return
            }
            if column >= twoDArray.count {
                let numberOfArrayNeeded = column - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    [Bool].init(repeating: false, count: height)
                }
                twoDArray.append(contentsOf: newArrays)
            }
            twoDArray[column][row] = newValue
            lastAvailableIndex = calculateLastAvailableIndexAfter(set: newValue, at: column)
        }
    }
}
