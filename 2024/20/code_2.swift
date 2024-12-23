//
//  main.swift
//  2024_20_2
//
//  Created by KsArT on 20.12.2024.
//

import Foundation

let inputTest = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""
// 1
// 285

let inputWork = """
####
#SE#
####
"""

final class RaceCondition {
    let task = "2024.20.2"
    let taskName = "Race Condition"

    struct Point: Hashable {
        let x, y: Int

        static func +(lhs: Point, rhs: Direction) -> Point {
            Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
        }

        func neighbors() -> [Point] {
            Direction.allCases.map { self + $0 }
        }

        func distance(to other: Point) -> Int {
            abs(x - other.x) + abs(y - other.y)
        }
    }

    enum Direction: CaseIterable {
        // right, down, left, up
        case east, south, west, north

        var dx: Int { self == .east ? 1 : self == .west ? -1 : 0 }
        var dy: Int { self == .south ? 1 : self == .north ? -1 : 0 }
    }

    typealias Grid = [Point: Character]

    private let startSymbol: Character = "S"
    private let endSymbol: Character = "E"
    private let wallSymbol: Character = "#"

    private let grid: Grid
    private let start: Point
    private let end: Point
    private let cols: Int // x
    private let rows: Int // y
    private lazy var pathCosts: [[Int]] = calculatePathCosts()
    private lazy var shortestPath: Set<Point> = findShortestPath()

    // MARK: - Init
    init(input: String) {
        var tempGrid: Grid = [:]
        var start: Point?
        var end: Point?

        let lines = input.split(separator: "\n")
        for (y, row) in lines.enumerated() {
            for (x, char) in row.enumerated() {
                let point = Point(x: x, y: y)
                tempGrid[point] = char
                if char == startSymbol { start = point }
                if char == endSymbol { end = point }
            }
        }

        guard let start = start, let end = end else {
            fatalError("Invalid input: Missing start ('S') or end ('E') point!")
        }

        self.grid = tempGrid
        self.start = start
        self.end = end
        self.rows = lines.count
        self.cols = lines.first?.count ?? 0
    }

    // MARK: - Main Logic
    func countPathWithCheating(maxCheat: Int, minTime: Int) -> Int {
        var cheatCount = 0

        for point in shortestPath {
            for y in max(0, point.y - maxCheat)...min(rows - 1, point.y + maxCheat) {
                let dy = abs(y - point.y)
                let cheatRadius = maxCheat - dy
                for x in max(0, point.x - cheatRadius)...min(cols - 1, point.x + cheatRadius) {
                    let dx = abs(x - point.x)
                    let timeGain = pathCosts[point.y][point.x] - pathCosts[y][x] - (dx + dy)

                    if timeGain >= minTime {
                        cheatCount += 1
                    }
                }
            }
        }

        return cheatCount
    }

    // MARK: - BFS Pathfinding
    private func findShortestPath() -> Set<Point> {
        var visited: Set<Point> = [start]
        var queue: [(Point, [Point])] = [(start, [])]

        while let (current, path) = queue.first {
            queue.removeFirst()
            if current == end { return Set(path + [current]) }

            for neighbor in current.neighbors() where grid[neighbor] != wallSymbol && !visited.contains(neighbor) {
                visited.insert(neighbor)
                queue.append((neighbor, path + [current]))
            }
        }

        return []
    }

    // MARK: - Path Costs
    private func calculatePathCosts() -> [[Int]] {
        let maxCost = Int.max - 1_000_000
        var costs = Array(repeating: Array(repeating: maxCost, count: cols), count: rows)
        var queue: [(Point, Int)] = [(start, 0)]

        while let (current, cost) = queue.first {
            queue.removeFirst()

            if costs[current.y][current.x] > cost {
                costs[current.y][current.x] = cost

                for neighbor in current.neighbors() where grid[neighbor] != wallSymbol {
                    queue.append((neighbor, cost + 1))
                }
            }
        }

        return costs
    }
}

// MARK: - Start
let date = Date.now

let raceCondition = RaceCondition(input: inputWork)
print("1:", raceCondition.countPathWithCheating(maxCheat: 2, minTime: 100))
print("2:", raceCondition.countPathWithCheating(maxCheat: 20, minTime: 100))
print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
