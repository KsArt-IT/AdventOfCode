//
//  main.swift
//  2024d0722
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

enum Operations {
    case add
    case multiply
    case concat

    func calculate(_ n1: Int, _ n2: Int) -> Int {
        switch self {
        case .add: n1 + n2
        case .multiply: n1 * n2
        case .concat: Int("\(n1)\(n2)") ?? 0
        }
    }
}

let date = Date.now

let equations = input.split(separator: "\n").map { $0.split(separator: ":") }
let result1 = await calculateEquations(input: equations, operators: [.add, .multiply])
let result2 = await calculateEquations(input: equations, operators: [.add, .multiply, .concat])
print("\ntime: \(Date.now.timeIntervalSince(date))")
print("sum: \(result1)")
print("sum: \(result2)")

func calculateEquations(input: [[Substring.SubSequence]], operators: [Operations]) async -> Int {
    await withTaskGroup(of: Int.self) { group -> Int in
        for equation in equations {
            group.addTask {
                await getRightValue(equation, operators: operators)
            }
        }

        return await group.reduce(0, +)
    }
}

func getRightValue(_ equation: [Substring.SubSequence], operators: [Operations]) async -> Int {
    guard equation.count == 2, let value = Int(equation[0]) else { return 0 }
    let numbers = equation[1].split(separator: " ").compactMap({ Int($0) })
    guard value > 0, !numbers.isEmpty else { return 0 }

    let combinations = await generateOperatorCombinations(operators: operators, count: numbers.count - 1)

    for combination in combinations {
        if calculate(numbers: numbers, operators: combination) == value {
            return value
        }
    }

    return 0
}

func generateOperatorCombinations(operators: [Operations], count: Int) async  -> [[Operations]] {
    guard count > 0, !operators.isEmpty else { return [[]] }

    var result = [[Operations]](repeating: [], count: 1)
    for _ in 0..<count {
        var newResult = [[Operations]]()
        for combination in result {
            for op in operators {
                newResult.append(combination + [op])
            }
        }
        result = newResult
    }
    return result
}

func calculate(numbers: [Int], operators: [Operations]) -> Int {
    operators.enumerated().reduce(numbers[0]) { $1.element.calculate($0, numbers[$1.offset + 1]) }
}
