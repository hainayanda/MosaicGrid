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
            XCTAssertFalse((vMatrix[6, index]))
            XCTAssertFalse((hMatrix[index, 6]))
        }
    }
}
