import Foundation

let input = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undon't()do()?mul(8,5))
"""
//mul(X,Y), where X and Y are each 1-3 digit numbers
let regex = try! NSRegularExpression(pattern: #"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"#)
let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

let stateOn = "do()"
let stateOff = "don't()"
var state = true

var sum2 = 0, sum0 = 0

for match in matches {
    let text = String(input[Range(match.range, in: input)!])
//    print(text)
    switch text {
    case stateOn:
        state = true
    case stateOff:
        state = false
    default:
        // Извлекаем числа X и Y из групп
        if let xRange = Range(match.range(at: 1), in: input),
           let yRange = Range(match.range(at: 2), in: input),
           let x = Int(input[xRange]),
           let y = Int(input[yRange]) {
            let mul = x * y
            if state {
                sum2 += mul
            } else {
                sum0 += mul
            }
        }
    }
}

print("sum1 = \(sum0 + sum2)\nsum2 = \(sum2)")
