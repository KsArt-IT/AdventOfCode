import Foundation

let input = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undon't()do()?mul(8,5))
"""

//mul(X,Y), where X and Y are each 1-3 digit numbers
let pattern = #"mul\((\d{1,3}),(\d{1,3})\)"#
let regex = try! NSRegularExpression(pattern: pattern)

// MARK: - Sum 1
let sum1 = execute(input, regex: regex)

// MARK: - Sum 2
var sum2 = 0
var range: Range<String.Index> = input.startIndex..<input.endIndex
var rangeOff = input.ranges(of: "don't()")
var rangeOn = input.ranges(of: "do()")
var startIndex = input.startIndex

while startIndex < input.endIndex {
    // do()
    if let nextRange = rangeOff.first(where: { $0.lowerBound > startIndex }) {
        sum2 += execute(input, startIndex: startIndex, endIndex: nextRange.lowerBound, regex: regex)
        startIndex = nextRange.upperBound
    } else {
        sum2 += execute(input, startIndex: startIndex, endIndex: input.endIndex, regex: regex)
        break
    }

    // don't()
    if let nextRange = rangeOn.first(where: { $0.lowerBound >= startIndex }) {
        startIndex = nextRange.lowerBound
    } else {
        break
    }
}

// MARK: - Results
print("\nsum 1 = \(sum1)\nsum 2 = \(sum2)")

// MARK: - Processing
func execute(_ lines: String, startIndex: String.Index, endIndex: String.Index, regex: NSRegularExpression) -> Int {
    print("summed: startIndex=\(startIndex), endIndex=\(endIndex)")
    guard !lines.isEmpty, endIndex > startIndex else { return 0 }

    let line = lines[startIndex..<endIndex]

    print("'\(line)'\n")
    return execute(String(line), regex: regex)
}

func execute(_ line: String, regex: NSRegularExpression) -> Int {
    let matches = regex.matches(in: line, range: NSRange(line.startIndex..., in: line))
    return matches.map {
        extractNumbersAndMul(line, of: $0)
    }.reduce(0, +)
}

func extractNumbersAndMul(_ line: String, of match: NSTextCheckingResult) -> Int {
    let first = Int(line[Range(match.range(at: 1), in: line)!])!
    let second = Int(line[Range(match.range(at: 2), in: line)!])!
    return first * second
}

