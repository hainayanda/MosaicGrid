
import XCTest
@testable import MosaicGrid

class MosaicGridCoordinateSequenceTests: XCTestCase {
    
    func test_givenSequence_whenIterateTwice_thenItShouldProduceSameResult() {
        let size = MosaicGridSize(width: 3, height: 2)
        let start = MosaicGridCoordinate(x: 1, y: 1)
        let sequence = MosaicGridCoordinateSequence(startFrom: start, size: size)
        
        // Pass 1
        var pass1: [MosaicGridCoordinate] = []
        for coord in sequence {
            pass1.append(coord)
        }
        
        // Pass 2
        var pass2: [MosaicGridCoordinate] = []
        for coord in sequence {
            pass2.append(coord)
        }
        
        // Assertions
        XCTAssertEqual(pass1.count, 6)
        XCTAssertEqual(pass1, pass2, "Sequence should be multi-pass")
        
        let expected = [
            MosaicGridCoordinate(x: 1, y: 1), MosaicGridCoordinate(x: 2, y: 1), MosaicGridCoordinate(x: 3, y: 1),
            MosaicGridCoordinate(x: 1, y: 2), MosaicGridCoordinate(x: 2, y: 2), MosaicGridCoordinate(x: 3, y: 2)
        ]
        
        XCTAssertEqual(pass1, expected)
    }
    
    func test_givenSequence_whenIterate_thenItShouldRespectBounds() {
        let size = MosaicGridSize(width: 2, height: 2)
        let start = MosaicGridCoordinate(x: 0, y: 0)
        let sequence = MosaicGridCoordinateSequence(startFrom: start, size: size)
        
        let array = Array(sequence)
        
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(array[0], MosaicGridCoordinate(x: 0, y: 0))
        XCTAssertEqual(array[3], MosaicGridCoordinate(x: 1, y: 1))
    }
    
    func test_givenZeroSize_whenIterate_thenItShouldReturnEmpty() {
        let size = MosaicGridSize(width: 0, height: 3)
        let start = MosaicGridCoordinate(x: 5, y: 5)
        let sequence = MosaicGridCoordinateSequence(startFrom: start, size: size)
        
        XCTAssertTrue(Array(sequence).isEmpty)
    }
}
