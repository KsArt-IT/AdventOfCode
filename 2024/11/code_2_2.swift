//
//  main.swift
//  2024_11_2_4
//
//  Created by KsArT on 11.12.2024.
//

import Foundation

// MARK: - Data
let initialStones = [125, 17]
// 25 - 55312
// 75 - 65601038650482
// time: 0.01214599609375

// Cache for recursion optimization
var cache: [String: Int] = [:]
// MARK: - Start
var date = Date.now
//
let blinks1 = 25
let result1 = initialStones.reduce(0) { $0 + fastForward($1, steps: blinks1) }
print("time: \(Date.now.timeIntervalSince(date))")
print("\(blinks1): \(result1)")

let blinks2 = 75
let result2 = initialStones.reduce(0) { $0 + fastForward($1, steps: blinks2) }
print("time: \(Date.now.timeIntervalSince(date))")
print("\(blinks2): \(result2)")

// MARK: - Func
//Recursive calculation of the number of stones
func fastForward(_ stone: Int, steps: Int) -> Int {
    let key = "\(stone)-\(steps)"
    if let cachedResult = cache[key] {
        return cachedResult
    }

    let result = if steps == 1 {
        blink(stone).count
    } else {
        blink(stone).reduce(0) { $0 + fastForward($1, steps: steps - 1) }
    }

    cache[key] = result
    return result
}

// Determining the next state of the stone
func blink(_ stone: Int) -> [Int] {
    if stone == 0 {
        return [1]
    }
    let stoneStr = String(stone)
    let length = stoneStr.count
    if length % 2 == 0 {
        let midIndex = stoneStr.index(stoneStr.startIndex, offsetBy: length / 2)
        let left = Int(stoneStr[..<midIndex]) ?? 0
        let right = Int(stoneStr[midIndex...]) ?? 0
        return [left, right]
    } else {
        return [stone * 2024]
    }
}
