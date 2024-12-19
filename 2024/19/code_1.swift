//
//  main.swift
//  2024_19_1
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

// MARK: - Start
let date = Date.now
if let (patterns, designs) = parseInput(inputTest) {
    // Запустимо обчислення у кілька потоків
    let result = await countPossibleDesigns(patterns, for: designs)
    print("-----------------------------------")
    print("time: \(Date.now.timeIntervalSince(date))")
    print("-----------------------------------")
    print("Designs are possible: \(result)")
} else {
    print("Incorrect data entry!")
}

// MARK: - Func
/// Обчислює всі можливі варіанти для `designs` з доступних `patterns`
func countPossibleDesigns(_ patterns: Set<String>, for designs: [String]) async -> Int {
    // Сховище кеш для `design`, потокобезпека на запис через @MainActor
    var memo: [Substring: Bool] = [:]

    return await withTaskGroup(of: Bool.self) { group -> Int in
        for design in designs {
            group.addTask {
                await isPossible(Substring(design), patterns, &memo)
            }
        }
        // Повернемо кількість можливих варіантів
        return await group.reduce(0) { count, result in
            count + (result ? 1 : 0)
        }
    }
}

/// Перевіряє, чи можна зібрати `design` з доступних `patterns` (з потокобезпечною мемоїзацією)
func isPossible(_ design: Substring, _ patterns: Set<String>, _ memo: inout [Substring: Bool]) async -> Bool {
    // Повернемо з кешу результат
    if let cached = memo[design] {
        return cached
    }

    // Якщо рядок порожній, комбінація знайдена
    guard !design.isEmpty else { return true }

    // Порахуємо всі можливі комбінації
    for pattern in patterns {
        if design.hasPrefix(pattern) {
            let result = await isPossible(design.dropFirst(pattern.count), patterns, &memo)
            // Додамо до кешу, тут достатньо
            await addMemo(&memo, for: design, result: result)
            if result {
                return true
            }
        }
    }

    // Повернем результат
    return false
}

@MainActor
func addMemo( _ memo: inout [Substring: Bool], for design: Substring, result: Bool) {
    memo[design] = result
}

// MARK: - Parse
/// Розбирає введений рядок у доступні `patterns`  та бажані `designs`
func parseInput(_ input: String) -> (Set<String>, [String])? {
    let sections = input.split(separator: "\n\n")
    guard sections.count == 2 else { return nil }

    let patterns = Set(sections[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
    let designs = sections[1].split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }

    return (patterns, designs)
}
