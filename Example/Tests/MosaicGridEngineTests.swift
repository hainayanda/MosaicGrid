//
//  MosaicGridEngineTests.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 22/9/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
@testable import MosaicGrid

final class MosaicGridEngineTests: XCTestCase {

    func test_givenCachedLayout_whenMosaicSizeChanges_shouldRecomputeMappedItem() {
        let engine = MosaicGridEngine(
            orientation: .vertical,
            crossOrientationCount: 3,
            spacing: .zero
        )
        let initialItems = [
            makeItem(id: 0, mosaicSize: MosaicGridSize(width: 1, height: 1)),
            makeItem(id: 1, mosaicSize: MosaicGridSize(width: 1, height: 1))
        ]

        let initial = engine.calculateLayout(for: initialItems)

        let updatedItems = [
            makeItem(id: 0, mosaicSize: MosaicGridSize(width: 2, height: 1)),
            makeItem(id: 1, mosaicSize: MosaicGridSize(width: 1, height: 1))
        ]

        let updated = engine.calculateLayout(for: updatedItems, cache: initial.mapped)

        XCTAssertEqual(updated.mapped.first?.mosaicSize, MosaicGridSize(width: 2, height: 1))
        XCTAssertEqual(updated.mapped.count, updatedItems.count)
    }

    private func makeItem(id: Int, mosaicSize: MosaicGridSize) -> UnifiedMosaicLayoutItem {
        UnifiedMosaicLayoutItem(
            sourceId: id,
            sizeThatFits: .zero,
            mosaicSize: mosaicSize,
            spacing: .zero,
            gridSize: CGSize(width: 10, height: 10)
        )
    }
}
