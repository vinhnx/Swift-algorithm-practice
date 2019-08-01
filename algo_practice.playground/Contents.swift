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

    var first: Node<T>? {
        return head
    }

    var last: Node<T>? {
        guard var node = head else { return nil }

        // keep looping until `node.next` is nil
        while let next = node.next { node = next }

        return node
    }

    var isEmpty: Bool {
        return head == nil
    }

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
