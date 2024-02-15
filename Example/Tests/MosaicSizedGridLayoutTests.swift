//
//  MosaicSizedGridLayoutTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 15/2/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid
import SwiftUI

class MosaicSizedGridLayoutTests: XCTestCase {
    
    func test_givenVGridWithSameSize_whenCalculateTileSize_shouldReturnSameSize() {
        let vGrid = MosaicSizedGridLayout(
            orientation: .vertical,
            tileSize: CGSize(width: 10, height: 10)
        )
        
        let viewSize = ProposedViewSize(width: 10, height: 10)
        
        let size = vGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenHGridWithSameSize_whenCalculateTileSize_shouldReturnSameSize() {
        let hGrid = MosaicSizedGridLayout(
            orientation: .horizontal,
            tileSize: CGSize(width: 10, height: 10)
        )
        
        let viewSize = ProposedViewSize(width: 10, height: 10)
        
        let size = hGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenVGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() {
        let vGrid = MosaicSizedGridLayout(
            orientation: .vertical,
            tileSize: CGSize(width: 10, height: 10)
        )
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = vGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenHGridWithZeroSpacing_whenCalculateTileSize_shouldReturnDividedTileDimension() {
        let hGrid = MosaicSizedGridLayout(
            orientation: .horizontal,
            tileSize: CGSize(width: 10, height: 10)
        )
        
        let viewSize = ProposedViewSize(width: 50, height: 50)
        
        let size = hGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenVGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() {
        let vGrid = MosaicSizedGridLayout(
            orientation: .vertical,
            tileSize: CGSize(width: 10, height: 10),
            minimumSpacing: 10
        )
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = vGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenHGridWithSpacing_whenCalculateTileSize_shouldReturnDividedTileDimensionWithSpacingIntoAccount() {
        let hGrid = MosaicSizedGridLayout(
            orientation: .horizontal,
            tileSize: CGSize(width: 10, height: 10),
            minimumSpacing: 10
        )
        
        let viewSize = ProposedViewSize(width: 90, height: 90)
        
        let size = hGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 10))
    }
    
    func test_givenVGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() {
        let vGrid = MosaicSizedGridLayout(
            orientation: .vertical,
            tileSize: CGSize(width: 9, height: 9),
            minimumSpacing: 10
        )
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = vGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }
    
    func test_givenHGridWithZeroProposal_whenCalculateTileSize_shouldReturnZero() {
        let hGrid = MosaicSizedGridLayout(
            orientation: .horizontal,
            tileSize: CGSize(width: 9, height: 9),
            minimumSpacing: 10
        )
        
        let viewSize = ProposedViewSize(width: 0, height: 0)
        
        let size = hGrid.tilesSize(basedOn: viewSize)
        
        XCTAssertEqual(size, CGSize(width: 0, height: 0))
    }
    
}
