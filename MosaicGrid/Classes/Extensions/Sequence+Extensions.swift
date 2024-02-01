//
//  Sequence+Extensions.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 4/2/23.
//

import Foundation

// MARK: Sequence + Extensions

@usableFromInline enum ControlResult<Value> {
    case result(Value)
    case stop
    case stopWith(result: Value)
    case ignore
}

extension Sequence {
    @inlinable func controlableReduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> ControlResult<Result>) rethrows -> Result {
        var temporaryResult: Result = initialResult
        for element in self {
            let controlableResult = try nextPartialResult(temporaryResult, element)
            switch controlableResult {
            case .result(let newResult):
                temporaryResult = newResult
            case .stop:
                return temporaryResult
            case .stopWith(let result):
                return result
            case .ignore:
                continue
            }
        }
        return temporaryResult
    }
}

// MARK: Array + Extensions

extension Array {
    @inlinable subscript(safe index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
