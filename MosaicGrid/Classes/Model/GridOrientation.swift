//
//  GridOrientation.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/10/24.
//

/// Represents the orientation of a grid layout.
@usableFromInline enum GridOrientation: Equatable {
    /// Vertical orientation where items flow vertically.
    case vertical
    /// Horizontal orientation where items flow horizontally.
    case horizontal
}

// MARK: - GridOrientation + Extensions

extension GridOrientation {
    @inlinable var cross: GridOrientation {
        self == .vertical ? .horizontal : .vertical
    }
}
