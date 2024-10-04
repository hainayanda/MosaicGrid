//
//  CGSize+Extensions.swift
//  Pods
//
//  Created by Nayanda Haberty on 4/10/24.
//

import SwiftUI

extension CGSize {
    @inlinable func withSpacing(_ spacing: MosaicGridSpacing) -> CGSize {
        return CGSize(width: width + spacing.horizontal, height: height + spacing.vertical)
    }
}
