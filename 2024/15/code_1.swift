//
//  main.swift
//  2024_15_1
//
//  Created by KsArT on 15.12.2024.
//

import Foundation
let inputTest = """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"""
let inputTest1 = """
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
"""
enum Direction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

    func move() -> Point {
        switch self {
        case .up: Point(x: 0, y: -1)
        case .down: Point(x: 0, y: 1)
        case .left: Point(x: -1, y: 0)
        case .right: Point(x: 1, y: 0)
        }
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int

    static func +(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: Point, rhs: Direction) -> Point {
        let dir = rhs.move()
        return Point(x: lhs.x + dir.x, y: lhs.y + dir.y)
    }

    static func +=(lhs: inout Point, rhs: Direction) {
        let dir = rhs.move()
        lhs.x += dir.x
        lhs.y += dir.y
    }
}

let robot: Character = "@"
let robotCommands: [Character] = ["^", "v", "<", ">"]

let box: Character = "O"
let wall: Character = "#"
let ground: Character = "."

let multiplierY = 100

// MARK: - Start
let (map, commands) = parseInput(inputTest)
print("1:")
if let robotStartPosition = getRobotPosition(map) {
    print("Robot start position: \(robotStartPosition)")
    visualize(map)
    let warehouse = cleanWarehouse(map, commands: commands, position: robotStartPosition)
    let result = calculate(warehouse)
    print(result)
} else {
    print("Robot not found!")
}

// MARK: - Func
func cleanWarehouse(_ map: [[Character]], commands: [Direction], position: Point) -> [[Character]] {
    var warehouse = map
    let rows = warehouse.count
    let cols = warehouse[0].count
    var robotPosition = position

    // BFS
    func canMoveAll(from position: Point, to direction: Direction) -> [Point]? {
        var boxes: [Point] = []
        let dir = direction.move()
        var queue: [Point] = [position]
        func queueAdd(_ point: Point) {
            queue.insert(point, at: 0)
        }

        while let current = queue.popLast() {
            let newPoint = current + dir
            guard !boxes.contains(where: { $0 == newPoint }) else { continue }
            guard 0..<rows ~= newPoint.y, 0..<cols ~= newPoint.x, warehouse[newPoint.y][newPoint.x] != wall else { return nil }

            if warehouse[newPoint.y][newPoint.x] == box {
                boxes.append(newPoint)
                queueAdd(newPoint)
            }
        }
        return boxes
    }

    func moveAllBoxes(_ boxes: [Point], to direction: Direction) {
        guard !boxes.isEmpty else { return }

        let dir = direction.move()
        for point in boxes.reversed() {
            warehouse[point.y + dir.y][point.x + dir.x] = warehouse[point.y][point.x]
            warehouse[point.y][point.x] = ground
        }
    }

    func moveRobot(to direction: Direction) {
        warehouse[robotPosition.y][robotPosition.x] = ground
        robotPosition += direction
        warehouse[robotPosition.y][robotPosition.x] = robot
    }

    var step = 0
    for command in commands {
        step += 1
//        print("step: \(step) \(robot): \(command.rawValue)")
//        visualize(warehouse)

        if let points = canMoveAll(from: robotPosition, to: command) {
            moveAllBoxes(points, to: command)
            moveRobot(to: command)
        }
    }
    visualize(warehouse)
    return warehouse
}

func calculate(_ map: [[Character]]) -> Int {
    var sum = 0
    for y in map.indices {
        for x in map[y].indices {
            guard map[y][x] == box else { continue }
            sum += y * multiplierY + x
        }
    }
    return sum
}

func parseInput(_ input: String) -> ([[Character]], [Direction]) {
    let part = input.components(separatedBy: "\n\n")
    let inputMap = part[0].split(separator: "\n")
    let map = inputMap.map { Array(String($0)) }.map { line in
        line.map(Character.init)
    }
    let moves = part[1].filter { robotCommands.contains($0) }.compactMap { Direction(rawValue: $0) }

    return (map, moves)
}

func getRobotPosition(_ map: [[Character]]) -> Point? {
    for y in map.indices {
        if let x = map[y].firstIndex(of: robot) {
            return Point(x: x, y: y)
        }
    }
    return nil
}

func visualize(_ map: [[Character]]) {
    print(map.map { String($0) }.joined(separator: "\n"),"\n")
}
