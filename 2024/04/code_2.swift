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
let patternXArray: [Character] = ["M", "A", "S"]
let inputArray = inputString.components(separatedBy: .newlines).map { Array($0) }

// 1809
// MARK: - Count
let count = countXDiagonals(in: patternXArray, with: inputArray)
print("Count X-\(String(patternXArray)): \(count)")

// MARK: - Processing
func countXDiagonals(in pattern: [Character], with matrix: [[Character]]) -> Int {
    guard pattern.count == 3, !matrix.isEmpty else { return 0 }

    let rows = matrix.count
    let cols = matrix[0].count
    var count = 0

    for row in 1..<rows - 1 {
        for col in 1..<cols - 1 {
            if isXDiagonals(row: row, col: col) {
                count += 1
            }
        }
    }

    return count

    func isXDiagonals(row: Int, col: Int) -> Bool {
        guard 0..<rows ~= row else { return false }
        guard 0..<cols ~= col else { return false }
        guard matrix[row][col] == pattern[1] else { return false }

        // Diagonal 1
        let isDiagonal1 =
        matrix[row - 1][col - 1] == pattern[0] &&
        matrix[row + 1][col + 1] == pattern[2]

        // Diagonal 1 reverse
        let isDiagonal1r =
        matrix[row - 1][col - 1] == pattern[2] &&
        matrix[row + 1][col + 1] == pattern[0]

        // Diagonal 2
        let isDiagonal2 =
        matrix[row - 1][col + 1] == pattern[0] &&
        matrix[row + 1][col - 1] == pattern[2]

        // Diagonal 2 reverse
        let isDiagonal2r =
        matrix[row - 1][col + 1] == pattern[2] &&
        matrix[row + 1][col - 1] == pattern[0]

        return (isDiagonal1 || isDiagonal1r) && (isDiagonal2 || isDiagonal2r)
    }
}
