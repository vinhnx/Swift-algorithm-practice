// linked list
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Linked%20List

class Node<T> {
    var value: T
    var next: Node?
    weak var previous: Node? // circular reference, one need to be weaker than the other

    init(_ value: T) {
        self.value = value
    }
}

class LinkedList<T> {
    var head: Node<T>?

    var first: Node<T>? { return head }

    var last: Node<T>? {
        guard var node = head else { return nil }

        // keep looping until `node.next` is nil
        while let next = node.next { node = next }

        return node
    }

    var isEmpty: Bool { return head == nil }

    var count: Int {
        guard var node = head else { return 0 }
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }

        return count
    }

    func insert(_ node: Node<T>, index: Int) {
        if index == 0 {
            node.next = head
            head?.previous = node
            head = node
        } else {
            let previous = self.node(index - 1)
            let next = previous.next

            node.previous = previous
            node.next = previous.next
            previous.next = node
            next?.previous = node
        }
    }

    func insert(_ value: T, index: Int) {
        let node = Node(value)
        insert(node, index: index)
    }

    func append(_ value: T) {
        let newNode = Node(value)

        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }

    subscript(index: Int) -> T {
        return node(index).value
    }

    func node(_ index: Int) -> Node<T> {
        guard index != 0 else { return head! }

        var node = head?.next
        for _ in 1..<index {
            node = node?.next
            if node == nil { break }
        }

        return node!
    }

    func removeAll() {
        head = nil
    }

    func remove(_ node: Node<T>) -> T {
        let previous = node.previous
        let next = node.next

        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }

        next?.previous = previous

        node.previous = nil
        node.next = nil

        return node.value
    }

    func removeLast() -> T {
        assert(isEmpty == false)
        return remove(last!)
    }

    func removeAt(_ index: Int) -> T {
        let node = self.node(index)
        return remove(node)
    }

    func reverse() {
        var node = head
        // tail = node // if you had a tail pointer

        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }

    func map<V>(f: (T) -> V) -> LinkedList<V> {
        let result = LinkedList<V>()

        var node = head
        while node != nil {
            let val = node!.value
            result.append(f(val))
            node = node!.next
        }

        return result
    }

    func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()

        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(node!.value)
            }

            node = node!.next
        }

        return result
    }
}

let list = LinkedList<String>()
// list.first
// list.isEmpty
list.append("foo")
list.first?.value
// list.isEmpty
list.append("bar")
list.last?.value
// list.isEmpty

list.first?.previous == nil
list.first?.next?.value == "bar"
list.last?.next == nil
list.last?.previous?.value == "foo"

list.count

list.node(0).value
list[0]
list.node(1).value
list[1]

list.insert(Node("Vinh"), index: 1)
list.insert("Nguyen", index: 2)
list[0]
list[1]
list[2]
list[3]

if let first = list.first {
    list.remove(first)
    list.count
    list[0]
    list[1]
    list[2]
}

list.removeLast()
list.count
list[0]

list.removeAt(0)
list.count

list.map { e in e.count }
list.filter { e in e.count > 3 }

// stack (think: stack of books)
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Stack
struct Stack<T> {
    private var array: [T] = [T]()

    var isEmpty: Bool { return array.isEmpty }
    var count: Int { return array.count }
    var top: T? { return array.last }

    mutating func push(_ e: T) {
        array.append(e)
    }

    mutating func pop() -> T? {
        return array.popLast()
    }
}

// insertion sort
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Insertion%20Sort
extension Array where Element == Int {
    func insertionSort() -> [Int] {
        var copy = self

        // O(n^2)
        // because two nested loops (for and while)

        for i in 1..<copy.count {
            var y = i

            while y > 0, copy[y] < copy[y - 1] {
                copy.swapAt(y - 1, y)
                y -= 1
            }
        }

        return copy
    }
}

let input = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
input.insertionSort()

// queue (pipe)
// first come, first serve
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue
struct Queue<T> {
    private var array = [T]()

    var isEmpty: Bool {
        return array.isEmpty
    }

    var count: Int {
        return array.count
    }

    var first: T? {
        return array.first
    }

    var last: T? {
        return array.last
    }

    mutating func enqueue(_ element: T) {
        // O(1) because array always add new element at the end of array
        array.append(element)
    }

    mutating func dequeue() -> T? {
        guard array.isEmpty == false else { return nil }
        return array.removeLast()
    }
}

var q = Queue<String>()
q.enqueue("a")
q.enqueue("z")
q.count
q.first
q.last
q.dequeue()
q.count
q.first
q.last

// graph
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Graph
struct Edge<T>: Equatable where T: Equatable & Hashable {
    let from: Vertex<T>
    let to: Vertex<T>
    let weight: Double?
}

struct Vertex<T>: Equatable where T: Equatable & Hashable {
    var data: T
    let index: Int
}

class EdgeList<T> where T: Equatable & Hashable {
    var vertex: Vertex<T>
    var edges: [Edge<T>]?

    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }

    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }
}

// tree
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Tree
class TreeNode<T> {
    var value: T
    weak var parent: TreeNode?
    var children = [TreeNode<T>]()

    init(value: T) {
        self.value = value
    }

    func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        var s = "\(value)"
        if !children.isEmpty {
            s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return s
    }
}

extension TreeNode where T: Equatable {
    func search(_ value: T) -> TreeNode? {
        if value == self.value { return self }

        for child in children {
            guard let result = child.search(value) else { continue }
            return result
        }

        return nil
    }
}

let tree = TreeNode<String>(value: "beverages")
let hotNode = TreeNode<String>(value: "hot")
let coldNode = TreeNode<String>(value: "cold")
let teaNode = TreeNode<String>(value: "tea")
let coffeeNode = TreeNode<String>(value: "coffee")
let chocolateNode = TreeNode<String>(value: "cocoa")
let blackTeaNode = TreeNode<String>(value: "black")
let greenTeaNode = TreeNode<String>(value: "green")
let chaiTeaNode = TreeNode<String>(value: "chai")
let sodaNode = TreeNode<String>(value: "soda")
let milkNode = TreeNode<String>(value: "milk")
let gingerAleNode = TreeNode<String>(value: "ginger ale")
let bitterLemonNode = TreeNode<String>(value: "bitter lemon")

tree.addChild(hotNode)
tree.addChild(coldNode)

hotNode.addChild(teaNode)
hotNode.addChild(coffeeNode)
hotNode.addChild(chocolateNode)

coldNode.addChild(sodaNode)
coldNode.addChild(milkNode)

teaNode.addChild(blackTeaNode)
teaNode.addChild(greenTeaNode)
teaNode.addChild(chaiTeaNode)

sodaNode.addChild(gingerAleNode)
sodaNode.addChild(bitterLemonNode)

tree.search("cocoa") // returns the "cocoa" node
tree.search("chai") // returns the "chai" node
tree.search("bubbly") // nil

// binary tree
// > a `tree` where each node has 0, 1 or 2 children
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Tree
indirect enum BinaryTree<T> {
    case node(BinaryTree<T>, T, BinaryTree<T>)
    case empty
}

extension BinaryTree {
    var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty:
            return 0
        }
    }

    func traverseInOrder(_ handler: (T) -> Void) {
        if case let .node(left, current, right) = self {
            left.traverseInOrder(handler)
            handler(current)
            right.traverseInOrder(handler)
        }
    }

    func traversePreOrder(_ handler: (T) -> Void) {
        if case let .node(left, current, right) = self {
            handler(current)
            left.traversePreOrder(handler)
            right.traversePreOrder(handler)
        }
    }

    func traversePostOrder(_ handler: (T) -> Void) {
        if case let .node(left, current, right) = self {
            left.traversePostOrder(handler)
            right.traversePostOrder(handler)
            handler(current)
        }
    }
}

extension BinaryTree: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .node(left, value, right):
            return "value: \(value), left = [\(left.description)], right = [\(right.description)]"
        case .empty:
            return ""
        }
    }
}

// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
let binaryTree = BinaryTree.node(timesLeft, "+", timesRight)
binaryTree.count
binaryTree.traverseInOrder { value in print(value) }
print(binaryTree)

// binary search tree (sorted binary tree -- left always < right)
// > a special kind of binary tree (a tree in which has at most two children) that performs insertions and deleteions
// > such that the tree is always sorted
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree
// >>> searching:
// > + if the value is less than the current node -> take the left branch
// > + if the value is greater than the current node -> take the right branch
// > + if the value is equal to current node -> found it!
// like most tree operations, this is performed recursively until we either find what we looking for or run out of nodes to look at
// >>> searching is fast using the structure of the tree, it runs in O(h) time, where h: is the height of the tree
class BinarySearchTree<T: Comparable> {
    public private(set) var value: T
    public private(set) weak var parent: BinarySearchTree?
    public private(set) var left: BinarySearchTree?
    public private(set) var right: BinarySearchTree?

    init(_ value: T) {
        self.value = value
    }

    convenience init(_ array: [T]) {
        precondition(array.isEmpty == false)
        self.init(array.first!)

        for val in array.dropFirst() {
            insert(val)
        }
    }

    var isRoot: Bool {
        return parent == nil
    }

    var isLeaf: Bool {
        return left == nil && right == nil
    }

    var isLeftChild: Bool {
        // NOTE: pointer comparison, hence ===
        return parent?.left === self
    }

    var isRightChild: Bool {
        // NOTE: pointer comparison, hence ===
        return parent?.right === self
    }

    var hasLeftChild: Bool {
        return left != nil
    }

    var hasRightChild: Bool {
        return right != nil
    }

    var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }

    var isEmpty: Bool {
        return count > 0
    }

    var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }

    func insert(_ value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value)
            } else {
                left = BinarySearchTree(value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value)
            } else {
                right = BinarySearchTree(value)
                right?.parent = self
            }
        }
    }

    func search(_ value: T) -> BinarySearchTree? {
        // we start from root
        if value < self.value {
            return left?.search(value) // search left first
        } else if value > self.value {
            return right?.search(value) // search right
        } else {
            return self // found it self
        }
    }

    func traverseInOrder(_ handler: (T) -> Void) {
        left?.traverseInOrder(handler)
        handler(value)
        right?.traverseInOrder(handler)
    }

    func traversePreOrder(_ handler: (T) -> Void) {
        handler(value)
        left?.traversePreOrder(handler)
        right?.traversePreOrder(handler)
    }

    func traversePostOrder(_ handler: (T) -> Void) {
        left?.traversePostOrder(handler)
        right?.traversePostOrder(handler)
        handler(value)
    }

    func map(_ formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left { a += left.map(formula) }
        a.append(formula(value))
        if let right = right { a += right.map(formula) }
        return a
    }

    func toArray() -> [T] {
        return map { e in e }
    }

    func updateParentTo(_ node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }

        node?.parent = parent
    }

    func minimum() -> BinarySearchTree {
        var node = self
        while let next = node.left {
            node = next
        }

        return node
    }

    func maximum() -> BinarySearchTree {
        var node = self
        while let next = node.right {
            node = next
        }

        return node
    }

    @discardableResult
    func remove() -> BinarySearchTree? {
        let new: BinarySearchTree?

        // replacement for current node can be either biggest one on the left or smallest one on the right, whichever is not nil
        if let right = right {
            new = right.minimum()
        } else if let left = left {
            new = left.maximum()
        } else {
            new = nil
        }

        new?.remove()

        // place the replacement on current node's position
        new?.right = right
        new?.left = left
        right?.parent = new
        left?.parent = new

        updateParentTo(new)

        // the current node is no longer part of the tree, so clean it up
        parent = nil
        left = nil
        right = nil

        return new
    }

    func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }

    func depth() -> Int {
        var node = self
        var edges = 0
        while let parent = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }

    func predecessor() -> BinarySearchTree<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value { return parent }
                node = parent
            }

            return nil
        }
    }

    func successor() -> BinarySearchTree<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value { return parent }
                node = parent
            }

            return nil
        }
    }

    func isBinarySearchTree(_ min: T, max: T) -> Bool {
        if value < min || value > max { return false }
        let leftBST = left?.isBinarySearchTree(min, max: value) ?? true
        let rightBST = right?.isBinarySearchTree(value, max: max) ?? true
        return leftBST && rightBST
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}

let binarySearchTree = BinarySearchTree<Int>(8)
binarySearchTree.insert(1)
binarySearchTree.insert(3)
binarySearchTree.insert(22)
binarySearchTree.insert(9)
binarySearchTree.count

if let node1 = binarySearchTree.search(1) {
    node1.depth()
}

binarySearchTree.height()
print(binarySearchTree)

let convenienceBinarySearchTree = BinarySearchTree<Int>([9, -1, 5, 1, 3])
convenienceBinarySearchTree.traverseInOrder { value in print(value) }
convenienceBinarySearchTree.count

if let node3 = convenienceBinarySearchTree.search(3) {
    node3.depth()
}

convenienceBinarySearchTree.height()
print(convenienceBinarySearchTree)

// binary search tree as enum (value semantic)
enum BinarySearchTreeEnum<T: Comparable> {
    case empty // end of the branch
    case leaf(T) // leaf node that has no chilren
    indirect case node(BinarySearchTreeEnum, T, BinarySearchTreeEnum) // a node that has one or two chilren (indirect: recursive enum)

    var count: Int {
        switch self {
        case .empty: return 0
        case .leaf: return 1
        case let .node(left, _, right):
            return left.count + 1 + right.count
        }
    }

    var height: Int {
        switch self {
        case .empty: return -1
        case .leaf: return 0
        case let .node(left, _, right):
            return 1 + max(left.height, right.height)
        }
    }

    func insert(_ newValue: T) -> BinarySearchTreeEnum {
        switch self {
        case .empty:
            return .leaf(newValue)

        case let .leaf(value):
            if newValue < value {
                return .node(.leaf(newValue), value, .empty)
            } else {
                return .node(.empty, value, .leaf(newValue))
            }

        case let .node(left, value, right):
            if newValue < value {
                return .node(left.insert(newValue), value, right)
            } else {
                return .node(left, value, right.insert(newValue))
            }
        }
    }

    func search(_ x: T) -> BinarySearchTreeEnum? {
        switch self {
        case .empty: return nil
        case let .leaf(y):
            return (x == y) ? self : nil
        case let .node(left, y, right):
            if x < y {
                return left.search(x)
            } else if y < x {
                return right.search(x)
            } else {
                return self
            }
        }
    }
}

extension BinarySearchTreeEnum: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .empty: return "."
        case let .leaf(value): return "\(value)"
        case let .node(left, value, right):
            return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
        }
    }
}

var treeEnum = BinarySearchTreeEnum.leaf(7)
treeEnum = treeEnum.insert(2)
treeEnum = treeEnum.insert(5)
treeEnum = treeEnum.insert(10)
treeEnum = treeEnum.insert(9)
treeEnum = treeEnum.insert(1)
treeEnum.search(10)
treeEnum.search(1)
treeEnum.search(11) // nil

// binary search
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search
func binarySearch<T: Comparable>(_ array: [T], key: T, range: Range<Int>) -> Int? {
    guard range.lowerBound < range.upperBound else {
        // if we get here, then the search key is not present in the array
        return nil
    }

    // calculate where to split the array
    let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

    // if the search key in the left half?
    if array[midIndex] > key {
        return binarySearch(array, key: key, range: range.lowerBound..<midIndex)
    } else if array[midIndex] < key { // is the search key in the right half
        return binarySearch(array, key: key, range: midIndex + 1..<range.upperBound)
    } else {
        return midIndex // found the search key
    }
}

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
assert(binarySearch(numbers, key: 3, range: 0..<numbers.count) == 1)

// quick sort
// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Quicksort
extension Array where Element: Comparable {
    func quickSort() -> [Element] {
        guard count > 1 else { return self }
        let pivot = self[self.count / 2]
        let lhs = filter { $0 < pivot }
        let equal = filter { $0 == pivot }
        let rhs = filter { $0 > pivot }
        return lhs.quickSort() + equal + rhs.quickSort()
    }
}

[10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26].quickSort()
