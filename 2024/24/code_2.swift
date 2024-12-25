//
//  main.swift
//  2024_24_2_2
//
//  Created by KsArT on 24.12.2024.
//

import Foundation

let inputTest = """
x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
"""
// 100 = 4
let inputTest1 = """
x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj
"""
/*
 bfw: 1
 bqk: 1
 djm: 1
 ffh: 0
 fgs: 1
 frj: 1
 fst: 1
 gnj: 1
 hwm: 1
 kjc: 0
 kpj: 1
 kwq: 0
 mjb: 1
 nrd: 1
 ntg: 0
 pbm: 1
 psh: 1
 qhw: 1
 rvg: 0
 tgd: 0
 tnw: 1
 vdt: 1
 wpb: 0
 z00: 0
 z01: 0
 z02: 0
 z03: 1
 z04: 0
 z05: 1
 z06: 1
 z07: 1
 z08: 1
 z09: 1
 z10: 1
 z11: 0
 z12: 0
 0011111101000 = 2024
 */

// MARK: - Class with code
final class CrossedWires {
    let task = "2024.24.2"
    let taskName = "Crossed Wires"

    enum GateOperation: String, Hashable {
        case and = "AND"
        case or = "OR"
        case xor = "XOR"

        func calculate(_ input1: Int, _ input2: Int) -> Int {
            switch self {
            case .and: input1 & input2
            case .or: input1 | input2
            case .xor: input1 ^ input2
            }
        }
    }

    struct Gate {
        let operation: GateOperation
        let input1: String
        let input2: String
    }


    private var wireValues: [String: Int]
    private var gates: [String: Gate]

    init(input: String) {
        let sections = input.split(separator: "\n\n")
        guard sections.count == 2 else {
            fatalError("Incorrect input data format")
        }

        let wireValues: [String: Int] = sections[0].split(separator: "\n")
            .reduce(into: [String: Int]()) { result, line in
                let parts = line.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                guard parts.count == 2, let value = Int(parts[1]) else {
                    fatalError("Incorrect input data format")
                }
                result[parts[0]] = value
            }

        let gates = sections[1].split(separator: "\n")
            .reduce(into: [String: Gate]()) { result, line in
                let parts = line.split(separator: " ").map { String($0) }
                guard parts.count == 5, let operation: GateOperation = GateOperation(rawValue: parts[1]) else {
                    fatalError("Incorrect input data format")
                }
                result[parts[4]] = Gate(
                    operation: operation,
                    input1: parts[0],
                    input2: parts[2]
                )
            }

        self.wireValues = wireValues
        self.gates = gates
    }

    // MARK: - PartOne
    public func calculateNormalResult() -> Int {
        gates.keys.filter { $0.starts(with: "z") }
            .sorted(by: >)
            .reduce(0) { result, label in
                result * 2 + evaluate(label)
            }
    }

    private func evaluate(_ label: String) -> Int {
        if let value = wireValues[label] {
            return value
        }
        if let gate = gates[label] {
            wireValues[label] = gate.operation.calculate(evaluate(gate.input1), evaluate(gate.input2))
            return wireValues[label]!
        } else {
            fatalError("Unknown label: \(label)")
        }
    }

    // MARK: - PartTwo
    public func fixNormalResult() -> String {
        fix().sorted().joined(separator: ",")
    }

    func fix() -> [String] {
        var currentState = computeOutput(x: "x00", operation: .and, y: "y00")

        for i in 1..<45 {
            let (x, y, z) = generateKeys(for: i)

            let xor1 = computeOutput(x: x, operation: .xor, y: y)
            let and1 = computeOutput(x: x, operation: .and, y: y)
            let xor2 = computeOutput(x: currentState, operation: .xor, y: xor1)
            let and2 = computeOutput(x: currentState, operation: .and, y: xor1)

            guard !xor2.isEmpty, !and2.isEmpty else {
                return swapAndFix(out1: xor1, out2: and1)
            }

            if xor2 == z {
                currentState = computeOutput(x: and1, operation: .or, y: and2)
            } else {
                return swapAndFix(out1: z, out2: xor2)
            }
        }
        return []
    }

    func generateKeys(for index: Int) -> (String, String, String) {
        let index = String(format: "%02d", index)
        return ("x\(index)", "y\(index)", "z\(index)")
    }

    func computeOutput(x: String, operation: GateOperation, y: String) -> String {
        gates.first(where: {
            $0.value.operation == operation &&
            (($0.value.input1 == x && $0.value.input2 == y) ||
             ($0.value.input2 == x && $0.value.input1 == y))
        })?.key ?? ""
    }

    func swapAndFix(out1: String, out2: String) -> [String] {
        if let index1 = gates.index(forKey: out1),
           let index2 = gates.index(forKey: out2) {
            gates.values.swapAt(index1, index2)
        }
        return fix() + [out1, out2]
    }
}

// MARK: - Start
let date = Date.now

let crossedWires = CrossedWires(input: input)

let result = crossedWires.calculateNormalResult()
print("1: \(result)")
let result2 = crossedWires.fixNormalResult()
print("2: \(result2)")

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
