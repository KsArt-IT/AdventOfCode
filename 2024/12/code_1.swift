//
//  main.swift
//  2024_12_2
//
//  Created by KsArT on 12.12.2024.
//

import Foundation

// MARK: - Data
let inputTest = """
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"""
// 1930 1206

struct Point: Hashable {
    let x: Int
    let y: Int
}

let directions = [
    Point(x: -1, y: 0),
    Point(x: 0, y: 1),
    Point(x: 1, y: 0),
    Point(x: 0, y: -1)
]

// MARK: - Start
let mapa = parseInput(input)
let result1 = calculatePrice(of: mapa)
print("Price 1: \(result1)")

// MARK: - Func
func parseInput(_ input: String) -> [[Character]] {
    return input.split(separator: "\n").map { Array($0) }
}

func calculatePrice(of mapa: [[Character]]) -> Int {
    let rows = mapa.count
    let cols = mapa[0].count
    var visited = Set<Point>()

    var totalPrice1 = 0

    for y in 0..<rows {
        for x in 0..<cols {
            let currentPoint = Point(x: x, y: y)
            guard !visited.contains(currentPoint) else { continue }

            let price1 = dfs(currentPoint)
            totalPrice1 += price1
        }
    }

    func isInBounds(_ x: Int, _ y: Int) -> Bool {
        return 0..<rows ~= y && 0..<cols ~= x
    }

    func dfs(_ point: Point) -> Int {
        var stack = [point]
        var area = 0
        var perimeter = 0

        while let current = stack.popLast() {
            guard !visited.contains(current) else { continue }

            visited.insert(current)
            area += 1

            for dir in directions {
                let next = Point(x: current.x + dir.x, y: current.y + dir.y)

                if isInBounds(next.x, next.y) && mapa[next.y][next.x] == mapa[current.y][current.x] {
                    stack.append(next)
                } else {
                    perimeter += 1
                }
            }
        }

        return area * perimeter
    }

    return totalPrice1
}
