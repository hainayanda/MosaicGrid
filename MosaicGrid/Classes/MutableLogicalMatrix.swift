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
        get {
            guard let rowArray = twoDArray[safe: row] else { return nil }
            return rowArray[safe: column] ?? nil
        }
        set {
            guard column < width else { fatalError("Column should be less than matrix width") }
            if row >= twoDArray.count {
                let numberOfArrayNeeded = row - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    Array<Bool>.init(repeating: false, count: width)
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
        get {
            guard let columnArray = twoDArray[safe: column] else { return nil }
            return columnArray[safe: row] ?? nil
        }
        set {
            guard row < height else { fatalError() }
            if column >= twoDArray.count {
                let numberOfArrayNeeded = column - twoDArray.count + 1
                let newArrays: [[Bool]] = (0 ..< numberOfArrayNeeded).map { _ in
                    Array<Bool>.init(repeating: false, count: height)
                }
                twoDArray.append(contentsOf: newArrays)
            }
            twoDArray[column][row] = newValue ?? false
        }
    }
}
