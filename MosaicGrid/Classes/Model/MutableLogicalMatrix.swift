//
//  MutableLogicalMatrix.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation

protocol MutableLogicalMatrix {
    var width: Int { get }
    var height: Int { get }
    subscript(_ column: Int, _ row: Int) -> Bool? { get set }
    func isValid(_ column: Int, _ row: Int) -> Bool
}

struct VMutableLogicalMatrix: MutableLogicalMatrix {
    
    let width: Int
    var height: Int { twoDArray.count }
    
    private var twoDArray: [[Bool]] = []
    
    init(width: Int) {
        self.width = width
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
                fatalError(message)
            }
            if row >= twoDArray.count {
                let numberOfArrayNeeded = row - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    [Bool].init(repeating: false, count: width)
                }
                twoDArray.append(contentsOf: newArrays)
            }
            twoDArray[row][column] = newValue ?? false
        }
    }
    
    func isValid(_ column: Int, _ row: Int) -> Bool {
        guard let rowArray = twoDArray[safe: row] else {
            return false
        }
        return rowArray.count > column
    }
}

struct HMutableLogicalMatrix: MutableLogicalMatrix {
    
    var width: Int { twoDArray.count }
    let height: Int
    
    private var twoDArray: [[Bool]] = []
    
    init(height: Int) {
        self.height = height
    }
    
    subscript(_ column: Int, _ row: Int) -> Bool? {
        @inlinable get {
            guard let columnArray = twoDArray[safe: column] else {
                log(.error, "Try to get item out of its matrix bounds. [\(column),\(row)] while matrix size is [\(width), \(height)]")
                return nil
            }
            return columnArray[safe: row] ?? false
        }
        @inlinable set {
            guard row < height else {
                let message = "Row should be less than matrix width. Row is \(row), while height is \(height)"
                log(.error, message)
                fatalError(message)
            }
            if column >= twoDArray.count {
                let numberOfArrayNeeded = column - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    [Bool].init(repeating: false, count: height)
                }
                twoDArray.append(contentsOf: newArrays)
            }
            twoDArray[column][row] = newValue ?? false
        }
    }
    
    func isValid(_ column: Int, _ row: Int) -> Bool {
        guard let columnArray = twoDArray[safe: column] else {
            return false
        }
        return columnArray.count > row
    }
}
