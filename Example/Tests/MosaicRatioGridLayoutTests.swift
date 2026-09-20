//
//  MosaicRatioGridLayoutTests.swift
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
class MosaicRatioGridLayoutTests: XCTestCase {
    
    func test_givenVGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicRatioGridLayout(
            orientation: .vertical,
            crossGridCount: 5,
            aspectRatio: 2
        )
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 5))
    }
    
    func test_givenHGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicRatioGridLayout(
            orientation: .horizontal,
            crossGridCount: 5,
            aspectRatio: 2
        )
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 20, height: 10))
    }
    
    func test_givenVGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicRatioGridLayout(
            orientation: .vertical,
            crossGridCount: 5,
            aspectRatio: 2,
            spacing: MosaicGridSpacing(spacings: 10)
        )
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 5))
    }
    
    func test_givenHGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicRatioGridLayout(
            orientation: .horizontal,
            crossGridCount: 5,
            aspectRatio: 2,
            spacing: MosaicGridSpacing(spacings: 10)
        )
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 20, height: 10))
    }
    
    func test_givenVGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() throws {
        try requireLayoutAvailability()
        let vGrid = MosaicRatioGridLayout(
            orientation: .vertical,
            crossGridCount: 5,
            aspectRatio: 2
        )
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = vGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }
    
    func test_givenHGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() throws {
        try requireLayoutAvailability()
        let hGrid = MosaicRatioGridLayout(
            orientation: .horizontal,
            crossGridCount: 5,
            aspectRatio: 2
        )
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = hGrid.calculateGridSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }

    func test_givenCrossAxisProposalAtOrBelowTotalSpacing_whenCalculateTileSize_shouldReturnZeroForBothOrientations() throws {
        try requireLayoutAvailability()

        for orientation in [GridOrientation.vertical, .horizontal] {
            let grid = MosaicRatioGridLayout(
                orientation: orientation,
                crossGridCount: 5,
                aspectRatio: 2,
                spacing: MosaicGridSpacing(spacings: 10)
            )

            for crossAxisProposal in [39.0, 40.0] {
                let proposal = orientation == .vertical
                    ? ProposedViewSize(width: crossAxisProposal, height: 100)
                    : ProposedViewSize(width: 100, height: crossAxisProposal)

                XCTAssertEqual(grid.calculateGridSize(basedOn: proposal), .zero)
            }
        }
    }
}
