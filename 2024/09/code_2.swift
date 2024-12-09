//
//  main.swift
//  2024_08_2
//
//  Created by KsArT on 09.12.2024.
//

import Foundation

// MARK: - Data
let inputTest = """
2333133121414131402
"""
// 00...111...2...333.44.5555.6666.777.888899
// 1928
// 00992111777.44.333....5555.6666.....8888..
// 2858

// MARK: - Calculate
let date = Date.now

let unpacked = unpackSmart(input)
let compressed = compressSmart(unpacked)
let checksum = calculateChecksumSmart(compressed)
print("time: \(Date.now.timeIntervalSince(date))")
print(checksum)

// MARK: - Func
func unpackSmart(_ input: String) -> [(Int?, Int)] {
    var index = 0
    var unpacked = [(Int?, Int)]()

    for (position, char) in input.enumerated() {
        guard let count = Int(String(char)), count > 0 else { continue }

        let element = position.isMultiple(of: 2) ? index : nil
        if element != nil { index += 1 }
        unpacked.append((element, count))
    }

    return unpacked
}

func compressSmart(_ input: [(Int?, Int)]) -> [(Int?, Int)] {
    guard !input.isEmpty else { return [] }

    var compressed = input
    var compressedLast: [(Int?, Int)] = []

    func insertToLast(_ entity: (Int?, Int)) {
        if entity.0 == nil, let firstNil = compressedLast.first, firstNil.0 == nil {
            compressedLast[0] = (nil, firstNil.1 + entity.1)
        } else {
            compressedLast.insert(entity, at: 0)
        }
    }

    while let entity = compressed.popLast() {
        if entity.0 != nil {
            if let index = compressed.firstIndex(where: { $0.0 == nil && $0.1 >= entity.1 }) {
                let target = compressed[index]
                if target.1 > entity.1 {
                    compressed[index] = (nil, target.1 - entity.1)
                } else {
                    compressed.remove(at: index)
                }
                compressed.insert(entity, at: index)
                insertToLast((nil, entity.1))
            } else {
                insertToLast(entity)
            }
        } else {
            insertToLast(entity)
        }
    }

    return compressed + compressedLast
}

func calculateChecksumSmart(_ input: [(Int?, Int)]) -> Int {
    guard !input.isEmpty else { return 0 }

    var checksum = 0
    var offset = 0

    for (element, count) in input {
        if let element {
            checksum += (offset..<(offset + count)).reduce(0) { $0 + $1 * element }
        }
        offset += count
    }

    return checksum
}
