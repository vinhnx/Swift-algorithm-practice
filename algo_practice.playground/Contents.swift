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
