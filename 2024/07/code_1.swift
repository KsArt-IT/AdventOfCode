//
//  main.swift
//  2024d0721
//
//  Created by KsArT on 07.12.2024.
//

import Foundation

let input = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
83: 17 5
"""

let date = Date.now

let equations = input.split(separator: "\n").map { $0.split(separator: ":") }
let result = await calculateEquations(input: equations)
print("\ntime: \(Date.now.timeIntervalSince(date))")
print("sum: \(result)") // 3749

func calculateEquations(input: [[Substring.SubSequence]]) async -> Int {
    await withTaskGroup(of: Int.self) { group -> Int in
        for i in 0..<equations.endIndex {
            group.addTask {
                await getRightValue(equations[i], at: i)
            }
        }

        return await group.reduce(0, +)
    }
}

func getRightValue(_ equation: [Substring.SubSequence], at n: Int) async -> Int {
    guard equation.count == 2, let value = Int(equation[0]) else { return 0 }
    let numbers = equation[1].split(separator: " ").compactMap({ Int($0) })
    guard value > 0, !numbers.isEmpty else { return 0 }
    let operators = ["+", "*"]
    let combinations = await generateOperatorCombinations(operators: operators, count: numbers.count - 1)

    for combination in combinations {
        if calculate(numbers: numbers, operators: combination) == value {
            await printM("\(n):\(equation): combinations: \(combinations.count) - true")
            return value
        }
    }

    await printM("\(n):\(equation): combinations: \(combinations.count) - false")
    return 0
}

func generateOperatorCombinations(operators: [String], count: Int) async  -> [[String]] {
    guard count > 0, !operators.isEmpty else { return [[]] }

    var result = [[String]](repeating: [], count: 1)
    for _ in 0..<count {
        var newResult = [[String]]()
        for combination in result {
            for op in operators {
                newResult.append(combination + [op])
            }
        }
        result = newResult
    }
    return result
}

func calculate(numbers: [Int], operators: [String]) -> Int {
    var result = numbers[0]

    for i in 1..<numbers.count {
        result = calculateOperation(operators[i - 1], result, numbers[i])
    }

    return result
}

func calculateOperation(_ op: String, _ n1: Int, _ n2: Int) -> Int {
    switch op {
    case "+":
        n1 + n2
    case "*":
        n1 * n2
    default:
        n1
    }
}

@MainActor
func printM(_ str: String) async {
    print(str)
}
