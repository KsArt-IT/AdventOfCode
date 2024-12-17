//
//  main.swift
//  2024_16_1
//
//  Created by KsArT on 16.12.2024.
//

import Foundation

let inputTest = """
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"""
// 7036, 45
let inputTest1 = """
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
"""
// 11048, 64

struct Point: Hashable {
    let x: Int
    let y: Int

    static func +(lhs: Point, rhs: Direction) -> Point {
        let dir = rhs.move()
        return Point(x: lhs.x + dir.x, y: lhs.y + dir.y)
    }
}

struct State: Hashable {
    let position: Point
    let direction: Direction // 0 = East, 1 = South, 2 = West, 3 = North
    let cost: Int
}

enum Direction: Int, Hashable, CaseIterable {
    case east
    case south
    case west
    case north

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

    func cost(_ direction: Direction) -> Int {
        self != direction ? 1001 : 1
    }
}

let startSymbol: Character = "S"
let endSymbol: Character = "E"
let wallSymbol: Character = "#"

// MARK: - Start
let map = parseInput(inputTest)
let (start, end) = findStartAndEndPoints(map)
if let start, let end {
    let result = findPath(on: map, start: start, end: end)
    print(result)
} else {
    print("Starting position '\(startSymbol)' or end '\(endSymbol)' not found!")
}

// MARK: - Func
func findPath(on map: [[Character]], start: Point, end: Point) -> Int {
    var queue: [State] = [State(position: start, direction: .east, cost: 0)]

    var visited = map.map { row in
        row.map { _ in
            Direction.allCases.map { _ in Int.max }
        }
    }

    var minCost = Int.max

    // bfs
    while let state = queue.popLast()  {
        guard state.cost <= minCost else { continue }

        // если это финиш
        if state.position == end {
            minCost = min(minCost, state.cost)
            continue
        }

        guard visited[state.position.y][state.position.x][state.direction.rawValue] >= state.cost else { continue }
        visited[state.position.y][state.position.x][state.direction.rawValue] = state.cost

        for direction in Direction.allCases {
            guard direction != state.direction.reverse() else { continue }

            let nextPosition = state.position + direction
            if map[nextPosition.y][nextPosition.x] != wallSymbol || nextPosition == end {
                queue.insert(
                    State(
                        position: nextPosition,
                        direction: direction,
                        cost: state.cost + direction.cost(state.direction)
                    ),
                    at: 0
                )
            }
        }
    }

    return minCost
}

func parseInput(_ input: String) -> [[Character]] {
    input.split(separator: "\n").map { Array($0) }
}

func findStartAndEndPoints(_ map: [[Character]]) -> (Point?, Point?) {
    var start: Point?
    var end: Point?

    for (y, row) in map.enumerated() {
        for (x, cell) in row.enumerated() {
            if cell == startSymbol { start = Point(x: x, y: y) }
            if cell == endSymbol { end = Point(x: x, y: y) }
        }
        if start != nil && end != nil {
            break
        }
    }

    return (start, end)
}
