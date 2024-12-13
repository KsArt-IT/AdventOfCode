//
//  main.swift
//  2024_13_1
//
//  Created by KsArT on 13.12.2024.
//

import Foundation

let inputTest = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
"""

struct Point {
    var x: Int
    var y: Int

    func sum() -> Int {
        return x + y
    }

    static func *(lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
}

struct ClawMachine {
    let a: Point
    let b: Point
    let prize: Point
}

// MARK: - Start
let data = parseInput(inputTest)
let (prizesWon, totalTokens) = calculate(data, maxPresses: 100)
print("prizesWon: \(prizesWon)")
print("totalTokens: \(totalTokens)")

// MARK: - Func
func calculate(_ machines: [ClawMachine], maxPresses: Int) -> (Int, Int) {
    let cost = Point(x: 3, y: 1) // A = 3, B = 1

    let costs = machines.compactMap { machine in
        if let result = solve(for: machine, maxPresses: maxPresses) {
            (result * cost).sum()
        } else {
            nil
        }
    }

    let prizesWon = costs.count
    let totalTokens = costs.reduce(0, +)

    return (prizesWon, totalTokens)
}

func solve(for machine: ClawMachine, maxPresses: Int) -> Point? {
    for aPresses in 0...maxPresses {
        for bPresses in 0...maxPresses {
            let totalX = aPresses * machine.a.x + bPresses * machine.b.x
            let totalY = aPresses * machine.a.y + bPresses * machine.b.y

            if totalX == machine.prize.x && totalY == machine.prize.y {
                return Point(x: aPresses, y: bPresses)
            }
        }
    }

    return nil
}

func parseInput(_ input: String) -> [ClawMachine] {
    let lines = input.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    var machines = [ClawMachine]()
    let chars: CharacterSet = ["=", "+", ",", "X", "Y"]

    func lineComponents(_ separate: CharacterSet, at index: Int) -> [Int] {
        guard 0..<lines.count ~= index else { return [0, 0] }

        return lines[index].components(separatedBy: separate).compactMap(Int.init)
    }

    for i in stride(from: 0, to: lines.count, by: 3) {
        let aValues = lineComponents(chars, at: i)
        let bValues = lineComponents(chars, at: i + 1)
        let prizeValues = lineComponents(chars, at: i + 2)

        let machine = ClawMachine(
            a: Point(x: Int(aValues[0]), y: Int(aValues[1])),
            b: Point(x: Int(bValues[0]), y: Int(bValues[1])),
            prize: Point(x: Int(prizeValues[0]), y: Int(prizeValues[1]))
        )
        machines.append(machine)
    }

    return machines
}
