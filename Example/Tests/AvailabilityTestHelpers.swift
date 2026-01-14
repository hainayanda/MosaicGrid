//
//  AvailabilityTestHelpers.swift
//  MosaicGrid_Tests
//
//  Created by Nayanda Haberty on 09/08/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest

extension XCTestCase {
    func requireLayoutAvailability() throws {
        #if os(iOS)
        guard #available(iOS 16.0, *) else {
            throw XCTSkip("Requires iOS 16 or newer.")
        }
        #elseif os(macOS)
        guard #available(macOS 13.0, *) else {
            throw XCTSkip("Requires macOS 13 or newer.")
        }
        #elseif os(tvOS)
        guard #available(tvOS 16.0, *) else {
            throw XCTSkip("Requires tvOS 16 or newer.")
        }
        #elseif os(watchOS)
        guard #available(watchOS 9.0, *) else {
            throw XCTSkip("Requires watchOS 9 or newer.")
        }
        #else
        throw XCTSkip("Unsupported platform.")
        #endif
    }
}
