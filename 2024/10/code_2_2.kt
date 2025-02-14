data class Position(
    val x: Int,
    val y: Int,
    val height: Int,
) {
    operator fun plus(direction: Direction) = Position(
        x = x + direction.dx,
        y = y + direction.dy,
        height = height + 1
    )
}

data class Direction(val dx: Int, val dy: Int)

private object Constants {
    const val LENGTH = 9
    
    val DIRECTIONS = listOf(
        Direction(0, -1),  // up
        Direction(0, 1),   // down
        Direction(-1, 0),  // left
        Direction(1, 0),   // right
    )
}

fun main() {
    val input = """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
    """.trimIndent()

    kotlin.system.measureTimeMillis {
        val map = input.parseToIntMatrix()
        val startPoints = map.findStartPoints()
        val paths = startPoints.findAllPaths(map)
        println("last points: ${paths.countUniqueEndPoints()}")
        println("all paths: ${paths.countTotalPoints()}")
    }.also { println("time: ${it / 1000.0}") }
}

private fun String.parseToIntMatrix(): List<List<Int>> =
    lines().map { line -> line.map(Char::digitToInt) }

private fun List<List<Int>>.findStartPoints(): List<Position> =
    buildList {
        this@findStartPoints.forEachIndexed { y: Int, row: List<Int> ->
            row.forEachIndexed { x: Int, height: Int ->
                if (height == 0) add(Position(x, y, height))
            }
        }
    }

private fun List<Position>.findAllPaths(
    map: List<List<Int>>
): List<List<Position>> = map { start ->
    buildList { dfs(start, map, this) }
}

private fun dfs(
    current: Position,
    map: List<List<Int>>,
    result: MutableList<Position>
) {
    if (current.height == Constants.LENGTH) {
        result.add(current)
        return
    }

    for (direction in Constants.DIRECTIONS) {
        val next = current + direction
        if (next.isValidPosition(map)) {
            dfs(next, map, result)
        }
    }
}

private fun Position.isValidPosition(map: List<List<Int>>): Boolean =
    y in map.indices &&
    x in map[0].indices &&
    map[y][x] == height

private fun List<List<Position>>.countUniqueEndPoints(): Int =
    sumOf { path -> path.toSet().size }

private fun List<List<Position>>.countTotalPoints(): Int =
    sumOf { it.size } 