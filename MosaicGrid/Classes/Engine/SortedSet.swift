//
//  SortedSet.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 3/10/24.
//

import Foundation

struct SortedSet<Element: Hashable> {
    
    typealias Iterator = Array<Element>.Iterator
    
    private var sortedElements: [ElementContainer]
    private var set: Set<ElementContainer>
    private let sorter: (Element, Element) -> Bool
    
    @inlinable init<S: Sequence>(_ sequence: S, sortBy sorter: @escaping (Element, Element) -> Bool) where S.Element == Element {
        self.sorter = sorter
        set = Set(sequence.map { ElementContainer(content: $0) })
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    @inlinable init(_ elements: Element..., sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.sorter = sorter
        set = Set(elements.map { ElementContainer(content: $0) })
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    @inlinable init(sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.sorter = sorter
        set = Set()
        sortedElements = []
    }
    
    @inlinable mutating func insert(_ element: Element) {
        let countBefore = set.count
        set.insert(ElementContainer(content: element))
        guard countBefore < set.count else { return }
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    @inlinable mutating func remove(_ element: Element) {
        let countBefore = set.count
        set.remove(ElementContainer(content: element))
        guard countBefore > set.count else { return }
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
}

// MARK: - SortedSet + ElementContainer

extension SortedSet {
    final class ElementContainer: Hashable {
        
        let content: Element
        
        @inlinable init(content: Element) {
            self.content = content
        }
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(content)
        }
        
        @inlinable static func == (lhs: SortedSet<Element>.ElementContainer, rhs: SortedSet<Element>.ElementContainer) -> Bool {
            lhs.content == rhs.content
        }
    }
}

// MARK: - SortedSet + Sequence

extension SortedSet: Sequence {
    
    @inlinable func makeIterator() -> Iterator {
        sortedElements.lazy.map(\.content).makeIterator()
    }
    
    @inlinable var underestimatedCount: Int {
        sortedElements.underestimatedCount
    }
}

// MARK: - SortedSet + RandomAccessCollection

extension SortedSet: RandomAccessCollection {
    @inlinable subscript(position: Int) -> Element {
        sortedElements[position].content
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

// MARK: - SortedSet + Hashable

extension SortedSet: Hashable {
    
    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(self.set)
    }
    
    @inlinable static func == (lhs: SortedSet<Element>, rhs: SortedSet<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return lhs.sortedElements == rhs.sortedElements
    }
    
}

// MARK: - SortedSet + Comparable

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
