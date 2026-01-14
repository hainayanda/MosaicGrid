//
//  MosaicGridCompatRoot.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import SwiftUI

struct MosaicGridCompatRoot: _VariadicView_MultiViewRoot {

    let orientation: GridOrientation
    let spacing: MosaicGridSpacing
    let gridSizing: MosaicGridSizing

    func body(children: _VariadicView.Children) -> some View {
        switch gridSizing {
        case .flow(let alignment):
            FlowMosaicGridCompatWrapper(
                children: children,
                orientation: orientation,
                spacing: spacing,
                alignment: alignment
            )
        default:
            MosaicGridCompatContent(
                children: children,
                orientation: orientation,
                spacing: spacing,
                gridSizing: gridSizing
            )
        }
    }

    // MARK: - Calculation Methods for Testing

    func calculateGridSize(basedOn proposal: CGSize) -> CGSize {
        switch gridSizing {
        case .constantSize(let size):
            return size

        case .constantAxis(let dimension, let crossGridCount):
            return calculateAxisDimensionGridSize(proposal: proposal, dimension: dimension, count: crossGridCount)

        case .aspectRatio(let ratio, let crossGridCount):
            return calculateAspectRatioGridSize(proposal: proposal, ratio: ratio, count: crossGridCount)

        case .flow:
            return .zero
        }
    }

    func calculateAxisDimensionGridSize(proposal: CGSize, dimension: CGFloat, count: Int) -> CGSize {
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard count > 0 else { return .zero }

        let usedDimension = axisDimension - (crossAxisSpacing * CGFloat(count - 1))
        let calculatedGridDimension = usedDimension / CGFloat(count)

        return orientation == .vertical
        ? CGSize(width: calculatedGridDimension, height: dimension)
        : CGSize(width: dimension, height: calculatedGridDimension)
    }

    func calculateAspectRatioGridSize(proposal: CGSize, ratio: Double, count: Int) -> CGSize {
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard count > 0 else { return .zero }

        let usedDimension = axisDimension - (crossAxisSpacing * CGFloat(count - 1))
        let calculatedGridDimension = usedDimension / CGFloat(count)

        switch orientation {
        case .vertical:
            return CGSize(width: calculatedGridDimension, height: calculatedGridDimension / ratio)
        case .horizontal:
            return CGSize(width: calculatedGridDimension * ratio, height: calculatedGridDimension)
        }
    }

    func calculateCrossCount(for proposal: CGSize) -> Int {
        switch gridSizing {
        case .constantAxis(_, let count): return count
        case .aspectRatio(_, let count): return count
        case .constantSize:
            return calculateDynamicCrossCount(proposal: proposal)
        case .flow: return 1
        }
    }

    func calculateDynamicCrossCount(proposal: CGSize) -> Int {
        guard case .constantSize(let size) = gridSizing else { return 1 }

        let gridAxisDimension = size.axisDimension(for: orientation.cross)
        let axisDimension = proposal.axisDimension(for: orientation.cross)
        let crossAxisSpacing = spacing.axisSpacing(for: orientation.cross)

        guard gridAxisDimension > 0 else { return 1 }

        return max(1, Int((axisDimension + crossAxisSpacing) / (gridAxisDimension + crossAxisSpacing)))
    }
}
