//
//  main.swift
//  2024_13_2_3
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
//one:
//prizesWon: 2
//totalTokens: 480
//
//two: +10000000000000
//prizesWon: 2
//totalTokens: 875318608908

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
let (prizesWon, totalTokens) = calculate(data)
print("one:")
print("prizesWon: \(prizesWon)")
print("totalTokens: \(totalTokens)")

let higherPrize = 10_000_000_000_000
print("\ntwo: +\(higherPrize)")
let (prizesWon2, totalTokens2) = calculate(data, higherPrize)
print("prizesWon: \(prizesWon2)")
print("totalTokens: \(totalTokens2)")

// MARK: - Func
func calculate(_ machines: [ClawMachine], _ higher: Int = 0) -> (Int, Int) {
    let cost = Point(x: 3, y: 1) // A = 3, B = 1

    let costs = machines.compactMap { machine in
        if let result = solve(for: machine, higher) {
            (result * cost).sum()
        } else {
            nil
        }
    }

    return (costs.count, costs.reduce(0, +))
}

func solve(for machine: ClawMachine, _ higher: Int) -> Point? {
    let determinantAB = determinant(machine.a, machine.b)
    guard determinantAB != 0 else { return nil }

    let prize = Point(x: machine.prize.x + higher, y: machine.prize.y + higher)

    let determinantA = determinant(prize, machine.b)
    let determinantB = determinant(machine.a, prize)

    let x = Double(determinantA) / Double(determinantAB)
    let y = Double(determinantB) / Double(determinantAB)

    let max = Double.greatestFiniteMagnitude
    guard 0..<max ~= x, 0..<max ~= y,
          x.truncatingRemainder(dividingBy: 1) == 0, y.truncatingRemainder(dividingBy: 1) == 0 else { return nil }

    return Point(x: Int(x), y: Int(y))

    func determinant(_ p1: Point, _ p2: Point) -> Int {
        p1.x * p2.y - p2.x * p1.y
    }
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
