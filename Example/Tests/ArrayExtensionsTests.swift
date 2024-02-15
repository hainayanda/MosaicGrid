//
//  ArrayExtensionsTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 15/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid

class ArrayExtensionsTests: XCTestCase {
    
    let array: [Int] = [0, 1, 2, 3, 4, 5]
    
    func test_givenIndexIsInBounds_whenSafeSubscript_thenItShouldReturnValue() {
        for index in 0..<5 {
            XCTAssertEqual(array[safe: index], index)
        }
    }
    
    func test_givenIndexIsOutOfBounds_whenSafeSubscript_thenItShouldReturnNil() {
        XCTAssertNil(array[safe: 6])
    }
    
    func test_givenIndexIsNegative_whenSafeSubscript_thenItShouldReturnNil() {
        XCTAssertNil(array[safe: -1])
    }
}
