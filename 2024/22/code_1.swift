//
//  main.swift
//  2024_22_1
//
//  Created by KsArT on 22.12.2024.
//

import Foundation

let inputTest = """
15887950
16495136
527345
704524
1553684
12683156
11100544
12249484
7753432
5908254
"""

// MARK: - Class with code
final class MonkeyMarket {
    let task = "2024.22.1"
    let taskName = "Monkey Market"

    private let numbers: [Int]
    private let maxChanges: Int

    init(input: String, maxChanges: Int = 2000) {
        let numbers = input.split(separator: "\n").compactMap { Int($0) }
        self.numbers = numbers
        self.maxChanges = maxChanges
    }

    public func solve(part: Int = 1) {
        let result = calculatePartOne()
        Swift.print("\(part): \(result)")
    }

    private func calculatePartOne() -> Int {
        numbers.reduce(0) { sum, number in
            sum + generateSecrets(for: number, count: maxChanges)
        }
    }

    func generateSecrets(for initialSecret: Int, count: Int) -> Int {
        var secrets = [initialSecret]
        for _ in 1...count {
            let nextSecret = generateNextSecret(secrets.last!)
            secrets.append(nextSecret)
        }
        return secrets.last ?? 0
    }

    func generateNextSecret(_ secret: Int) -> Int {
        var nextSecret = secret
        nextSecret ^= nextSecret * 64
        nextSecret %= 16777216
        nextSecret ^= nextSecret / 32
        nextSecret %= 16777216
        nextSecret ^= nextSecret * 2048
        return nextSecret % 16777216
    }
}

// MARK: - Start
let date = Date.now

let monkeyMarket = MonkeyMarket(input: inputTest, maxChanges: 2000)
monkeyMarket.solve()

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
