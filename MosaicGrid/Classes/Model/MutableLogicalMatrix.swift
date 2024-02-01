//
//  MutableLogicalMatrix.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation

protocol MutableLogicalMatrix: AnyObject {
    var width: Int { get }
    var height: Int { get }
    subscript(_ column: Int, _ row: Int) -> Bool? { get set }
}

class VMutableLogicalMatrix: MutableLogicalMatrix {
    
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
            return rowArray[safe: column] ?? nil
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
}

class HMutableLogicalMatrix: MutableLogicalMatrix {
    
    var width: Int { twoDArray.count }
    let height: Int
    
    private var twoDArray: [[Bool]] = []
    
    init(height: Int) {
        self.height = height
    }
    
    subscript(_ column: Int, _ row: Int) -> Bool? {
        @inlinable get {
            guard let columnArray = twoDArray[safe: column], let value = columnArray[safe: row] else {
                log(.error, "Try to get item out of its matrix bounds. [\(column),\(row)] while matrix size is [\(width), \(height)]")
                return nil
            }
            return value
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
}
