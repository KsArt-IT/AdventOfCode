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

// MARK: - Processing
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

// MARK: - Parsing the map
let date = Date.now
var map = input.split(separator: "\n").map { Array($0) }
print("Start: \(map[0].count) x \(map.count)")
let startRow = map.firstIndex { $0.contains("^") }!
let startCol = map[startRow].firstIndex(of: "^")!
map[startRow][startCol] = "."
let start = Position(row: startRow, col: startCol)
let direction = Direction.up

// MARK: - Calculating the number of positions
let visited = getPathPoints(map: map, start: start, direction: direction)
print("time: \(Date.now.timeIntervalSince(date))")
print("visited: \(visited.count)")
print("end")
