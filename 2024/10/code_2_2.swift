//
//  main.swift
//  2024_10_2
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
// 36, 81, time: 0.0009049177169799805

struct Position: Hashable {
    let x: Int
    let y: Int
    let height: Int
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
//
let mapa = parseInput(input)
let startPaths = findStartPoint(mapa)
let paths = findPaths(mapa, for: startPaths)
let last = countEnds(paths)
let alls = countAll(paths)
//
print("time: \(Date.now.timeIntervalSince(date))")
//
print("last points: \(last)")
print("all paths: \(alls)")

// MARK: - Func
func parseInput(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { line in
        line.map { Int(String($0))! }
    }
}

func findStartPoint(_ mapa: [[Int]]) -> [Position] {
    var starts: [Position] = []
    for (y, line) in mapa.enumerated() {
        for (x, height) in line.enumerated() where height == 0 {
            starts.append(Position(x: x, y: y, height: height))
        }
    }
    return starts
}

func findPaths(_ mapa: [[Int]], for startPoints: [Position]) -> [[Position]] {
    startPoints.map { dfs(mapa, current: $0) }
}

func dfs(_ mapa: [[Int]], current: Position) -> [Position] {
    var points: [Position] = []
    let height = current.height + 1

    for dir in directions {
        let next = Position(x: current.x + dir.0, y: current.y + dir.1, height: height)

        guard 0..<mapa.count ~= next.y, 0..<mapa[0].count ~= next.x,
              mapa[next.y][next.x] == next.height else { continue }

        if next.height == length {
            points.append(next)
        } else {
            points.append(contentsOf:  dfs(mapa, current: next))
        }
    }
    return points
}

func countEnds(_ paths: [[Position]]) -> Int {
    paths.reduce(0) { $0 + Set($1).count }
}

func countAll(_ paths: [[Position]]) -> Int {
    paths.reduce(0) { $0 + $1.count }
}
