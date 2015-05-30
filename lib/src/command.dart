library svg.src.command;

import 'dart:math';

abstract class SvgPathCommand {}

class CloseCommand implements SvgPathCommand {
  const CloseCommand();
}

abstract class PointBasedPathCommand implements SvgPathCommand {
  final Point point;

  const PointBasedPathCommand(this.point);

  @override
  bool operator==(other) {
    return other.runtimeType == runtimeType &&
           (other as PointBasedPathCommand).point == point;
  }

  @override
  String toString() => '${runtimeType} ' + {
    'point': point
  }.toString();
}

class LineToPathCommand extends PointBasedPathCommand {
  const LineToPathCommand(Point point) : super(point);
}

class MoveToPathCommand extends PointBasedPathCommand {
  const MoveToPathCommand(Point point) : super(point);
}
