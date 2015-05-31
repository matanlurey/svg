library svg.test.parser_test;

import 'dart:math';

import 'package:svg/svg.dart' as svg;
import 'package:svg/src/command.dart';
import 'package:svg/src/parser.dart';
import 'package:test/test.dart';

void main() {
  group('SvgParserDefinitiin', () {
    final definition = const SvgParserDefinition();

    group('Fractional constants', () {
      final parseFraction = definition.floatingPointConstant().parse;

      test('can parse without leading zero', () {
        expect(parseFraction('.05').value, 0.05);
      });

      test('can parse with leading zero', () {
        expect(parseFraction('0.05').value, 0.05);
      });

      test('can parse without any leading digits', () {
        expect(parseFraction('5.').value, 5.0);
      });
    });

    group('Floating point constants', () {
      final parseFloat = definition.floatingPointConstant().parse;

      test('can parse with a fraction', () {
        expect(parseFloat('1.05').value , 1.05);
      });

      test('can parse with digits and an exponent', () {
        expect(parseFloat('12e5').value, 12e5);
      });

      test('can parse with a fraction and leading exponent', () {
        expect(parseFloat('0.05e5').value, 0.05e5);
      });
    });

    group('Integer constants', () {
      final parseInt = definition.integerConstant().parse;

      test('can parse a single digit', () {
        expect(parseInt('5').value, 5);
      });

      test('can parse multiple digits', () {
        expect(parseInt('123').value, 123);
      });
    });

    group('Number', () {
      final parseNum = definition.number().parse;

      test('can parse a positive number', () {
        expect(parseNum('5').value, 5);
      });

      test('can parse a negative number', () {
        expect(parseNum('-5').value, -5);
      });
    });

    group('Non-negative number', () {
      final parseNonNegative = definition.nonNegativeNumber().parse;

      test('can parse an integer', () {
        expect(parseNonNegative('50').value, 50);
      });

      test('can parse a float', () {
        expect(parseNonNegative('1.05').value , 1.05);
      });
    });

    group('Coordinate pair', () {
      final parseCoordinatePair = definition.coordinatePair().parse;

      test('can parse single digits', () {
        expect(parseCoordinatePair('5,5').value, const Point(5, 5));
      });

      test('can parse multiple digits', () {
        expect(parseCoordinatePair('12,-12').value, const Point(12, -12));
      });
    });

    group('Line to', () {
      final parseLine = definition.build(
            start: definition.lineTo)
            .parse;

      test('can parse a single line', () {
        expect(
            parseLine('l5,5').value,
            [const SvgPathLineSegment(5, 5)]);
      });

      test('can parse a single line with fractional values', () {
        expect(
            parseLine('l1.2,3').value,
            [const SvgPathLineSegment(1.2, 3)]);
      });

      test('can parse multiple line values', () {
        expect(
            parseLine('l1,1,2,2').value, [
              const SvgPathLineSegment(1, 1),
              const SvgPathLineSegment(2, 2)
            ]);
      });
    });

    group('Move to', () {
      final parseMove = definition.build(
          start: definition.moveTo)
          .parse;

      test('can parse a simple command', () {
        expect(
            parseMove('m5,5').value,
            [const SvgPathMoveSegment(5, 5)]);
      });

      test('can parse followed by additional moves', () {
        expect(
            parseMove('m0,0,5,5').value,
            [
              const SvgPathMoveSegment(0, 0),
              const SvgPathMoveSegment(5, 5)
            ]);
      });
    });

    group('Draw to', () {
      final parseDraw = definition.build(
          start: definition.drawToCommand)
          .parse;

      test('can parse a close path', () {
        expect(parseDraw('z').value, [const SvgPathClose()]);
      });

      test('can parse a line to', () {
        expect(parseDraw('l5,5').value, [
          const SvgPathLineSegment(5, 5)
        ]);
      });
    });

    group('Draw to (multiple)', () {
      final parseDraws = definition.build(
          start: definition.drawToCommands)
          .parse;

      test('can parse multiple lines, then a close', () {
        expect(parseDraws('L15,15L14,14z').value, [
          const SvgPathLineSegment(15, 15),
          const SvgPathLineSegment(14, 14),
          const SvgPathClose()
        ]);
      });

      test('can parse multiple lines with fractional values', () {
        expect(parseDraws('L5.5,4.4L3.3,2.2z').value, [
          const SvgPathLineSegment(5.5, 4.4),
          const SvgPathLineSegment(3.3, 2.2),
          const SvgPathClose()
        ]);
      });
    });

    group('Move to draw to command', () {
      final parseDraw = definition.build(
          start: definition.moveToDrawToCommandGroup)
          .parse;

      test('can parse a move/draw command', () {
        expect(
            parseDraw('M1,2L3,4').value,
            const [
              const SvgPathMoveSegment(1, 2),
              const SvgPathLineSegment(3, 4)
            ]);
      });

      test('can parse a move/draw command with a comma in between', () {
        expect(
            parseDraw('M1,2,L3,4').value,
            const [
              const SvgPathMoveSegment(1, 2),
              const SvgPathLineSegment(3, 4)
            ]);
      });
    });

    group('Path', () {
      final parseSvgPath = definition.build(
          start: definition.moveToDrawToCommandGroups)
          .parse;

      test('can parse a path', () {
        // This is a shape path for drawing an up-arrow :)
        expect(parseSvgPath('M0,15,L15,15L7.5,0z').value, const [
          const SvgPathMoveSegment(0, 15),
          const SvgPathLineSegment(15, 15),
          const SvgPathLineSegment(7.5, 0),
          const SvgPathClose()
        ]);
      });
    });
  });

  test('parseSvgPath works as intended', () {
    expect(svg.parseSvgPath('M0,15,L15,15L7.5,0z'), const [
      const SvgPathMoveSegment(0, 15),
      const SvgPathLineSegment(15, 15),
      const SvgPathLineSegment(7.5, 0),
      const SvgPathClose()
    ]);
  });
}
