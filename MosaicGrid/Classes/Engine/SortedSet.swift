//
//  SortedSet.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 3/10/24.
//

import Foundation

struct SortedSet<Element: Hashable> {

    typealias Iterator = Array<Element>.Iterator

    private var sortedElements: [Element]
    private var set: Set<Element>
    private let sorter: (Element, Element) -> Bool

    @inlinable init<S: Sequence>(_ sequence: S, sortBy sorter: @escaping (Element, Element) -> Bool) where S.Element == Element {
        self.sorter = sorter
        let unique = Set(sequence)
        self.set = unique
        self.sortedElements = unique.sorted(by: sorter)
    }

    @inlinable init(_ elements: Element..., sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.init(elements, sortBy: sorter)
    }

    @inlinable init(sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.sorter = sorter
        self.set = Set()
        self.sortedElements = []
    }

    @inlinable mutating func insert(_ element: Element) {
        let (inserted, _) = set.insert(element)
        guard inserted else { return }
        let insertionIndex = indexForInsertion(of: element)
        sortedElements.insert(element, at: insertionIndex)
    }

    @inlinable mutating func remove(_ element: Element) {
        guard set.remove(element) != nil else { return }
        if let index = index(of: element) {
            sortedElements.remove(at: index)
        }
    }

    @inlinable func contains(_ element: Element) -> Bool {
        set.contains(element)
    }

    // MARK: Private Helpers

    @inlinable func indexForInsertion(of element: Element) -> Int {
        var low = 0
        var high = sortedElements.count
        while low < high {
            let mid = (low + high) / 2
            if sorter(sortedElements[mid], element) {
                low = mid + 1
            } else {
                high = mid
            }
        }
        return low
    }

    @inlinable func index(of element: Element) -> Int? {
        var low = 0
        var high = sortedElements.count
        while low < high {
            let mid = (low + high) / 2
            let midElement = sortedElements[mid]
            if sorter(midElement, element) {
                low = mid + 1
            } else if sorter(element, midElement) {
                high = mid
            } else {
                return mid
            }
        }
        return nil
    }
}

extension SortedSet: Sequence {

    @inlinable func makeIterator() -> Iterator {
        sortedElements.makeIterator()
    }

    @inlinable var underestimatedCount: Int {
        sortedElements.underestimatedCount
    }
}

extension SortedSet: RandomAccessCollection {
    @inlinable subscript(position: Int) -> Element {
        sortedElements[position]
    }

    @inlinable var startIndex: Int {
        sortedElements.startIndex
    }

    @inlinable var endIndex: Int {
        sortedElements.endIndex
    }

    @inlinable func index(after i: Int) -> Int {
        sortedElements.index(after: i)
    }
}

extension SortedSet: Hashable {

    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(sortedElements)
    }

    @inlinable static func == (lhs: SortedSet<Element>, rhs: SortedSet<Element>) -> Bool {
        lhs.sortedElements == rhs.sortedElements
    }

}

extension SortedSet where Element: Comparable {
    enum Sorting {
        case ascending
        case descending
    }
    
    @inlinable init<S: Sequence>(_ sorting: Sorting, _ sequence: S) where S.Element == Element {
        self.init(sequence) { lhs, rhs in
            switch sorting {
            case .ascending: return lhs < rhs
            case .descending: return lhs > rhs
            }
        }
    }
    
    @inlinable init(_ sorting: Sorting, _ elements: Element...) {
        self.init(sorting, elements)
    }
    
}
