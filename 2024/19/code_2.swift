//
//  main.swift
//  2024_19_2_1
//
//  Created by KsArT on 19.12.2024.
//

import Foundation

// MARK: - Data
let inputTest = """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
"""
// 6
// 16

// MARK: - Start
let date = Date.now
if let (patterns, designs) = parseInput(inputTest) {
    print("Total designs: \(designs.count), patterns: \(patterns.count)")

    // Запустимо обчислення у кілька потоків
    let result = await countPossibleDesigns(patterns, for: designs)
    print("-----------------------------------")
    print("time: \(Date.now.timeIntervalSince(date))")
    print("-----------------------------------")
    print("Possible designs: \(result[0])")
    print("Total combinations: \(result[1])")
} else {
    print("Incorrect data entry!")
}

// MARK: - Func
/// Обчислює всі можливі варіанти для `designs` з доступних `patterns`
func countPossibleDesigns(_ patterns: Set<String>, for designs: [String]) async -> [Int] {
    // Сховище кеш для `design`, потокобезпека на запис через @MainActor
    var memo: [Substring: Int] = [:]

    return await withTaskGroup(of: Int.self) { group in
        for design in designs {
            group.addTask {
                await isPossible(Substring(design), patterns, &memo, show: true)
            }
        }

        return await group.reduce(into: [0, 0]) { count, result in
            if result > 0 {
                count[0] += 1
                count[1] += result
            }
        }
    }
}

/// Перевіряє, чи можна зібрати `design` з доступних `patterns` (з потокобезпечною мемоїзацією)
func isPossible(_ design: Substring, _ patterns: Set<String>, _ memo: inout [Substring: Int], show: Bool = false) async -> Int {
    if show {
        print(design)
    }
    // Повернемо з кешу результат
    if let cached = memo[design] {
        return cached
    }

    // Якщо рядок порожній, комбінація знайдена
    guard !design.isEmpty else { return 1 }

    // Порахуємо всі можливі комбінації
    var count = 0
    for pattern in patterns {
        if design.hasPrefix(pattern) {
            let remaining = design.dropFirst(pattern.count)
            count += await isPossible(remaining, patterns, &memo)
        }
    }

    // Додамо до кешу, тільки тут
    await addMemo(&memo, for: design, count: count)
    // Повернем результат
    return count
}

@MainActor
func addMemo( _ memo: inout [Substring: Int], for design: Substring, count: Int) {
    memo[design] = count
}

// MARK: - Parse
/// Розбирає введений рядок у доступні `patterns`  та бажані `designs`
func parseInput(_ input: String) -> (Set<String>, [String])? {
    let sections = input.split(separator: "\n\n")
    guard sections.count == 2 else { return nil }

    // Краще Set, скоріше обробляє
    let patterns = Set(sections[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
    let designs = sections[1].split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }

    return (patterns, designs)
}
