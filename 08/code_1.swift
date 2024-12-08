//
//  main.swift
//  Advent_2024_08_2_2
//
//  Created by KsArT on 08.12.2024.
//

import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
}

func parseInput(_ input: String) -> [[Character]] {
    input.split(separator: "\n").map { Array($0) }
}

func findAntinodes(_ input: [[Character]]) -> Set<Position> {
    let width = input[0].count
    let height = input.count
    let map: [Character: [Position]] = parseAntennas(input)
    findAntinodesPart1(map, width: width, height: height)
}

func findAntinodesPart1(_ map: [Character: [Position]], width: Int, height: Int) -> Set<Position> {
    var antinodes = Set<Position>()

    func addAntinode(_ n1: Position, _ n2: Position) {
        let x = 2 * n2.x - n1.x
        let y = 2 * n2.y - n1.y
        if 0..<width ~= x, 0..<height ~= y {
            antinodes.insert(Position(x: x, y: y))
        }
    }

    for (_, positions) in map {
        for i in 0..<positions.count {
            for j in i + 1..<positions.count {
                let p1 = positions[i]
                let p2 = positions[j]

                addAntinode(p1, p2)
                addAntinode(p2, p1)
            }
        }
    }

    return antinodes
}

func parseAntennas(_ input: [[Character]]) -> [Character: [Position]] {
    var map = [Character: [Position]]()

    for (y, line) in input.enumerated() {
        for (x, char) in line.enumerated() where char != "." {
            map[char, default: []].append(Position(x: x, y: y))
        }
    }

    return map
}

let inputTest = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""
// 9 34

let date = Date.now

let map = parseInput(input)

let result1 = findAntinodes(map)
print("1: \(result1.count)")
print("time: \(Date.now.timeIntervalSince(date))")
