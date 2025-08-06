import Foundation

struct SegmentTree<Element> {
    typealias TreeIndex = [Element?].Index
    typealias Index = [Element].Index
    
    private let count: Int
    private var tree: [Element?]
    private let merge: (Element?, Element?) -> Element?
    
    init(_ array: [Element], merge: @escaping (Element?, Element?) -> Element?) {
        self.count = array.count
        self.tree = Array(repeating: nil, count: array.count * 4)
        self.merge = merge
        
        build(array, 0, 0, array.count - 1)
    }
    
    func query(lowerBound: Index, upperBound: Index) -> Element? {
        query(0, 0, count - 1, lowerBound, upperBound)
    }
    
    mutating func update(_ value: Element, at index: Int) {
        updateValue(0, 0, count - 1, index, value)
    }
    
    private mutating func build(
        _ array: [Element],
        _ treeIdx: TreeIndex,
        _ lo: Index,
        _ hi: Index
    ) {
        guard lo != hi else {
            tree[treeIdx] = array[lo]
            return
        }

        let mid = lo + (hi - lo) / 2
        build(array, 2 * treeIdx + 1, lo, mid);
        build(array, 2 * treeIdx + 2, mid + 1, hi);

        tree[treeIdx] = merge(tree[2 * treeIdx + 1], tree[2 * treeIdx + 2]);
    }
    
    private func query(
        _ treeIdx: TreeIndex,
        _ lo: Index,
        _ hi: Index,
        _ i: Index,
        _ j: Index
    ) -> Element? {
        guard j >= lo && i <= hi else { return nil }
        guard i > lo || j < hi else { return tree[treeIdx] }

        let mid = lo + (hi - lo) / 2
        
        if i > mid {
            return query(2 * treeIdx + 2, mid + 1, hi, i, j)
        } else if j <= mid {
            return query(2 * treeIdx + 1, lo, mid, i, j)
        }

        let leftQuery = query(2 * treeIdx + 1, lo, mid, i, mid);
        let rightQuery = query(2 * treeIdx + 2, mid + 1, hi, mid + 1, j);

        return merge(leftQuery, rightQuery);
    }
    
    private mutating func updateValue(
        _ treeIdx: TreeIndex,
        _ lo: Index,
        _ hi: Index,
        _ arrIdx: Index,
        _ value: Element
    ) {
        guard lo != hi else {
            tree[treeIdx] = value
            return
        }

        let mid = lo + (hi - lo) / 2

        if (arrIdx > mid) {
            updateValue(2 * treeIdx + 2, mid + 1, hi, arrIdx, value)
        } else if arrIdx <= mid {
            updateValue(2 * treeIdx + 1, lo, mid, arrIdx, value)
        }
        
        tree[treeIdx] = merge(tree[2 * treeIdx + 1], tree[2 * treeIdx + 2]);
    }
}

extension SegmentTree: CustomDebugStringConvertible {
    var debugDescription: String {
        tree.map { $0.map { "\($0)"} ?? "nil" }.joined(separator: ", ")
    }
}
