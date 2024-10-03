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
    
    init<S: Sequence>(_ sequence: S, sortBy sorter: @escaping (Element, Element) -> Bool) where S.Element == Element {
        self.sorter = sorter
        set = Set(sequence.map { ElementContainer(content: $0) })
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    init(_ elements: Element..., sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.sorter = sorter
        set = Set(elements.map { ElementContainer(content: $0) })
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    init(sortBy sorter: @escaping (Element, Element) -> Bool) {
        self.sorter = sorter
        set = Set()
        sortedElements = []
    }
    
    mutating func insert(_ element: Element) {
        let countBefore = set.count
        set.insert(ElementContainer(content: element))
        guard countBefore < set.count else { return }
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
    
    mutating func remove(_ element: Element) {
        let countBefore = set.count
        set.remove(ElementContainer(content: element))
        guard countBefore > set.count else { return }
        sortedElements = set.sorted { sorter($0.content, $1.content) }
    }
}

extension SortedSet: Sequence {
    
    func makeIterator() -> Iterator {
        sortedElements.lazy.map(\.content).makeIterator()
    }
    
    var underestimatedCount: Int {
        sortedElements.underestimatedCount
    }
}

extension SortedSet: RandomAccessCollection {
    subscript(position: Int) -> Element {
        sortedElements[position].content
    }
    
    var startIndex: Int {
        sortedElements.startIndex
    }
    
    var endIndex: Int {
        sortedElements.endIndex
    }
    
    func index(after i: Int) -> Int {
        sortedElements.index(after: i)
    }
}

extension SortedSet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.set)
    }
    
    static func == (lhs: SortedSet<Element>, rhs: SortedSet<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return lhs.sortedElements == rhs.sortedElements
    }
    
}

extension SortedSet {
    class ElementContainer: Hashable {
        
        let content: Element
        
        init(content: Element) {
            self.content = content
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(content)
        }
        
        static func == (lhs: SortedSet<Element>.ElementContainer, rhs: SortedSet<Element>.ElementContainer) -> Bool {
            lhs.content == rhs.content
        }
    }
}

extension SortedSet where Element: Comparable {
    enum Sorting {
        case ascending
        case descending
    }
    
    init<S: Sequence>(_ sorting: Sorting, _ sequence: S) where S.Element == Element {
        self.init(sequence) { lhs, rhs in
            switch sorting {
            case .ascending: return lhs < rhs
            case .descending: return lhs > rhs
            }
        }
    }
    
    init(_ sorting: Sorting, _ elements: Element...) {
        self.init(sorting, elements)
    }
    
}
