import Foundation

let inputList = """
3   4
4   3
2   5
1   3
3   9
3   3
"""
var leftList: [Int] = []
var rightList: [Int] = []

let lists = inputList.components(separatedBy: .newlines)
if !lists.isEmpty {
    lists.forEach({
        if let (first, second) = extractNumbers($0) {
            leftList.append(first)
            rightList.append(second)
        } else {
            print("bad input line: \(leftList.count)")
        }
    })
    leftList.sort()
    rightList.sort()

    let similarityScore = leftList.compactMap({ num in
        num * rightList.count(where: { $0 == num })
    }).reduce(0, +)
    print("similarity score = \(similarityScore)")
} else {
    print("lists is empty")
}
//
func extractNumbers(_ line: String) -> (Int, Int)? {
    let numbers = line.split(separator: " ")
    return if numbers.count == 2, let first = Int(numbers[0]), let second = Int(numbers[1]) {
        (first, second)
    } else {
        nil
    }
}
