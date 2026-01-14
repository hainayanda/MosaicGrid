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
    private var filledCount: [Int] = []
    
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
                filledCount.append(contentsOf: [Int](repeating: 0, count: numberOfArrayNeeded))
            }
            let oldValue = twoDArray[column][row]
            if oldValue != newValue {
                twoDArray[column][row] = newValue
                filledCount[column] += newValue ? 1 : -1
                lastAvailableIndex = calculateLastAvailableIndexAfter(set: newValue, at: column)
            }
        }
    }
    
    @inlinable func calculateLastAvailableIndexAfter(set value: Bool, at updatedIndex: Int) -> Int {
        if !value, lastAvailableIndex > updatedIndex {
            return updatedIndex
        } else if value, lastAvailableIndex == updatedIndex {
            for index in (updatedIndex ..< width) {
                if filledCount[index] < height {
                    return index
                }
            }
            return width
        }
        return lastAvailableIndex
    }
}

