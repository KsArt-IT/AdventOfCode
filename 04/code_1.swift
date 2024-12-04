import Foundation

let inputString = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""
let patternArray: [Character] = ["X", "M", "A", "S"]
let inputArray = inputString.components(separatedBy: .newlines).map { Array($0) }

// MARK: - Count
let count = countEntries(in: inputArray, with: patternArray)
print("Count: \(count)")

// MARK: - Processing
func countEntries(in matrix: [[Character]], with pattern: [Character]) -> Int {
    guard !pattern.isEmpty, !matrix.isEmpty else { return 0 }

    let directions = [
        (0, 1),
        (0, -1),
        (1, 0),
        (-1, 0),
        (1, 1),
        (-1, -1),
        (1, -1),
        (-1, 1)
    ]
    let rows = matrix.count
    let cols = matrix[0].count
    let length = pattern.count
    var count = 0

    func isContainedAt(row: Int, col: Int, direction: (Int, Int)) -> Bool {
        for i in 0..<length {
            let newRow = row + i * direction.0
            let newCol = col + i * direction.1
            if newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols {
                return false
            }
            if matrix[newRow][newCol] != pattern[i] {
                return false
            }
        }
        return true
    }

    for row in 0..<rows {
        for col in 0..<cols {
            for direction in directions {
                if isContainedAt(row: row, col: col, direction: direction) {
                    count += 1
                }
            }
        }
    }

    return count
}
