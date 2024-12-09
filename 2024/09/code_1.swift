//
//  main.swift
//  2024_08_1
//
//  Created by KsArT on 09.12.2024.
//

import Foundation

// MARK: - Data
let input = """
2333133121414131402
"""
//00...111...2...333.44.5555.6666.777.888899
// 1928

// MARK: - Calculate
let date = Date.now

let unpacked = unpack(input)
let compressed = compress(unpacked)
let checksum = calculateChecksum(compressed)
print(checksum)
print("time: \(Date.now.timeIntervalSince(date))")

// MARK: - Func
func unpack(_ input: String) -> [Int?] {
    var i = 0
    var unpacked = [Int?]()
    func add(_ char: String.Element, empty: Bool) {
        guard let count = Int(char.description), count > 0 else { return }
        let elem = empty ? nil : i
        if !empty {
            i += 1
        }
        for _ in 0..<count {
            unpacked.append(elem)
        }
    }

    for (pos, char) in input.enumerated() {
        add(char, empty: pos % 2 != 0)
    }
    return unpacked
}

func compress(_ input: [Int?]) -> [Int?] {
    guard !input.isEmpty, var emptyPos = getEmptyPos(input), !emptyPos.isEmpty else { return [] }

    var compressed = input
    var i = compressed.count - 1
    var j = emptyPos.removeFirst()
    while i > 0, i > j {
        if compressed[i] != nil {
            compressed.swapAt(i, j)
            j = emptyPos.removeFirst()
        }
        i -= 1
    }
    return compressed
}

func getEmptyPos(_ input: [Int?]) -> [Int]? {
    guard !input.isEmpty else { return nil }

    return input.enumerated().filter({ $1 == nil }).map { pos, _ in pos }
}

func calculateChecksum(_ input: [Int?]) -> Int {
    guard !input.isEmpty else { return 0 }

    return input.enumerated()
        .reduce(0, { $0 + ($1.offset * ($1.element ?? 0)) })
}
