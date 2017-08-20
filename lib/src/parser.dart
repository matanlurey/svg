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
  commaWhitespace() => super.commaWhitespace().map((_) => null);

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
