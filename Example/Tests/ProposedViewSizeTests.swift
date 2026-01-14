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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
class ProposedViewSizeTests: XCTestCase {
    
    func test_givenAxisIsVertical_thenAxisDimensionShouldReturnHeight() throws {
        try requireLayoutAvailability()
        let proposedViewSizeInTest = ProposedViewSize(
            width: .random(in: 1..<100),
            height: .random(in: 1..<100)
        )
        XCTAssertEqual(
            proposedViewSizeInTest.axisDimension(for: .vertical),
            proposedViewSizeInTest.height
        )
    }
    
    func test_givenAxisIsHorizontal_thenAxisDimensionShouldReturnWidth() throws {
        try requireLayoutAvailability()
        let proposedViewSizeInTest = ProposedViewSize(
            width: .random(in: 1..<100),
            height: .random(in: 1..<100)
        )
        XCTAssertEqual(
            proposedViewSizeInTest.axisDimension(for: .horizontal),
            proposedViewSizeInTest.width
        )
    }
}
