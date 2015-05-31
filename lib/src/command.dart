library svg.src.command;

import 'dart:math';

/// Corresponds to a single command within a path data specification.
abstract class SvgPathSegment {
  final SvgPathSegmentType type;

  const SvgPathSegment(this.type);
}

/// Various types of defined segments.
enum SvgPathSegmentType {
  Unknown,
  ClosePath,
  MoveTo,
  LineTo,
  CurveTo,
  Arc,
}

/// A close command.
class SvgPathClose extends SvgPathSegment {
  const SvgPathClose() : super(SvgPathSegmentType.ClosePath);

  @override
  bool operator==(o) => o is SvgPathClose;

  @override
  String toString() => 'SvgPathClose {}';
}

/// Base class that defines a segment with an x and y position.
abstract class SvgPathPositionSegment extends Point implements SvgPathSegment {
  /// Whether [x] and [y] is relative to the current position.
  final bool isRelative;

  @override
  final SvgPathSegmentType type;

  const SvgPathPositionSegment(
      num x,
      num y,
      this.type, {
      this.isRelative: false}) : super(x, y);

  @override
  bool operator==(o) {
    if (o is! SvgPathPositionSegment) return false;
    SvgPathPositionSegment other = o;
    return other.type == type &&
           other.isRelative == isRelative &&
           other.x == x &&
           other.y == y;
  }

  /// Whether [x] and [y] is absolute within the viewport.
  bool get isAbsolute => !isRelative;

  @override
  String toString() => '${runtimeType} ' + {
    'x': x,
    'y': y,
    'isRelative': isRelative
  }.toString();
}

/// A line-to path command.
class SvgPathLineSegment extends SvgPathPositionSegment {
  const SvgPathLineSegment(
      num x,
      num y, {
      bool isRelative: false})
          : super(x, y, SvgPathSegmentType.LineTo, isRelative: isRelative);

  /// Whether there is no y-coordinate (a horizontal line).
  bool get isHorizontal => y == null;

  /// Whether there is no x-coordinate (a vertical line).
  bool get isVertical => x == null;
}

/// A move-to path command.
class SvgPathMoveSegment extends SvgPathPositionSegment {
  const SvgPathMoveSegment(
      num x,
      num y, {
      bool isRelative: false})
          : super(x, y, SvgPathSegmentType.MoveTo, isRelative: isRelative);
}

/// A curved quadratic path command.
class SvgPathCurveQuadraticSegment extends SvgPathPositionSegment {
  /// First control point (x).
  final num x1;

  /// First control point (y).
  final num y1;

  const SvgPathCurveQuadraticSegment(
      num x,
      num y,
      this.x1,
      this.y1, {
      bool isRelative: false})
          : super(x, y, SvgPathSegmentType.CurveTo, isRelative: isRelative);

  @override
  bool operator==(o) {
    if (o is! SvgPathCurveQuadraticSegment) return false;
    SvgPathCurveQuadraticSegment other = o;
    return other.x == x &&
    other.y == y &&
    other.x1 == x1 &&
    other.y1 == y1 &&
    other.isRelative == isRelative;
  }

  @override
  String toString() => 'SvgPathCurveCubicSegment ' + {
    'x': x,
    'y': y,
    'x1': x1,
    'y1': y1,
    'isRelative': isRelative
  }.toString();
}

class SvgPathCurveCubicSegment extends SvgPathCurveQuadraticSegment {
  /// Second control point (x).
  final num x2;

  /// Second control point (y).
  final num y2;

  const SvgPathCurveCubicSegment(
      num x,
      num y,
      num x1,
      num y1,
      this.x2,
      this.y2, {
      bool isRelative: false}) :
          super(x, y, x1, y1, isRelative: isRelative);

  @override
  bool operator==(o) {
    if (o is! SvgPathCurveCubicSegment) return false;
    SvgPathCurveCubicSegment other = o;
    return other.x == x &&
           other.y == y &&
           other.x1 == x1 &&
           other.y1 == y1 &&
           other.x2 == x2 &&
           other.y2 == y2 &&
           other.isRelative == isRelative;
  }

  @override
  String toString() => 'SvgPathCurveCubicSegment ' + {
    'x': x,
    'y': y,
    'x1': x1,
    'y1': y1,
    'x2': x2,
    'y2': y2,
    'isRelative': isRelative
  }.toString();
}

/// An arc path segment.
class SvgPathArcSegment extends SvgPathPositionSegment {
  /// The x-axis radius for the ellipse (i.e., r1).
  final num r1;

  /// The y-axis radius for the ellipse (i.e., r2).
  final num r2;

  /// The rotation angle in degrees for the ellipse's x-axis relative to the
  /// x-axis of the user coordinate system.
  final num angle;

  /// The value of the large-arc-flag parameter.
  final bool isLargeArc;

  /// The value of the sweep-flag parameter.
  final bool isSweep;

  SvgPathArcSegment(
      num x,
      num y,
      this.r1,
      this.r2,
      this.angle, {
      bool isRelative: false,
      this.isLargeArc: false,
      this.isSweep: false}) :
          super(x, y, SvgPathSegmentType.Arc, isRelative: isRelative);

  @override
  bool operator==(o) {
    if (o is! SvgPathArcSegment) return false;
    SvgPathArcSegment other = o;
    return other.x == x &&
           other.y == y &&
           other.r1 == r1 &&
           other.r2 == r2 &&
           other.angle == angle &&
           other.isRelative == isRelative &&
           other.isLargeArc == isLargeArc &&
           other.isSweep == isSweep;
  }

  @override
  String toString() => 'SvgPathArcSegment ' + {
    'x': x,
    'y': y,
    'r1': r1,
    'r2': r2,
    'angle': angle,
    'isRelative': isRelative,
    'isLargeArc': isLargeArc,
    'isSweep': isSweep
  }.toString();
}
