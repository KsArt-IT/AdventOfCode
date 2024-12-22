//
//  main.swift
//  2024_21_2
//
//  Created by KsArT on 22.12.2024.
//

import Foundation

let inputTest = """
029A
980A
179A
456A
379A
"""
//029A: <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A
//980A: <v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A
//179A: <v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A
//456A: <v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A
//379A: <v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A
// 68 * 29, 60 * 980, 68 * 179, 64 * 456, и 64 * 379
// 126384

// MARK: - Class with code
final class KeypadConundrum {
    let task = "2024.21.1"
    let taskName = "Keypad Conundrum"

    struct Point: Hashable {
        let x, y: Int

        static func +(lhs: Point, rhs: Direction) -> Point {
            Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
        }

        func move(to other: Point) -> String {
            let dx = other.x - self.x
            let dy = other.y - self.y

            let verticalMoves = String(
                repeating: dy > 0 ? Direction.down.rawValue : Direction.up.rawValue,
                count: abs(dy)
            )
            let horizontalMoves = String(
                repeating: dx > 0 ? Direction.right.rawValue : Direction.left.rawValue,
                count: abs(dx)
            )

            return verticalMoves + horizontalMoves
        }
    }

    enum Direction: Character, Hashable, CaseIterable {
        case right = ">" // east right
        case down = "v" // south down
        case left = "<" // west left
        case up = "^" // north up

        var dx: Int { self == .right ? 1 : self == .left ? -1 : 0 }
        var dy: Int { self == .down ? 1 : self == .up ? -1 : 0 }
    }

    // MARK: - Representing Keypads
    private lazy var numericKeypad: [[Character]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["-", "0", self.aSymbol]
    ]

    private lazy var controlKeypad: [[Character]] = [
        ["-", "^", self.aSymbol],
        ["<", "v", ">"]
    ]

    private let codes: [String]
    private lazy var numericKeypadMap: [Character: Point] = numericKeypad.toMap()
    private lazy var controlKeypadMap: [Character: Point] = controlKeypad.toMap()
    private let aSymbol: Character = "A"

    // MARK: - Init
    init(input: String) {
        self.codes = input.split(separator: "\n").map(String.init)
    }

    // MARK: - Main Logic
    public func solve(limit: Int) {
        var memo: [String: Int] = [:]
        var result = 0
        for code in codes {
            result += calculateComplexity(for: code, limit: limit, memo: &memo)
        }
        print("\(taskName): \(result)")
    }

    private func calculateComplexity(for code: String, limit: Int, memo: inout [String: Int]) -> Int {
        let moves = calculateMoves(for: code, limit: limit, memo: &memo)
        return if let num = Int(code.filter { $0.isNumber }) {
            moves * num
        } else {
            moves
        }
    }

    // MARK: - Navigation
    private func calculateMoves(for line: String, limit: Int, depth: Int = 0, memo: inout [String: Int]) -> Int {
        let key = "\(line),\(depth)"
        if let cached = memo[key] {
            return cached
        }
        let pad = depth == 0 ? self.numericKeypad : self.controlKeypad
        let padPoints = depth == 0 ? self.numericKeypadMap : self.controlKeypadMap

        var count = 0
        guard var current = padPoints[aSymbol] else { return count }

        for char in line {
            if let next = padPoints[char] {
                let moves = generateMoves(from: current, to: next, on: pad)
                if depth == limit {
                    count += moves.first!.count
                } else {
                    count += moves.map { calculateMoves(for: $0, limit: limit, depth: depth + 1, memo: &memo) }.min()!
                }
                current = next
            }
        }

        memo[key] = count
        return count
    }

    private func generateMoves(from start: Point, to end: Point, on pad: [[Character]]) -> [String] {
        let moves = start.move(to: end)
        let permutations = generatePermutations(moves)

        return permutations.filter({ line in
            var current = start
            for char in line {
                if let direction = Direction(rawValue: char) {
                    current = current + direction
                    if pad[current.y][current.x] == "-" { return false }
                }
            }
            return true
        }).map { $0 + aSymbol.description }
    }

    func generatePermutations(_ string: String) -> [String] {
        if string.count < 2 { return [string] }
        var permutations: [String] = []
        for (i, char) in string.enumerated() {
            let remaining = String(string.prefix(i) + string.dropFirst(i + 1))
            for permutation in generatePermutations(remaining) {
                permutations.append(String(char) + permutation)
            }
        }
        return permutations
    }
}

// MARK: - Ext
extension Array where Element == [Character] {
    func toMap() -> [Character: KeypadConundrum.Point] {
        Dictionary(uniqueKeysWithValues: self.enumerated().flatMap { y, row in
            row.enumerated().map { x, char in
                (char, KeypadConundrum.Point(x: x, y: y))
            }
        })
    }
}

// MARK: - Start
let date = Date.now

let keypad = KeypadConundrum(input: inputTest)
keypad.solve(limit: 2)

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
