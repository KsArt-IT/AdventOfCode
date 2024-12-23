//
//  main.swift
//  2024_23_2
//
//  Created by KsArT on 23.12.2024.
//

import Foundation

let inputTest = """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"""

let inputTest1 = """
ka-co
ta-co
de-co
ta-ka
de-ta
ka-de
"""

// MARK: - Class with code
final class LanParty {
    let task = "2024.23.1"
    let taskName = "LAN Party"

    private let connections: [[String]]
    private lazy var graph: [String: Set<String>] = buildGraph(from: connections)

    init(input: String) {
        self.connections = input.split(separator: "\n").map { $0.split(separator: "-").map(String.init) }
    }

    private func buildGraph(from connections: [[String]]) -> [String: Set<String>] {
        var graph: [String: Set<String>] = [:]
        for connection in connections {
            let a = connection[0], b = connection[1]
            graph[a, default: []].insert(b)
            graph[b, default: []].insert(a)
        }
        return graph
    }

    public func countTrianglesWithT() -> Int {
        var triangles: [[String]] = []

        for (node, neighbors) in graph {
            for neighbor in neighbors {
                if neighbor > node {
                    let commonNeighbors = neighbors.intersection(graph[neighbor, default: []])
                    for common in commonNeighbors {
                        if common > neighbor {
                            let triangle = [node, neighbor, common]
                            if triangle.contains(where: { $0.starts(with: "t") }) {
                                triangles.append(triangle)
                            }
                        }
                    }
                }
            }
        }
        return triangles.count
    }

    public func findLanPartyPassword() -> String {
        var lans = connections

        for node in graph.keys {
            for i in lans.indices {
                if lans[i].allSatisfy({ graph[$0]?.contains(node) == true }) {
                    lans[i].append(node)
                }
            }
        }

        return lans.max(by: { $0.count < $1.count })?.sorted().joined(separator: ",") ?? ""
    }
}

// MARK: - Start
let date = Date.now

let lanParty = LanParty(input: inputTest)

let result = lanParty.countTrianglesWithT()
print("1: \(result)")

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")

let result2 = lanParty.findLanPartyPassword()
print("2: \(result2)")

print("-----------------------------------")
print("time: \(Date.now.timeIntervalSince(date))")
print("-----------------------------------")
