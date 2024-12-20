//
//  main.swift
//  2024_20_1
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

let inputWork = """
####
#SE#
####
"""

struct Point: Hashable {
    let x: Int
    let y: Int

    static func +(lhs: Point, rhs: Direction) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

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
}

let startSymbol: Character = "S"
let endSymbol: Character = "E"
let wallSymbol: Character = "#"

let test = true
let (input, minTime) = if test {
    (inputTest, 50)
} else {
    (inputWork, 100)
}

// MARK: - Start
let date = Date.now

let map = parseInput(input)
if let (start, end) = findStartAndEndPoints(map) {
    let times = calculatePathCost(map, start: start, end: end)
    let result = countPathWithCheating(map, start: start, end: end, times: times, maxCheat: 2, minTime: minTime)
    print(result)
    print("-----------------------------------")
    print("time: \(Date.now.timeIntervalSince(date))")
    print("-----------------------------------")
} else {
    print("Invalid map, start '\(startSymbol)' or end '\(endSymbol)' Point not found!")
}

// MARK: - Func
func countPathWithCheating(_ map: [[Character]], start: Point, end: Point, times: [[Int]], maxCheat: Int, minTime: Int) -> Int {
    let rows = map.count - 1
    let cols = map[0].count - 1
    var cheats: [Int: Int] = [:]

    for y in 0...rows {
        for x in 0...cols {
            guard map[y][x] != wallSymbol else { continue }

            for y2 in max(0, y - maxCheat)...min(rows, y + maxCheat) {
                let dy = abs(y2 - y)
                let cheat = maxCheat - dy
                for x2 in max(0, x - cheat)...min(cols, x + cheat) {
                    let dx = abs(x2 - x)

                    let time = times[y][x] - times[y2][x2] - (dx + dy)
                    if time > 0 {
                        cheats[time, default: 0] += 1
                    }
                }
            }
        }
    }

    return cheats.filter { $0.key >= minTime }.reduce(0) { $0 + $1.value }
}

func calculatePathCost(_ map: [[Character]], start: Point, end: Point) -> [[Int]] {
    let rows = map.count
    let cols = map[0].count

    let max = Int(Int32.max)
    var times = map.map { $0.map { _ in max } }
    var time = map.flatMap(\.self).count(where: { $0 != wallSymbol }) - 1
    var current = start

    while time >= 0 {
        times[current.y][current.x] = time
        time -= 1

        for direction in Direction.allCases {
            let nextPoint = current + direction
            guard 0..<cols ~= nextPoint.x, 0..<rows ~= nextPoint.y else { continue }

            if map[nextPoint.y][nextPoint.x] != wallSymbol, times[nextPoint.y][nextPoint.x] == max {
                current = nextPoint
                break
            }
        }
    }

    return times
}

// MARK: - Parse
func parseInput(_ input: String) -> [[Character]] {
    input.split(separator: "\n").map { Array($0) }
}

func findStartAndEndPoints(_ map: [[Character]]) -> (Point, Point)? {
    var start: Point?
    var end: Point?

    for (y, row) in map.enumerated() {
        if let x = row.firstIndex(of: startSymbol) {
            start = Point(x: x, y: y)
        }
        if let x = row.firstIndex(of: endSymbol) {
            end = Point(x: x, y: y)
        }
        if let start, let end {
            return (start, end)
        }
    }

    return nil
}
