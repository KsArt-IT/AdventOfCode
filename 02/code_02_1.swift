import Foundation

let inputReport = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

// MARK: - Reports
let reports = inputReport.components(separatedBy: .newlines)

if !reports.isEmpty {
    let count = reports.count(where: isReportSafe)
    print("Count of safe reports = \(count)")
} else {
    print("Reports is empty")
}

// MARK: - Processing
func isReportSafe(_ line: String) -> Bool {
    guard !line.isEmpty, let numbers = extractNumbers(line), numbers.count > 1 else { return false }

    var isIncreasing: Bool?
    for i in 1..<numbers.endIndex {
        let difference = numbers[i] - numbers[i-1]
        guard 1...3 ~= abs(difference) else { return false }

        if isIncreasing == nil {
            isIncreasing = difference > 0
        } else if isIncreasing! != (difference > 0) {
            return false
        }
    }
    return true
}

func extractNumbers(_ line: String) -> [Int]? {
    line.split(separator: " ").compactMap({ Int($0) })
}
