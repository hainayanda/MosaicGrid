//
//  MosaicAxisDimensionGridLayoutTests.swift
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
class MosaicAxisDimensionGridLayoutTests: XCTestCase {
    
    func test_givenVGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicAxisDimensionGridLayout(orientation: .vertical, crossGridCount: 5, gridAxisDimension: 10)
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenHGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicAxisDimensionGridLayout(orientation: .horizontal, crossGridCount: 5, gridAxisDimension: 10)
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenVGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicAxisDimensionGridLayout(orientation: .vertical, crossGridCount: 5, gridAxisDimension: 10, spacing: MosaicGridSpacing(spacings: 10))
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenHGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicAxisDimensionGridLayout(orientation: .horizontal, crossGridCount: 5, gridAxisDimension: 10, spacing: MosaicGridSpacing(spacings: 10))
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenVGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicAxisDimensionGridLayout(orientation: .vertical, crossGridCount: 5, gridAxisDimension: 10, spacing: MosaicGridSpacing(spacings: 10))
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }
    
    func test_givenHGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicAxisDimensionGridLayout(orientation: .horizontal, crossGridCount: 5, gridAxisDimension: 10, spacing: MosaicGridSpacing(spacings: 10))
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }
}
