import Foundation

let input = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

struct Position: Hashable {
    let row: Int
    let col: Int
}

enum Direction: CaseIterable {
    case up, right, down, left

    var row: Int {
        switch self {
        case .up: -1
        case .down: 1
        default: 0
        }
    }

    var col: Int {
        switch self {
        case .right: 1
        case .left: -1
        default: 0
        }
    }

    func turnRight() -> Direction {
        switch self {
        case .up: .right
        case .right: .down
        case .down: .left
        case .left: .up
        }
    }
}

struct Point: Hashable {
    let pos: Position
    let dir: Direction
}

func getPathPoints(map: [[Character]], start: Position, direction: Direction) -> Set<Position> {
    var visited = Set<Position>()
    var currentPos = start
    var currentDir = direction

    let rows = map.endIndex
    let cols = map[0].endIndex

    while 0..<rows ~= currentPos.row && 0..<cols ~= currentPos.col {
        let nextPos = Position(row: currentPos.row + currentDir.row, col: currentPos.col + currentDir.col)

        // Went over the edge
        guard 0..<rows ~= nextPos.row && 0..<cols ~= nextPos.col else { break }

        if map[nextPos.row][nextPos.col] != "#" {
            // Move forward
            currentPos = nextPos
            if !visited.contains(nextPos) {
                visited.insert(nextPos)
            }
        } else {
            // Turn right
            currentDir = currentDir.turnRight()
        }
    }

    return visited
}

func getPathLooping(map: [[Character]], start: Position, direction: Direction, block: Position) async -> Bool {
    var visited = Set<Point>()
    var currentPos = start
    var currentDir = direction

    let rows = map.endIndex
    let cols = map[0].endIndex

    while 0..<rows ~= currentPos.row && 0..<cols ~= currentPos.col {
        let point = Point(pos: currentPos, dir: currentDir)
        if visited.contains(where: { $0 == point }) {
            // Looping
            return true
        }
        visited.insert(point)

        let nextPos = Position(row: currentPos.row + currentDir.row, col: currentPos.col + currentDir.col)

        guard 0..<rows ~= nextPos.row && 0..<cols ~= nextPos.col else { return false } // Went over the edge

        if map[nextPos.row][nextPos.col] != "#" && nextPos != block {
            // Move forward
            currentPos = nextPos
        } else {
            // Turn right
            currentDir = currentDir.turnRight()
        }
    }

    return false
}

func findLoopingTask(map: [[Character]], start: Position, direction: Direction, path: Set<Position>) async -> Int? {
    try? await withThrowingTaskGroup(of: Bool.self) { group in
        var looping = 0

        for block in path {
            group.addTask {
                await getPathLooping(
                    map: map,
                    start: start,
                    direction: direction,
                    block: block
                )
            }
        }

        for try await loop in group {
            if loop {
                looping += 1
                print("looping = \(looping)")
            } else {
                print("exit")
            }
        }

        return looping
    }
}

// Parsing the map
let date = Date.now
var map = input.split(separator: "\n").map { Array($0) }
print("Start: \(map[0].count) x \(map.count)")
let startRow = map.firstIndex { $0.contains("^") }!
let startCol = map[startRow].firstIndex(of: "^")!
map[startRow][startCol] = "."
let start = Position(row: startRow, col: startCol)
let direction = Direction.up

// Calculating the number of positions
var path = getPathPoints(map: map, start: start, direction: direction)
print("time: \(Date.now.timeIntervalSince(date))")
print("visited: \(path.count)")
print("----")
path.remove(start)
let task = Task {
    await findLoopingTask(map: map, start: start, direction: direction, path: path)
}
let result = await task.result
print("time: \(Date.now.timeIntervalSince(date))")
print("Loop: \(result.get() ?? -1)")

print("----")
print("end")
