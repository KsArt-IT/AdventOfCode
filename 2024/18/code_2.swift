//
//  main.swift
//  2024_18_2
//
//  Created by KsArT on 18.12.2024.
//

import Foundation

let inputTest = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
"""
// 22
// 6,1

enum Direction: Int, Hashable, CaseIterable {
    case east // east right
    case south // south down
    case west // west left
    case north // north up

    var x: Int {
        switch self {
        case .east: 1 // east right
        case .south: 0 // south down
        case .west: -1 // west left
        case .north: 0 // north up
        }
    }
    var y: Int {
        switch self {
        case .east: 0 // east right
        case .south: 1 // south down
        case .west: 0 // west left
        case .north: -1 // north up
        }
    }

    func move() -> Point {
        switch self {
        case .east: Point(x: 1, y: 0) // east right
        case .south: Point(x: 0, y: 1) // south down
        case .west: Point(x: -1, y: 0) // west left
        case .north: Point(x: 0, y: -1) // north up
        }
    }

    func reverse() -> Self {
        switch self {
        case .east: .west
        case .south: .north
        case .west: .east
        case .north: .south
        }
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int

    func neighbors(in gridSize: Int) -> [Point] {
        Direction.allCases
            .map { self + $0 }
            .filter { $0.isValid(in: gridSize) }
    }

    func isValid(in gridSize: Int) -> Bool {
        0..<gridSize ~= x && 0..<gridSize ~= y
    }

    static func +(lhs: Point, rhs: Direction) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: - Start
let sizeTest = 7 // 0...6
let sizeWork = 71 // 0...70

let maxBytesTest = 12
let maxBytesWork = 1024

// test or work
let isWork = true
let (input, size, maxBytes) = if isWork {
    (inputWork, sizeWork, maxBytesWork)
} else {
    (inputTest, sizeTest, maxBytesTest)
}

let date = Date.now

let blockedPoints = parseInput(input)
let start = Point(x: 0, y: 0)
let end = Point(x: size - 1, y: size - 1)

if let result = findShortestPath(start: start, end: end, gridSize: size, blocked: blockedPoints.prefix(maxBytes)) {
    print(result)
} else {
    print("No path found")
}
if let result = findFirstBlocked(start: start, end: end, gridSize: size, blocked: blockedPoints, first: maxBytes) {
    print("\(result.x),\(result.y)")
} else {
    print("No coordinates found")
}
print("\ntime: \(Date.now.timeIntervalSince(date))")

// MARK: - Func
// BFS
func findShortestPath(start: Point, end: Point, gridSize: Int, blocked: Array<Point>.SubSequence) -> Int? {
    var queue: [(Point, Int)] = [(start, 0)]
    var visited: Set<Point> = [start]

    var step = 0

    while let (current, steps) = queue.popLast() {
        step += 1
        print("step: \(step)")
        guard current != end else { return steps }

        for neighbor in current.neighbors(in: gridSize) {
            guard !visited.contains(neighbor), !blocked.contains(neighbor) else { continue }
            visited.insert(neighbor)

            queue.insert((neighbor, steps + 1), at: 0)
        }
    }

    return nil
}

func findFirstBlocked(start: Point, end: Point, gridSize: Int, blocked: [Point], first: Int = 0) -> Point? {
    var startIndex = first
    var endIndex = blocked.count - 1

    while startIndex < endIndex {
        let midIndex = (startIndex + endIndex) / 2
        if isBlocked(midIndex) {
            endIndex = midIndex
        } else {
            startIndex = midIndex + 1
        }
    }
    guard 0..<blocked.count ~= startIndex else { return nil }

    return blocked[startIndex - 1]

    func isBlocked(_ last: Int) -> Bool {
        findShortestPath(start: start, end: end, gridSize: gridSize, blocked: blocked.prefix(last)) == nil
    }
}

// MARK: - Parse
func parseInput(_ input: String) -> [Point] {
    let numbers = input.components(separatedBy: [",", "\n"]).compactMap(Int.init)
    guard numbers.count > 1, numbers.count % 2 == 0 else { return [] }
    return stride(from: 0, to: numbers.count, by: 2).map { Point(x: numbers[$0], y: numbers[$0 + 1]) }
}
