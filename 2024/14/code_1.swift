//
//  main.swift
//  2024_14_1
//
//  Created by KsArT on 14.12.2024.
//

import Foundation

// MARK: - Data
let inputTest = """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
"""

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Robot {
    var position: Point
    var velocity: Point
}

// MARK: - Params
let width = 101
let height = 103
let time = 100

// MARK: - Start
let date = Date.now

let robots = parseInput(inputTest)
let result = process(robots, time: time, halfWidth: width / 2, halfHeight: height / 2)
print("time: \(Date.now.timeIntervalSince(date))")
print(result)

// MARK: - Func
func process(_ robots: [Robot], time: Int, halfWidth: Int, halfHeight: Int) -> Int {
    return robots.map(simulate)
        .reduce(into: [0, 0, 0, 0], countQuadrant)
        .reduce(1, *)

    func simulate(_ robot: Robot) -> Point {
        Point(
            x: ((robot.position.x + robot.velocity.x * time) % width + width) % width,
            y: ((robot.position.y + robot.velocity.y * time) % height + height) % height
        )
    }

    func countQuadrant(_ quadrant: inout [Int], position: Point) {
        guard quadrant.count == 4 else { return }

        if position.x != halfWidth && position.y != halfHeight {
            switch (position.x > halfWidth, position.y < halfHeight) {
            case (true, true):
                quadrant[0] += 1
            case (false, true):
                quadrant[1] += 1
            case (false, false):
                quadrant[2] += 1
            case (true, false):
                quadrant[3] += 1
            }
        }
    }
}

func parseInput(_ input: String) -> [Robot] {
    input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }.compactMap { line in
        let params = line.components(separatedBy: ["=", ",", " "]).compactMap(Int.init)
        guard params.count == 4 else { return nil }
        return Robot(
            position: Point(x: params[0], y: params[1]),
            velocity: Point(x: params[2], y: params[3])
        )
    }
}
