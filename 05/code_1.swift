import Foundation

let input = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

let result = findSumOfMiddlePages(input: input)
print("Sum: \(result)")

func findSumOfMiddlePages(input: String) -> Int {
    let (rules, updates) = parseInput(input)
    guard !rules.isEmpty, !updates.isEmpty else { return 0 }

    var sum = 0

    for update in updates {
        guard isUpdateValid(update: update, rules: rules) else { continue }
        sum += update[update.count / 2]
    }
    return sum
}

func parseInput(_ input: String) -> ([Int: [Int]], [[Int]]) {
    let sections = input.components(separatedBy: "\n\n")
    guard sections.count == 2 else { return ([:], []) }

    let rulesInput = sections[0].split(separator: "\n")
    let rules = Dictionary(grouping: rulesInput) { line in
        Int(line.split(separator: "|")[0]) ?? -1
    }.mapValues { lines in
        lines.compactMap { Int($0.split(separator: "|")[1]) }
    }

    let updatesInput = sections[1].split(separator: "\n")
    let updates = updatesInput.map { $0.split(separator: ",").compactMap { Int($0) } }

    return (rules, updates)
}

func isUpdateValid(update: [Int], rules: [Int: [Int]]) -> Bool {
    guard update.count > 1 else { return true }
    var i = 0
    let count = update.count - 1
    while i < count {
        guard let pages = rules[update[i]] else { return false }
        i += 1
        for j in i..<update.count {
            if !pages.contains(update[j]) {
                return false
            }
        }
    }
    return true
}
