//
//  Mutable.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation

@propertyWrapper
final class Mutable<Property> {
    
    var wrappedValue: Property
    
    @inlinable init(wrappedValue: Property) {
        self.wrappedValue = wrappedValue
    }
}
