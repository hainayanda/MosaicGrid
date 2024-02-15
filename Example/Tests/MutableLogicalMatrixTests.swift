//
//  MutableLogicalMatrixTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 15/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid

class MutableLogicalMatrixTests: XCTestCase {
    
    func test_givenEmptyMatrix_whenGetInBounds_thenItShouldReturnNil() {
        let vMatrix = VMutableLogicalMatrix(width: 5)
        let hMatrix = HMutableLogicalMatrix(height: 5)
        for index in 0..<6 {
            XCTAssertNil(vMatrix[0, index])
            XCTAssertNil(hMatrix[index, 0])
        }
    }
    
    func test_givenMatrix_whenSetInBounds_thenItShouldGrow() {
        var vMatrix = VMutableLogicalMatrix(width: 5)
        var hMatrix = HMutableLogicalMatrix(height: 5)
        for index in 0..<6 {
            vMatrix[1, index] = true
            hMatrix[index, 1] = true
            XCTAssertNotNil((vMatrix[0, index]))
            XCTAssertNotNil((vMatrix[1, index]))
            XCTAssertNotNil((hMatrix[index, 0]))
            XCTAssertNotNil((hMatrix[index, 1]))
        }
    }
    
    func test_givenMatrix_whenGetUnsetOutBounds_thenItShouldReturnFalse() {
        var vMatrix = VMutableLogicalMatrix(width: 5)
        var hMatrix = HMutableLogicalMatrix(height: 5)
        for index in 0..<6 {
            vMatrix[0, index] = true
            hMatrix[index, 0] = true
            XCTAssertFalse((vMatrix[6, index]!))
            XCTAssertFalse((hMatrix[index, 6]!))
        }
    }
    
    func test_givenMatrix_whenSetNil_thenItShouldSetFalse() {
        var vMatrix = VMutableLogicalMatrix(width: 5)
        var hMatrix = HMutableLogicalMatrix(height: 5)
        for index in 0..<6 {
            vMatrix[0, index] = nil
            hMatrix[index, 0] = nil
            XCTAssertFalse((vMatrix[0, index]!))
            XCTAssertFalse((hMatrix[index, 0]!))
        }
    }
}
