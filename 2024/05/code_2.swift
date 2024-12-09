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

func findSumOfMiddlePages(input: String) -> (Int, Int) {
    let (rules, updates) = parseInput(input)
    guard !rules.isEmpty, !updates.isEmpty else { return (0, 0) }

    var sum = 0
    var sumUpdate = 0

    for update in updates {
        let middleIndex = update.count / 2
        if isUpdateValid(update: update, rules: rules) {
            sum += update[middleIndex]
        } else {
            let organized = organizePages(update: update, rules: rules)
            sumUpdate += organized[middleIndex]
        }
    }
    return (sum, sumUpdate)
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
    for i in 0..<update.count - 1 {
        guard let pages = rules[update[i]] else { return false }
        for j in i+1..<update.count {
            if !pages.contains(update[update[j]]) {
                return false
            }
        }
    }
    return true
}

func organizePages(update: [Int], rules: [Int: [Int]]) -> [Int] {
    guard update.count > 1 else { return update }
    var organized = update
    var swapped = false

    for i in 0..<organized.count - 2 {
        swapped = false
        for i in 0..<organized.count - 1 {
            if let pages = rules[organized[i]], pages.contains(organized[i+1]) {
                continue
            }
            organized.swapAt(i, i + 1)
            swapped = true
        }
        if !swapped {
            break
        }
    }
    return organized
}
