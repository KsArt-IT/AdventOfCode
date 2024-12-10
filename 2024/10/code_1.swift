//
//  main.swift
//  2024_10_1
//
//  Created by KsArT on 10.12.2024.
//

import Foundation

let input = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"""
// 36, 81

struct Position: Hashable {
    let x: Int
    let y: Int
}
// x(col), y(row)
let directions = [
    (0, -1), // up
    (0, 1), // down
    (-1, 0), // left
    (1, 0) // right
]
// 0...9
let length = 9

// MARK: - Start
var date = Date.now

let mapa = parseInput(input)
let startPaths = findStartPoint(mapa)
let last = findPaths(mapa, for: startPaths)
//
print("time: \(Date.now.timeIntervalSince(date))")
print("last points: \(last)")

// MARK: - Func
func parseInput(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { Array($0).map { Int($0.description)! } }
}

func findStartPoint(_ mapa: [[Int]]) -> [Position] {
    mapa.enumerated().flatMap { y, line in
        line.enumerated()
            .filter { $1 == 0 }
            .compactMap { x, _ in
                Position(x: x, y: y)
            }
    }
}

func findPaths(_ mapa: [[Int]], for startPoints: [Position]) -> Int {
    guard !mapa.isEmpty, !startPoints.isEmpty else { return (0, 0) }
    var countLast = 0

    for start in startPoints {
        let points = dfs(mapa, start: start)
        countLast += points[length]?.count ?? 0
    }
    return countLast
}

func dfs(_ mapa: [[Int]], start: Position) -> [Int: Set<Position>] {
    guard !mapa.isEmpty else { return [:] }

    var result: [Int: Set<Position>] = [:]
    func add(_ n: Int, p: Position) {
        if result[n] == nil {
            result[n] = [p]
        } else {
            result[n]!.insert(p)
        }
    }
    add(0, p: start)

    var stack: [(Int, Position)] = []
    stack.append((0, start))

    while let point = stack.popLast() {
        let num = point.0 + 1
        for dir in directions {
            let next = Position(x: point.1.x + dir.0, y: point.1.y + dir.1)
            if 0..<mapa.count ~= next.y, 0..<mapa[0].count ~= next.x, mapa[next.y][next.x] == num {
                add(num, p: next)
                stack.append((num, next))
            }
        }
    }

    return result[length] != nil ? result : [:]
}
