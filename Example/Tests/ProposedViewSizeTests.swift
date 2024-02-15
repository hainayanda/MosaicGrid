//
//  ProposedViewSizeTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 15/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid
import SwiftUI

class ProposedViewSizeTests: XCTestCase {
    
    var proposedViewSizeInTest: ProposedViewSize!
    
    override func setUp() {
        proposedViewSizeInTest = ProposedViewSize(
            width: .random(in: 1..<100),
            height: .random(in: 1..<100)
        )
    }
    
    func test_givenAxisIsVertical_thenAxisDimensionShouldReturnHeight() {
        XCTAssertEqual(
            proposedViewSizeInTest.axisDimension(for: .vertical),
            proposedViewSizeInTest.height
        )
    }
    
    func test_givenAxisIsHorizontal_thenAxisDimensionShouldReturnWidth() {
        XCTAssertEqual(
            proposedViewSizeInTest.axisDimension(for: .horizontal),
            proposedViewSizeInTest.width
        )
    }
}
