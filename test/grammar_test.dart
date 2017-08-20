library svg.test.grammar_test;

import 'package:petitparser/petitparser.dart';
import 'package:svg/src/grammar.dart';
import 'package:test/test.dart';

void main() {
  group('SvgGrammarDefinition', () {
    final definition = const SvgGrammarDefinition();;

    group('Digits', () {
      final parseDigits = definition.digitSequence().parse;

      test('can parse a single digit', () {
        expect(parseDigits('5').value, '5');
      });

      test('can parse multiple digits', () {
        expect(parseDigits('321').value, '321');
      });
    });

    group('Exponents', () {
      final parseExponent = definition.exponent().parse;

      test('can parse a positive exponent', () {
        expect(parseExponent('e+50').value, ['e', '+', '50']);
      });

      test('can parse a negative exponent', () {
        expect(parseExponent('E-10').value, ['E', '-', '10']);
      });
    });

    group('Fractional constants', () {
      final parseFraction = definition.fractionalConstant().parse;
      final acceptFraction = definition.fractionalConstant().accept;

      test('can parse without leading zero', () {
        expect(parseFraction('.05').value, [null, '.', '05']);
      });

      test('can parse with leading zero', () {
        expect(parseFraction('0.05').value, ['0', '.', '05']);
      });

      test('can parse without any leading digits', () {
        expect(parseFraction('5.').value, ['5', '.']);
      });

      test('does not accept without a "."', () {
        expect(acceptFraction('10e5'), isFalse);
      });
    });

    group('Floating point constants', () {
      final parseFloat = definition.floatingPointConstant().parse;

      test('can parse with a fraction', () {
        expect(parseFloat('1.05').value , [['1', '.', '05'], null]);
      });

      test('can parse with digits and an exponent', () {
        expect(parseFloat('12e5').value, ['12', ['e', null, '5']]);
      });

      test('can parse with a fraction and leading exponent', () {
        expect(
            parseFloat('0.05e5').value,
            [['0', '.', '05'], ['e', null, '5']]);
      });
    });

    group('Integer constant', () {
      final parseInt = definition.integerConstant().parse;

      test('can parse a single digit', () {
        expect(parseInt('5').value, '5');
      });

      test('can parse multiple digits', () {
        expect(parseInt('123').value, '123');
      });
    });

    group('Comma and whitespace', () {
      final parseCommaWsp = definition.commaWsp().parse;

      test('can parse simple case', () {
        expect(parseCommaWsp(' , ').value, [[' '], ',', [' ']]);
      });

      test('can parse without whitespace', () {
        expect(parseCommaWsp(',').value, [',', []]);
      });

      test('can parse without a comma', () {
        expect(parseCommaWsp(' ').value, [[' '], null, []]);
      });
    });

    group('Number', () {
      final parseNum = definition.number().parse;

      test('can parse a positive number', () {
        expect(parseNum('5').value, [null, '5']);
      });

      test('can parse a negative number', () {
        expect(parseNum('-5').value, ['-', '5']);
      });
    });

    group('Non-negative number', () {
      final parseNonNegative = definition.nonNegativeNumber().parse;

      test('can parse an integer', () {
        expect(parseNonNegative('50').value, '50');
      });

      test('can parse a float', () {
        expect(parseNonNegative('1.05').value , [['1', '.', '05'], null]);
      });
    });

    group('Coordinate pair', () {
      final parseCoordinatePair = definition.coordinatePair().parse;

      test('can parse single digits', () {
        expect(
            parseCoordinatePair('5,5').value,
            [[null, '5'], [',', []], [null, '5']]);
      });

      test('can parse multiple digits', () {
        expect(
            parseCoordinatePair('12,-12').value,
            [[null, '12'], [',', []], ['-', '12']]);
      });
    });

    group('Line to', () {
      final parseLine = definition.build(
          start: definition.lineTo)
          .parse;

      test('can parse a single line', () {
        expect(
            parseLine('l5,5').value,
            ['l', [], [[null, '5'], [',', []], [null, '5']]]);
      });

      test('can parse a single line with fractional values', () {
        expect(parseLine('l1.2,3').value, [
            'l', [], [[null, [['1', '.', '2'], null]], [',', []], [null, '3']]
        ]);
      });

      test('can parse multiple line values', () {
        expect(parseLine('l1,1,2,2').value, [
          'l',
          [],
          [
            [null, '1'],
            [',', []],
            [null, '1'],
            [',', []],
            [[null, '2'], [',', []], [null, '2']]
          ]
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
            ['m', [], [[null, '5'], [',', []], [null, '5']]]);
      });

      test('can parse followed by additional moves', () {
        expect(
            parseMove('M0,0,5,5').value,
            [
              'M',
              [],
              [
                [null, '0'],
                [',', []],
                [null, '0'],
                [',', []],
                [[null, '5'], [',', []], [null, '5']]
              ]
            ]);
      });

      test('can parse subtraction compact', () {
        expect(
          parseMove('M 100-200').value,
          [
            'M',
            [' '],
            [
              [null, '100'],
              null,
              ['-', '200']
            ]
          ]);
      });

      test('can parse float compact', () {
        expect(
            parseMove('M 0.6.5').value,
            [
              'M',
              [' '],
              [
                [null, [['0', '.', '6'], null]],
                null,
                [null, [[null, '.', '5'], null]]
              ]
            ]);
      });
    });

    group('Horizontal line to', () {
      final parseHorizontalLine = definition.build(
          start: definition.horizontalLineTo)
          .parse;

      test('can parse a single line', () {
        expect(
            parseHorizontalLine('H5').value,
            ['H', [], [null, '5']]);
      });

      test('can parse a single line with fractional values', () {
        expect(parseHorizontalLine('h1.2').value, [
          'h', [], [null, [['1', '.', '2'], null]]
        ]);
      });

      test('can parse multiple line values', () {
        expect(parseHorizontalLine('h1,2').value, [
          'h',
          [],
          [
            [null, '1'],
            [',', []],
            [null, '2']
          ]
        ]);
      });
    });

    group('Vertical line to', () {
      final parseVerticalLine = definition.build(
          start: definition.verticalLineTo)
          .parse;

      test('can parse a single line', () {
        expect(
            parseVerticalLine('V5').value,
            ['V', [], [null, '5']]);
      });

      test('can parse a single line with fractional values', () {
        expect(parseVerticalLine('v1.2').value, [
          'v', [], [null, [['1', '.', '2'], null]]
        ]);
      });

      test('can parse multiple line values', () {
        expect(parseVerticalLine('v1,2').value, [
          'v',
          [],
          [
            [null, '1'],
            [',', []],
            [null, '2']
          ]
        ]);
      });
    });

    group('Curve to', () {
      final parseCurve = definition.build(
          start: definition.curveTo)
          .parse;

      test('can parse a single curve', () {
        expect(parseCurve('C101,102 251,103 252,201').value, [
          'C',
          [],
          [
            [null, '101'],
            [',', []],
            [null, '102'],
            [[' '], null, []],
            [[null, '251'], [',', []], [null, '103']],
            [[' '], null, []],
            [[null, '252'], [',', []], [null, '201']]
          ],
        ]);
      });

      test('can parse a single curve with fractional values', () {
        expect(parseCurve('c 1.01,1.02 2.51,1.03 2.52,2.01').value, [
          'c',
          [' '],
          [
            [null, [['1', '.', '01'], null]],
            [',', []],
            [null, [['1', '.', '02'], null]],
            [[' '], null, []],
            [
              [null, [['2', '.', '51'], null]],
              [',', []],
              [null, [['1', '.', '03'], null]]
            ],
            [[' '], null, []],
            [
              [null, [['2', '.', '52'], null]],
              [',', []],
              [null, [['2', '.', '01'], null]]
            ]
          ]
        ]);
      });

      test('can parse a multiple curve values', () {
        expect(parseCurve('C100,200 500,100 300,400 101,102 251,103 252,201').value, [
          'C',
          [],
          [
            [null, '100'],
            [',', []],
            [null, '200'],
            [[' '], null, []],
            [[null, '500'], [',', []], [null, '100']],
            [[' '], null, []],
            [[null, '300'], [',', []], [null, '400']],
            [[' '], null, []],
            [
              [null, '101'],
              [',', []],
              [null, '102'],
              [[' '], null, []],
              [[null, '251'], [',', []], [null, '103']],
              [[' '], null, []],
              [[null, '252'], [',', []], [null, '201']]
            ]
          ]
        ]);
      });
    });

    group('Smooth curve to', () {
      final parseSmoothCurve = definition.build(
          start: definition.smoothCurveTo)
          .parse;

      test('can parse a single curve', () {
        expect(parseSmoothCurve('S400,300 400,200').value, [
          'S',
          [],
          [
            [null, '400'],
            [',', []],
            [null, '300'],
            [[' '], null, []],
            [[null, '400'], [',', []], [null, '200']]
          ]
        ]);
      });

      test('can parse a single curve with fractional values', () {
        expect(parseSmoothCurve('s40.1,30.20 40.999,200').value, [
          's',
          [],
          [
            [null, [['40', '.', '1'], null]],
            [',', []],
            [null, [['30', '.', '20'], null]],
            [[' '], null, []],
            [[null, [['40', '.', '999'], null]], [',', []], [null, '200']]
          ]
        ]);
      });

      test('can parse a multiple curve values', () {
        expect(parseSmoothCurve('S400,300 400,200 600,200 600,100').value, [
          'S',
          [],
          [
            [null, '400'],
            [',', []],
            [null, '300'],
            [[' '], null, []],
            [[null, '400'], [',', []], [null, '200']],
            [[' '], null, []],
            [
              [null, '600'],
              [',', []],
              [null, '200'],
              [[' '], null, []],
              [[null, '600'], [',', []], [null, '100']]
            ]
          ]
        ]);
      });
    });

    group('Quadratic bezier curve to', () {
      final parseQuadraticBezierCurve = definition.build(
          start: definition.quadraticBezierCurveTo)
          .parse;

      test('can parse a single curve', () {
        expect(parseQuadraticBezierCurve('Q400,50 600,300').value, [
          'Q',
          [],
          [
            [null, '400'],
            [',', []],
            [null, '50'],
            [[' '], null, []],
            [[null, '600'], [',', []], [null, '300']]
          ]
        ]);
      });

      test('can parse a single curve with fractional values', () {
        expect(parseQuadraticBezierCurve('q400.30,50.1 60.0,30.01').value, [
          'q',
          [],
          [
            [null, [['400', '.', '30'], null]],
            [',', []],
            [null, [['50', '.', '1'], null]],
            [[' '], null, []],
            [
              [null, [['60', '.', '0'], null]],
              [',', []],
              [null, [['30', '.', '01'], null]]
            ]
          ]
        ]);
      });

      test('can parse a multiple curve values', () {
        expect(parseQuadraticBezierCurve('Q400,50 600,300 300,20 500,100').value, [
          'Q',
          [],
          [
            [null, '400'],
            [',', []],
            [null, '50'],
            [[' '], null, []],
            [[null, '600'], [',', []], [null, '300']],
            [[' '], null, []],
            [
              [null, '300'],
              [',', []],
              [null, '20'],
              [[' '], null, []],
              [[null, '500'], [',', []], [null, '100']]
            ]
          ]
        ]);
      });
    });

    group('Smooth quadratic bezier curve to', () {
      final parseSmoothQuadraticBezierCurve = definition.build(
          start: definition.smoothQuadraticBezierCurveTo)
          .parse;

      test('can parse a single curve', () {
        expect(parseSmoothQuadraticBezierCurve('T400,300').value, [
          'T',
          [],
          [[null, '400'],
          [',', []],
          [null, '300']]
        ]);
      });

      test('can parse a single curve with fractional values', () {
        expect(parseSmoothQuadraticBezierCurve('t40.2,30.4').value, [
          't',
          [],
          [
            [null, [['40', '.', '2'], null]],
            [',', []],
            [null, [['30', '.', '4'], null]]
          ]
        ]);
      });

      test('can parse a multiple curve values', () {
        expect(parseSmoothQuadraticBezierCurve('t400,300 200,100').value, [
          't',
          [],
          [
            [null, '400'],
            [',', []],
            [null, '300'],
            [[' '], null, []],
            [[null, '200'], [',', []], [null, '100']]
          ]
        ]);
      });
    });

    group('Elliptical arc', () {
      final parseEllipticalArc = definition.build(
          start: definition.ellipticalArc)
          .parse;

      test('can parse a single curve', () {
        expect(parseEllipticalArc('A150,150 0 1,0 150,-150').value, [
          'A',
          [],
          [
            '150',
            [',', []],
            '150',
            [[' '], null, []],
            [null, '0'],
            [[' '], null, []],
            '1',
            [',', []],
            '0',
            [[' '], null, []],
            [[null, '150'], [',', []], ['-', '150']]
          ]
        ]);
      });

      test('can parse a single curve with fractional values', () {
        expect(parseEllipticalArc('a1.50,15.0 0.1 0,1 15.20,-13.10').value, [
          'a',
          [],
          [
            [['1', '.', '50'], null],
            [',', []],
            [['15', '.', '0'], null],
            [[' '], null, []],
            [null, [['0', '.', '1'], null]],
            [[' '], null, []],
            '0',
            [',', []],
            '1',
            [[' '], null, []],
            [
              [null, [['15', '.', '20'], null]],
              [',', []],
              ['-', [['13', '.', '10'], null]]
            ]
          ]
        ]);
      });

      test('can parse a multiple curve values', () {
        expect(parseEllipticalArc('A150,150 0 1,0 150,-150 120,120 0 0,1 120,-120').value, [
          'A',
          [],
          [
            '150',
            [',', []],
            '150',
            [[' '], null, []],
            [null, '0'],
            [[' '], null, []],
            '1',
            [',', []],
            '0',
            [[' '], null, []],
            [[null, '150'], [',', []], ['-', '150']],
            [[' '], null, []],
            [
              '120',
              [',', []],
              '120',
              [[' '], null, []],
              [null, '0'],
              [[' '], null, []],
              '0',
              [',', []],
              '1',
              [[' '], null, []],
              [[null, '120'], [',', []], ['-', '120']]
            ]
          ]
        ]);
      });
    });

    group('Draw to', () {
      final parseDraw = definition.build(
          start: definition.drawToCommand)
          .parse;

      test('can parse a close path', () {
        expect(parseDraw('z').value, 'z');
      });

      test('can parse a line to', () {
        expect(
            parseDraw('l5,5').value,
            ['l', [], [[null, '5'], [',', []], [null, '5']]]);
      });
    });

    group('Draw to (multiple)', () {
      final parseDraws = definition.build(
          start: definition.drawToCommands)
          .parse;

      test('can parse multiple lines, then a close', () {
        expect(parseDraws('L15,15L14,14z').value, [
          ['L', [], [[null, '15'], [',', []], [null, '15']]],
          [],
          [['L', [], [[null, '14'], [',', []], [null, '14']]], [], 'z']
        ]);
      });

      test('can parse multiple lines with fractional values', () {
        expect(parseDraws('L5.5,4.4L3.3,2.2z').value, [
          [
            'L',
            [],
            [
              [null, [['5', '.', '5'], null]],
              [',', []],
              [null, [['4', '.', '4'], null]]
            ]
          ],
          [],
          [
            [
              'L',
              [],
              [
                [null, [['3', '.', '3'], null]],
                [',', []],
                [null, [['2', '.', '2'], null]]
              ]
            ],
            [],
            'z'
          ]
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
            [
              'M',
              [],
              [[null, '1'], [',', []], [null, '2']],
              null,
              ['L', [], [[null, '3'], [',', []], [null, '4']]]
            ]);
      });

      test('can parse a move/draw command with a comma in between', () {
        expect(
            parseDraw('M1,2,L3,4').value,
            [
              'M',
              [],
              [[null, '1'], [',', []], [null, '2']],
              [',', []],
              ['L', [], [[null, '3'], [',', []], [null, '4']]]
            ]);
      });
    });

    group('Move to draw to command groups', () {
      final parseDraws = definition.build(
          start: definition.moveToDrawToCommandGroups)
          .parse;

      test('can parse a move/draw command', () {
        expect(parseDraws('M1,2L3,4M5,6L7,8').value, [
          'M',
          [],
          [[null, '1'], [',', []], [null, '2']],
          null,
          ['L', [], [[null, '3'], [',', []], [null, '4']]],
          [],
          [
            'M',
            [],
            [[null, '5'], [',', []], [null, '6']],
            null,
            ['L', [], [[null, '7'], [',', []], [null, '8']]]
          ]
        ]);
      });
    });

    group('Path', () {
      final parseSvgPath = definition.build(
          start: definition.moveToDrawToCommandGroups)
          .parse;

      test('can parse a path', () {
        // This is a shape path for drawing an up-arrow :)
        expect(parseSvgPath('M0,15,L15,15L7.5,0z').value, [
          'M',
          [],
          [[null, '0'], [',', []], [null, '15']],
          [',', []],
          [
            ['L', [], [[null, '15'], [',', []], [null, '15']]],
            [],
            [
              [
                'L',
                [],
                [[null, [['7', '.', '5'], null]],
                [',', []],
                [null, '0']]
              ],
              [],
              'z'
            ]
          ]
        ]);
      });
    });
  });
}
