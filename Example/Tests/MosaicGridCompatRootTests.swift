//
//  MosaicGridCompatRootTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 09/08/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import MosaicGrid

final class MosaicGridCompatRootTests: XCTestCase {
    
    func test_givenVerticalConstantAxis_whenCalculateGridSize_shouldRespectCrossSpacing() {
        let root = MosaicGridCompatRoot(
            orientation: .vertical,
            spacing: MosaicGridSpacing(spacings: 10),
            gridSizing: .constantAxis(12, crossGridCount: 5)
        )
        
        let proposal = CGSize(width: 90, height: 120)
        let size = root.calculateGridSize(basedOn: proposal)
        
        XCTAssertEqual(size, CGSize(width: 10, height: 12))
    }
    
    func test_givenHorizontalAspectRatio_whenCalculateGridSize_shouldRespectRatio() {
        let root = MosaicGridCompatRoot(
            orientation: .horizontal,
            spacing: MosaicGridSpacing(spacings: 5),
            gridSizing: .aspectRatio(2, crossGridCount: 4)
        )
        
        let proposal = CGSize(width: 120, height: 100)
        let size = root.calculateGridSize(basedOn: proposal)
        
        XCTAssertEqual(size, CGSize(width: 42.5, height: 21.25))
    }
    
    func test_givenConstantSize_whenCalculateDynamicCrossCount_shouldReturnExpectedCount() {
        let root = MosaicGridCompatRoot(
            orientation: .vertical,
            spacing: MosaicGridSpacing(spacings: 2),
            gridSizing: .constantSize(CGSize(width: 10, height: 10))
        )
        
        let proposal = CGSize(width: 100, height: 80)
        let count = root.calculateDynamicCrossCount(proposal: proposal)
        
        XCTAssertEqual(count, 8)
    }
    
    func test_givenFlowSizing_whenCalculateCrossCount_shouldReturnOne() {
        let root = MosaicGridCompatRoot(
            orientation: .vertical,
            spacing: .zero,
            gridSizing: .flow(.leading)
        )
        
        let proposal = CGSize(width: 100, height: 100)
        let count = root.calculateCrossCount(for: proposal)
        
        XCTAssertEqual(count, 1)
    }

    func test_givenFlowVerticalCompat_whenWrapping_shouldAdvanceRow() {
        let sizes = [
            CGSize(width: 60, height: 10),
            CGSize(width: 50, height: 20),
            CGSize(width: 40, height: 30)
        ]
        let positions = FlowMosaicGridLayoutCompat.computeFlowPositions(
            sizes: sizes,
            containerSize: CGSize(width: 100, height: 200),
            orientation: .vertical,
            spacing: MosaicGridSpacing(spacings: 10)
        )
        
        XCTAssertEqual(positions, [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 20),
            CGPoint(x: 60, y: 20)
        ])
    }
    
    func test_givenFlowHorizontalCompat_whenWrapping_shouldAdvanceColumn() {
        let sizes = [
            CGSize(width: 10, height: 60),
            CGSize(width: 20, height: 50),
            CGSize(width: 30, height: 40)
        ]
        let positions = FlowMosaicGridLayoutCompat.computeFlowPositions(
            sizes: sizes,
            containerSize: CGSize(width: 200, height: 100),
            orientation: .horizontal,
            spacing: MosaicGridSpacing(spacings: 10)
        )
        
        XCTAssertEqual(positions, [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 20, y: 0),
            CGPoint(x: 20, y: 60)
        ])
    }
}
