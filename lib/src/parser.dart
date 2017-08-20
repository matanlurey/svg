library svg.src.parser;

import 'dart:math';

import 'package:svg/src/command.dart';
import 'package:svg/src/grammar.dart';
import 'package:quiver/iterables.dart';

class SvgParserDefinition extends SvgGrammarDefinition {
  const SvgParserDefinition();

  @override
  svgPath() => super.svgPath().map((Iterable r) => r.toList(growable: false));

  @override
  moveToDrawToCommandGroup() => super.moveToDrawToCommandGroup().map((result) {
    result = result.where((r) => r != null);
    return concat(result);
  });

  @override
  drawToCommands() => super.drawToCommands().map((result) {
    return concat(result.map((r) => r is Iterable ? r : [r]));
  });

  @override
  closePath() => super.closePath().map((_) => const [const SvgPathClose()]);

  @override
  moveTo() => super.moveTo().map((List result) {
    return _argsParser(result[2], 1).map((List args) {
      Point point = args[0];
      return new SvgPathMoveSegment(point.x, point.y);
    });
  });

  @override
  lineTo() => super.lineTo().map((List result) {
    return _argsParser(result[2], 1).map((List args) {
      Point point = args[0];
      return new SvgPathLineSegment(point.x, point.y);
    });
  });

  @override
  horizontalLineTo() => super.horizontalLineTo().map((List result) {
    var isRelative = result[0] == 'h';

    return _argsParser(result[2], 1).map((List args) {
      num x = args[0];
      return new SvgPathLineSegment(x, null, isRelative: isRelative);
    });
  });

  @override
  verticalLineTo() => super.verticalLineTo().map((List result) {
    var isRelative = result[0] == 'v';

    return _argsParser(result[2], 1).map((List args) {
      num y = args[0];
      return new SvgPathLineSegment(null, y, isRelative: isRelative);
    });
  });

  @override
  curveTo() => super.curveTo().map((List result) {
    var isRelative = result[0] == 'c';

    return _argsParser(result[2], 5).map((List args) {
      var c1 = args[0];
      var c2 = args[2];
      var point = args[4];

      return new SvgPathCurveCubicSegment(
          point.x, point.y,
          c1.x, c1.y,
          c2.x, c2.y,
          isRelative: isRelative);
    });
  });

  @override
  smoothCurveTo() => super.smoothCurveTo().map((List result) {
    var isRelative = result[0] == 's';

    return _argsParser(result[2], 3).map((List args) {
      var c2 = args[0];
      var point = args[2];

      return new SvgPathCurveCubicSegment(
          point.x, point.y,
          null, null,
          c2.x, c2.y,
          isRelative: isRelative);
    });
  });

  @override
  quadraticBezierCurveTo() => super.quadraticBezierCurveTo().map((List result) {
    var isRelative = result[0] == 'q';

    return _argsParser(result[2], 3).map((List args) {
      var c1 = args[0];
      var point = args[2];

      return new SvgPathCurveQuadraticSegment(
          point.x, point.y,
          c1.x, c1.y,
          isRelative: isRelative);
    });
  });

  @override
  smoothQuadraticBezierCurveTo() => super.smoothQuadraticBezierCurveTo().map((List result) {
    var isRelative = result[0] == 't';

    return _argsParser(result[2], 1).map((List args) {
      var point = args[0];

      return new SvgPathCurveQuadraticSegment(
          point.x, point.y,
          null, null,
          isRelative: isRelative);
    });
  });

  @override
  ellipticalArc() => super.ellipticalArc().map((List result) {
    var isRelative = result[0] == 'a';

    return _argsParser(result[2], 11).map((List args) {
      num r1 = args[0];
      num r2 = args[2];
      num angle = args[4];
      bool isLargeArc = args[6];
      bool isSweep = args[8];
      Point point = args[10];

      return new SvgPathArcSegment(point.x, point.y, r1, r2, angle,
          isLargeArc: isLargeArc,
          isSweep: isSweep,
          isRelative: isRelative);
    });
  });

  @override
  coordinatePair() => super.coordinatePair().map((result) {
    return new Point(result[0], result[2]);
  });

  @override
  number() => super.number().map((result) {
    final sign = result[0];
    num number = result[1];
    if (sign == '-') {
      number = -number;
    }
    return number;
  });

  @override
  flag() => super.flag().map((v) => v == '1');

  @override
  commaWsp() => super.commaWsp().map((_) => null);

  @override
  integerConstant() => super.integerConstant().flatten().map(int.parse);

  @override
  floatingPointConstant() {
    return super.floatingPointConstant().flatten().map(double.parse);
  }

  @override
  fractionalConstant() {
    return super.fractionalConstant().flatten().map(double.parse);
  }

  List _argsParser(seq, num argCount) {
    Iterable it = seq is Iterable ? seq : [seq];

    var arr = [];

    while (it != null) {
      arr.add(it.take(argCount).toList(growable: false));

      var next = it.skip(argCount + 1);
      if (next.isEmpty) {
        it = null;
      } else {
        var seq = next.single;
        it = seq is Iterable ? seq : [seq];
      }
    }

    return arr;
  }
}
