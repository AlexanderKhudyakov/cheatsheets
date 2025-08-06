import Testing
@testable import CheatSheets

@Suite
struct SegmentTreeTests {
    @Test
    func testSumSegmentTree() {
        let array = [1, 2, 3, 4, 5]
        var tree = SegmentTree(array, merge: { a, b in
            if let a = a, let b = b {
                return a + b
            }
            return a ?? b
        })

        #expect(tree.query(lowerBound: 0, upperBound: 4) == 15)
        #expect(tree.query(lowerBound: 1, upperBound: 3) == 9)

        tree.update(10, at: 2) // array becomes [1, 2, 10, 4, 5]
        #expect(tree.query(lowerBound: 0, upperBound: 4) == 22)
        #expect(tree.query(lowerBound: 2, upperBound: 2) == 10)
    }

    @Test
    func testMinSegmentTree() {
        let array = [8, 6, 4, 2, 10]
        var tree = SegmentTree(array, merge: { a, b in
            if let a = a, let b = b {
                return min(a, b)
            }
            return a ?? b
        })

        #expect(tree.query(lowerBound: 0, upperBound: 4) == 2)
        #expect(tree.query(lowerBound: 0, upperBound: 2) == 4)

        tree.update(1, at: 1)
        #expect(tree.query(lowerBound: 0, upperBound: 2) == 1)
    }

    @Test
    func testMaxSegmentTree() {
        let array = [3, 1, 4, 1, 5, 9]
        var tree = SegmentTree(array, merge: { a, b in
            if let a = a, let b = b {
                return max(a, b)
            }
            return a ?? b
        })

        #expect(tree.query(lowerBound: 0, upperBound: 5) == 9)
        #expect(tree.query(lowerBound: 1, upperBound: 3) == 4)

        tree.update(10, at: 2)
        #expect(tree.query(lowerBound: 0, upperBound: 5) == 10)
    }

    @Test
    func testSingleElementArray() {
        let array = [42]
        let tree = SegmentTree(array, merge: { a, b in a ?? b })

        #expect(tree.query(lowerBound: 0, upperBound: 0) == 42)
    }

    @Test
    func testAllSameElements() {
        let array = [7, 7, 7, 7]
        var tree = SegmentTree(array, merge: { a, b in
            if let a = a, let b = b {
                return a + b
            }
            return a ?? b
        })

        #expect(tree.query(lowerBound: 0, upperBound: 3) == 28)
        tree.update(0, at: 1)
        #expect(tree.query(lowerBound: 0, upperBound: 3) == 21)
    }
}
