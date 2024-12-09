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

let parts = input.components(separatedBy: "\n\n")
let rules = Dictionary(grouping: parts[0].split(separator: "\n")) { Int($0.split(separator: "|")[0])! }
    .mapValues { $0.map { Int($0.split(separator: "|")[1])! } }
let result = parts[1].split(separator: "\n").map { $0.split(separator: ",").map { Int($0)! } }
    .reduce((0, 0)) {
        let s = $1.sorted { rules[$0]?.contains($1) ?? false }, mid = $1.count / 2
        return (s == $1 ? ($0.0 + $1[mid], $0.1) : ($0.0, $0.1 + s[mid]))
    }

print(result.0, result.1)
