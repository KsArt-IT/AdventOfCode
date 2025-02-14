import 'dart:core';

/// Представляет позицию на карте с координатами и высотой
class Position {
  final int x;
  final int y;
  final int height;

  const Position({
    required this.x,
    required this.y,
    required this.height,
  });

  /// Создает новую позицию со смещением по направлению
  Position move(Direction direction) => Position(
        x: x + direction.dx,
        y: y + direction.dy,
        height: height + 1,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          x == other.x &&
          y == other.y &&
          height == other.height;

  @override
  int get hashCode => Object.hash(x, y, height);
}

/// Представляет направление движения
class Direction {
  final int dx;
  final int dy;

  const Direction(this.dx, this.dy);
}

/// Константы приложения
abstract class Constants {
  static const int length = 9;

  static const List<Direction> directions = [
    Direction(0, -1), // up
    Direction(0, 1), // down
    Direction(-1, 0), // left
    Direction(1, 0), // right
  ];
}

void main() {
  const String input = '''
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
''';

  final Stopwatch stopwatch = Stopwatch()..start();

  final PathFinder pathFinder = PathFinder(parseInput(input));
  final List<List<Position>> paths = pathFinder.findAllPaths();

  final int lastPoints = PathCounter.countUniqueEndPoints(paths);
  final int allPaths = PathCounter.countTotalPoints(paths);

  stopwatch.stop();

  print('time: ${stopwatch.elapsedMicroseconds / 1000000}');
  print('last points: $lastPoints');
  print('all paths: $allPaths');
}

/// Парсит входную строку в матрицу чисел
List<List<int>> parseInput(String input) => input
    .trim()
    .split('\n')
    .map((String line) => line.split('').map(int.parse).toList(growable: false))
    .toList(growable: false);

/// Класс для поиска путей на карте
class PathFinder {
  final List<List<int>> _map;

  const PathFinder(this._map);

  /// Находит все пути от стартовых точек
  List<List<Position>> findAllPaths() {
    final List<Position> startPoints = _findStartPoints();
    return startPoints.map(_findPathsFromStart).toList(growable: false);
  }

  /// Находит все стартовые точки на карте
  List<Position> _findStartPoints() {
    final List<Position> starts = [];
    for (int y = 0; y < _map.length; y++) {
      for (int x = 0; x < _map[y].length; x++) {
        if (_map[y][x] == 0) {
          starts.add(Position(x: x, y: y, height: 0));
        }
      }
    }
    return starts;
  }

  /// Находит все пути от одной стартовой точки
  List<Position> _findPathsFromStart(Position start) {
    final List<Position> paths = [];
    _dfs(start, paths);
    return paths;
  }

  /// Рекурсивный поиск в глубину
  void _dfs(Position current, List<Position> result) {
    if (current.height == Constants.length) {
      result.add(current);
      return;
    }

    for (final Direction direction in Constants.directions) {
      final Position next = current.move(direction);
      if (_isValidPosition(next)) {
        _dfs(next, result);
      }
    }
  }

  /// Проверяет валидность позиции на карте
  bool _isValidPosition(Position pos) =>
      pos.y >= 0 &&
      pos.y < _map.length &&
      pos.x >= 0 &&
      pos.x < _map[0].length &&
      _map[pos.y][pos.x] == pos.height;
}

/// Утилитный класс для подсчета путей
abstract class PathCounter {
  static int countUniqueEndPoints(List<List<Position>> paths) =>
      paths.fold<int>(0, (sum, path) => sum + Set<Position>.from(path).length);

  static int countTotalPoints(List<List<Position>> paths) =>
      paths.fold<int>(0, (sum, path) => sum + path.length);
}
