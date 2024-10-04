//
//  Mutable.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 7/2/23.
//

import Foundation

@propertyWrapper
class Mutable<Property> {
    
    var wrappedValue: Property
    
    @inlinable init(wrappedValue: Property) {
        self.wrappedValue = wrappedValue
    }
}
