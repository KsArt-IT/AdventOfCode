import Foundation

let inputList = """
3   4
4   3
2   5
1   3
3   9
3   3
"""
// get array of strings of pair of numbers
let lists = inputList.components(separatedBy: .newlines)

if !lists.isEmpty {
    var leftList: [Int] = []
    var rightList: [Int] = []

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
    var distance = 0
    var similarityScore = 0
    for i in 0..<leftList.endIndex {
        let leftNum = leftList[i]
        distance += abs(leftNum - rightList[i])
        similarityScore += leftNum * rightList.count(where: { $0 == leftNum })
    }
    print("total distance between your lists = \(distance)")
    print("similarity score = \(similarityScore)")
} else {
    print("lists is empty")
}
// get two numbers
func extractNumbers(_ line: String) -> (Int, Int)? {
    let numbers = line.split(separator: " ")
    return if numbers.count == 2, let first = Int(numbers[0]), let second = Int(numbers[1]) {
        (first, second)
    } else {
        nil
    }
}
