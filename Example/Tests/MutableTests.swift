//
//  MutableTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 15/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid

class MutableTests: XCTestCase {
    
    @Mutable var value: Int = 0
    
    func test_givenMutableProperty_whenSet_itShouldMutate() {
        let value = Int.random(in: -100..<100)
        self.value = value
        XCTAssertEqual(value, self.value)
    }
}
