//
//  main.swift
//  2024_17_2
//
//  Created by KsArT on 17.12.2024.
//

import Foundation

let inputTest = """
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"""

let inputTest1 = """
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
"""

// MARK: - Start
if let (registerA, registerB, registerC, program) = parseInput(inputTest) {
    let result = getOutputRunProgram(a: registerA, b: registerB, c: registerC, program: program)
    let result2 = findRegisterAForCopy(b: registerB, c: registerC, program: program)
    let result3 = runProgram(a: result2, b: registerB, c: registerC, program: program)

    print("Output: \(result)")
    print("Output: \(result2): \(result3)")
} else {
    print("Input string is incorrect!")
}
// MARK: - Func
func getOutputRunProgram(a: Int, b: Int, c: Int, program: [Int]) -> String {
    runProgram(a: a, b: b, c: c, program: program).map(String.init).joined(separator: ",")
}

func findRegisterAForCopy(b: Int, c: Int, program: [Int]) -> Int {
    var queue = [(0, 0)]
    let base = 8

func findRegisterAForCopy(b: Int, c: Int, program: [Int]) -> Int {
    var queue = [(0, 0)]
    let base = 8
    // bfs
    while let (step, a) = queue.popLast() {
        guard step < program.count else {
            return a
        }

        for i in 0..<base {
            let nextA = a * base + i
            let outProgram = runProgram(
                a: nextA,
                b: b,
                c: c,
                program: program
            )
            if outProgram[0] == program[program.count - 1 - step] {
                queue.insert((step + 1, nextA), at: 0)
            }
        }
    }
    return -1
}

func runProgram(a: Int, b: Int, c: Int, program: [Int]) -> [Int] {
    var registerA = a
    var registerB = b
    var registerC = c
    var instruction = 0
    var output = [Int]()
    let base = 8

    func comboValue(_ operand: Int) -> Int {
        switch operand {
        case 0...3: operand
        case 4: registerA
        case 5: registerB
        case 6: registerC
        default: fatalError("Invalid combo operand: \(operand)")
        }
    }

    while instruction < program.count {
        guard program.count > 1 else {
            fatalError("Invalid program length for instruction: \(instruction) < \(program.count)")
        }
        let opcode = program[instruction]
        let operand = program[instruction + 1]

        instruction += 2
        switch opcode {
        case 0: // adv
            registerA /= Int(pow(2.0, Double(comboValue(operand))))

        case 1: // bxl
            registerB ^= operand

        case 2: // bst
            registerB = comboValue(operand) % base

        case 3: // jnz
            if registerA != 0 {
                instruction = operand
            }

        case 4: // bxc
            registerB ^= registerC

        case 5: // out
            output.append(comboValue(operand) % base)

        case 6: // bdv
            registerB = registerA / Int(pow(2.0, Double(comboValue(operand))))

        case 7: // cdv
            registerC = registerA / Int(pow(2.0, Double(comboValue(operand))))

        default:
            fatalError("Invalid opcode: \(opcode)")
        }
    }

    return output
}

func parseInput(_ input: String) -> (Int, Int, Int, [Int])? {
    let numbers = input.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .compactMap(Int.init)
    guard numbers.count > 3 else { return nil }

    return (numbers[0], numbers[1], numbers[2], Array(numbers[3...]))
}
