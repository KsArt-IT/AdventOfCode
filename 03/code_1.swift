import Foundation

let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
let pattern = #"mul\((\d{1,3}),(\d{1,3})\)"#

if let regex = try? NSRegularExpression(pattern: pattern) {
    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
    let results = matches.map(extractNumbersAndMul).reduce(0, +)

    print("Extracted numbers: \(results)")
}

func extractNumbersAndMul(_ match: NSTextCheckingResult) -> Int {
    print("match=\(match.range)")
    let first = Int(input[Range(match.range(at: 1), in: input)!])!
    let second = Int(input[Range(match.range(at: 2), in: input)!])!
    return first * second
}
