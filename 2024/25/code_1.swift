//
//  main.swift
//  2024_25_1
//
//  Created by KsArT on 25.12.2024.
//

import Foundation

let inputTest = """
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
"""
// 3

// MARK: - Class with code
final class CodeChronicle {
    let task = "2024.25.1"
    let taskName = "Code Chronicle"

    private let locks: [[Int]]
    private let keys: [[Int]]

    // MARK: - Init
    init(input: String) {
        let (locks, keys) = input.split(separator: "\n\n")
            .map { $0.split(separator: "\n").map(String.init) }
            .reduce(into: (locks: [[Int]](), keys: [[Int]]())) { result, block in
                let heights = block[0].enumerated().map { index, _ in
                    block.count(where: { $0[$0.index($0.startIndex, offsetBy: index)] == "#" }) - 1
                }
                if block[0] == "#####" {
                    result.locks.append(heights)
                } else {
                    result.keys.append(heights)
                }
            }
        self.locks = locks
        self.keys = keys
    }

    // MARK: - PartOne
    func countPairLockAndKey() -> Int {
        locks.reduce(0) { lockCount, lock in
            lockCount + keys.count(where: { key in zip(lock, key).allSatisfy { $0 + $1 <= lock.count } })
        }
    }
}

// MARK: - Start
let date = Date.now

let code = CodeChronicle(input: inputTest)
let result = code.countPairLockAndKey()
print("1: \(result)")

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
