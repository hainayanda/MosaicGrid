//
//  VMosaicGrid+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

public extension VMosaicGrid {
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Both horizontal and vertical spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(spacing: CGFloat, alignment: FlowMosaicAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            spacing: MosaicGridSpacing(h: spacing, v: spacing),
            alignment: alignment,
            content: content
        )
    }

    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - spacing: Both horizontal and vertical spacing on each item.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(spacing: CGFloat, alignment: FlowMosaicAlignment = .center, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            spacing: MosaicGridSpacing(h: spacing, v: spacing),
            alignment: alignment,
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - hSpacing: Horizontal spacing on each item.
    ///   - vSpacing: Vertical spacing on each item.
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(
        hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero,
        alignment: FlowMosaicAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
            self.init(
                spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
                alignment: alignment,
                content: content
            )
        }

    /// Initialize Vertical Mosaic Grid View.
    /// It will try to arrange a grid without helping of the grid guide.
    /// But it will just arrange the subviews where it will fit with a given `spacing`
    /// - Parameters:
    ///   - hSpacing: Horizontal spacing on each item.
    ///   - vSpacing: Vertical spacing on each item.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(
        hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero,
        alignment: FlowMosaicAlignment = .center, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
            self.init(
                spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
                alignment: alignment,
                useCompatLayout: useCompatLayout,
                content: content
            )
        }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridAspectRatio: Double = 1, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridAspectRatio: gridAspectRatio,
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - hSpacing: Horizontal spacing on each grid.
    ///   - vSpacing: Vertical spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridAspectRatio: Double = 1, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridAspectRatio: gridAspectRatio,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridAspectRatio` then will be used to calculate the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - hSpacing: Horizontal spacing on each grid.
    ///   - vSpacing: Vertical spacing on each grid.
    ///   - gridAspectRatio: Aspect ratio of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridAspectRatio: Double = 1, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridAspectRatio: gridAspectRatio,
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid.
    ///   - gridHeight: Height of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridHeight: gridHeight,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - spacing: Both horizontal and vertical spacing on each grid.
    ///   - gridHeight: Height of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(hGridCount: Int, spacing: CGFloat, gridHeight: CGFloat, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(spacings: spacing),
            gridHeight: gridHeight,
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - hSpacing: Horizontal spacing on each grid.
    ///   - vSpacing: Vertical spacing on each grid.
    ///   - gridHeight: Height of each grid
    ///   - content: View that will be used as this Mosaic Grid Content
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridHeight: gridHeight,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will divide the width of the view with `hGridCount` to get the height of a single grid.
    /// If `spacing` is provided, it will add it to the calculation to make sure each grid has a spacing from each other.
    /// `gridHeight` then will be used as the height of a single grid.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - hGridCount: Count of the horizontal grid.
    ///   - hSpacing: Horizontal spacing on each grid.
    ///   - vSpacing: Vertical spacing on each grid.
    ///   - gridHeight: Height of each grid
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: View that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(hGridCount: Int, hSpacing: CGFloat = .zero, vSpacing: CGFloat = .zero, gridHeight: CGFloat, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            hGridCount: hGridCount,
            spacing: MosaicGridSpacing(h: hSpacing, v: vSpacing),
            gridHeight: gridHeight,
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Both horizontal and vertical minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @inlinable init(gridSize: CGSize, minimumSpacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(spacings: minimumSpacing),
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumSpacing: Both horizontal and vertical minimum spacing on each grid.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(gridSize: CGSize, minimumSpacing: CGFloat, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(spacings: minimumSpacing),
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumHSpacing: Horizontal minimum spacing on each grid.
    ///   - minimumVSpacing: Vertical minimum spacing on each grid.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @inlinable init(gridSize: CGSize, minimumHSpacing: CGFloat = .zero, minimumVSpacing: CGFloat = .zero, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(h: minimumHSpacing, v: minimumVSpacing),
            content: content
        )
    }
    
    /// Initialize Vertical Mosaic Grid View.
    /// It will use `gridSize` as the size of a single grid
    /// If `minimumSpacing` is provided, it will add it to the calculation to make sure each grid has a minimum spacing from each other.
    /// `content` will be used to get the view to be arranged by the Mosaic Grid View
    /// - Parameters:
    ///   - gridSize: Static size of a single grid.
    ///   - minimumHSpacing: Horizontal minimum spacing on each grid.
    ///   - minimumVSpacing: Vertical minimum spacing on each grid.
    ///   - useCompatLayout: When true, always use the compatibility layout implementation.
    ///   - content: the view that will be used as this Mosaic Grid Content
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable init(gridSize: CGSize, minimumHSpacing: CGFloat = .zero, minimumVSpacing: CGFloat = .zero, useCompatLayout: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.init(
            gridSize: gridSize,
            minimumSpacing: MosaicGridSpacing(h: minimumHSpacing, v: minimumVSpacing),
            useCompatLayout: useCompatLayout,
            content: content
        )
    }
}
