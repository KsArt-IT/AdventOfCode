//
//  main.swift
//  2024_11_2_3
//
//  Created by KsArT on 11.12.2024.
//

import Foundation

// MARK: - Data
let initialStones = [125, 17]
//25 - 55312
//75 - 65601038650482

// MARK: - Start
var date = Date.now
let blinks1 = 25
let result1 = countStones(initialStones, for: blinks1)
print("time: \(Date.now.timeIntervalSince(date))")
print("\(blinks1): \(result1)")

let blinks2 = 75
let result2 = countStones(initialStones, for: blinks2)
//
print("time: \(Date.now.timeIntervalSince(date))")
print("\(blinks2): \(result2)")

// MARK: - Func
func countStones(_ stones: [Int], for blinks: Int) -> Int {
    var queue = Array(stones)
    var memo: [Int: [Int]] = [:]

    for i in 0..<blinks {
        let currentCount = queue.count
        print("blinks: \(i) for \(currentCount)")
        let dateBlink = Date.now

        for _ in 0..<currentCount {
            let stone = queue.removeFirst()

            if let cachedResult = memo[stone] {
                queue.append(contentsOf: cachedResult)
            } else {
                let result = blink(stone)
                memo[stone] = result
                queue.append(contentsOf: result)
            }
        }
        print("time: \(Date.now.timeIntervalSince(dateBlink)) - \(Date.now.timeIntervalSince(date))")
    }

    return queue.count
}

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
