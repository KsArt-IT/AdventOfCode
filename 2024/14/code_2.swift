//
//  main.swift
//  2024_14_2_2
//
//  Created by KsArT on 14.12.2024.
//

import Foundation

// MARK: - Data
let inputTest = """
0,4,3,-3
6,3,-1,-3
10,3,-1,2
2,0,2,-1
0,0,1,3
3,0,-2,-2
7,6,-1,-3
3,0,-1,-2
9,3,2,3
7,3,-1,2
2,4,2,-3
9,5,-3,-3
"""
// MARK: - Params
let width = 101
let height = 103
let time = 1
let length = 5

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Robot {
    var position: Point
    var velocity: Point
}
let robotPosition = "*"

// MARK: - Start
let date = Date.now

let robots = parseInput(inputTest)
let result = process(robots, start: time)
print("time: \(Date.now.timeIntervalSince(date))")
print(result)

// MARK: - Func
func process(_ robots: [Robot], start: Int) -> String {
    var canvas: [[String]] = Array(repeating: Array(repeating: ".", count: width), count: height)

    for step in start... {
        clearCanvas(&canvas)
        let newPosition = simulate(robots, by: step)
        drawRobots(&canvas, robots: newPosition)
        if isTreeLine(canvas) {
            return "Step: \(step)\n\n\(canvas.map { $0.joined() }.joined(separator: "\n"))"
        }
        print(step)
    }

    return "The robots didn't line up like a Christmas tree"
}

func simulate(_ robots: [Robot], by time: Int) -> [Robot] {
    robots.map { robot in
        Robot(
            position: Point(
                x: ((robot.position.x + robot.velocity.x * time) % width + width) % width,
                y: ((robot.position.y + robot.velocity.y * time) % height + height) % height
            ),
            velocity: robot.velocity
        )
    }
}

func isTreeLine(_ canvas: [[String]]) -> Bool {
    guard canvas.count > length, canvas[0].count > length else { return false }

    let rows = canvas.count - length
    let cols = canvas[0].count - length

    var consecutiveLines = 0

    for y in 0..<rows {
        for x in 0..<cols {
            if canvas[y][x..<x+length].allSatisfy({ $0 == robotPosition }) {
                consecutiveLines += 1
                if consecutiveLines > length {
                    return true
                }
                break
            }
        }
    }

    return false
}

func clearCanvas(_ canvas: inout [[String]]) {
    for y in canvas.indices {
        for x in canvas[0].indices {
            canvas[y][x] = "."
        }
    }
}

func drawRobots(_ canvas: inout [[String]], robots: [Robot]) {
    robots.forEach { robot in
        canvas[robot.position.y][robot.position.x] = robotPosition
    }
}

func parseInput(_ input: String) -> [Robot] {
    input.split(separator: "\n").compactMap { line in
        let params = line.components(separatedBy: ["=", ",", " "]).compactMap(Int.init)
        guard params.count == 4 else { return nil }
        return Robot(
            position: Point(x: params[0], y: params[1]),
            velocity: Point(x: params[2], y: params[3])
        )
    }
}
