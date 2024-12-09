import Foundation

typealias PasswordsPolicy = (min: Int, max: Int, symbol: Character, password: String)
// MARK: - Data
let passwordsList="""
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

print(passwordsList)
if !passwordsList.isEmpty {
    let passwordsPolicy = passwordsList.components(separatedBy: .newlines).compactMap(extractPasswordsPolicy)

    let count = passwordsPolicy.count(where: checkPolicy)

    print("Count of valid passwords = \(count)")
} else {
    print("List is empty")
}

// MARK: - Processing
func extractPasswordsPolicy(_ line: String) -> PasswordsPolicy? {
    let line = line.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    guard !line.isEmpty else { return nil }

    let first = line.components(separatedBy: ":")
    guard first.count == 2 else { return nil }

    let second = first[0].components(separatedBy: .whitespaces)
    guard second.count == 2, let symbol = second[1].trimmingCharacters(in: .whitespacesAndNewlines).first else { return nil }

    let third = second[0].components(separatedBy: "-")
    guard third.count == 2 else { return nil }

    let min = Int(third[0])
    let max = Int(third[1])
    guard let min, let max else { return nil }
    let range = min...max
    return (min, max, symbol, first[1].trimmingCharacters(in: .whitespacesAndNewlines))
}

func checkPolicy(_ policy: PasswordsPolicy) -> Bool {
    let count = policy.password.count(where: { $0 == policy.symbol })
    print("symbol:'\(policy.symbol)' pass:'\(policy.password)'")
    return policy.min...policy.max ~= count
}

