import Foundation

let input = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undon't()do()?mul(8,5))
"""
//mul(X,Y), where X and Y are each 1-3 digit numbers
let regex = try! NSRegularExpression(pattern: #"mul\((\d{1,3}),(\d{1,3})\)"#)
let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

//state on-off
let stateRegex = try! NSRegularExpression(pattern: #"(do\(\)|don't\(\))"#)
let stateEnabled = "do()"
let states = stateRegex.matches(in: input, range: NSRange(input.startIndex..., in: input))
    .map { (Range($0.range, in: input)!.lowerBound, input[Range($0.range, in: input)!] == stateEnabled) }
    .sorted { $0.0 < $1.0 }
var isEnabled = true, stateIdx = 0

//mul for all + state
let mul = matches.map { match in
    let range = Range(match.range, in: input)!

    while stateIdx < states.count, states[stateIdx].0 <= range.lowerBound {
        isEnabled = states[stateIdx].1
        stateIdx += 1
    }

    let x = Int(input[Range(match.range(at: 1), in: input)!])!
    let y = Int(input[Range(match.range(at: 2), in: input)!])!

    return (x * y, isEnabled)
}

let sum1 = mul.reduce(0) { $0 + $1.0 }
let sum2 = mul.reduce(0) { $0 + ($1.1 ? $1.0 : 0) }

print("sum1 = \(sum1)\nsum2 = \(sum2)")
