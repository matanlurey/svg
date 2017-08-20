library svg.src.grammar;

import 'package:petitparser/petitparser.dart' as pp;

/// An implementation of the the [WC3 SVG Path Grammar]
/// (http://www.w3.org/TR/SVG/paths.html) for Dart.
///
/// The grammar follows the BNF grammar provided in the
/// [SVG specifications](https://www.w3.org/TR/SVG/paths.html#PathDataBNF).
class SvgGrammarDefinition extends pp.GrammarDefinition {
  const SvgGrammarDefinition();

  @override
  start() => svgPath();

  /// svg-path:
  ///     wsp* moveto-drawto-command-groups? wsp*
  svgPath() =>
      wsp().star() &
      moveToDrawToCommandGroups().optional() &
      wsp().star();

  /// moveto-drawto-command-groups:
  ///     moveto-drawto-command-group
  ///     | moveto-drawto-command-group wsp* moveto-drawto-command-groups
  moveToDrawToCommandGroups() =>
      (moveToDrawToCommandGroup() &
          wsp().star() &
          ref(moveToDrawToCommandGroups))
      | moveToDrawToCommandGroup();

  /// moveto-drawto-command-group:
  ///     moveto wsp* drawto-commands?
  moveToDrawToCommandGroup() =>
      moveTo() & commaWsp().optional() & drawToCommands();

  /// drawto-commands:
  ///     drawto-command
  ///     | drawto-command wsp* drawto-commands
  drawToCommands() =>
      (drawToCommand() & wsp().star() & ref(drawToCommands))
      | drawToCommand();

  /// drawto-command:
  ///     closepath
  ///     | lineto
  ///     | horizontal-lineto
  ///     | vertical-lineto
  ///     | curveto
  ///     | smooth-curveto
  ///     | quadratic-bezier-curveto
  ///     | smooth-quadratic-bezier-curveto
  ///     | elliptical-arc
  drawToCommand() =>
      closePath() | lineTo() | horizontalLineTo()
      | verticalLineTo() | curveTo() | smoothCurveTo()
      | quadraticBezierCurveTo() | smoothQuadraticBezierCurveTo()
      | ellipticalArc();

  /// moveto:
  ///     ( "M" | "m" ) wsp* moveto-argument-sequence
  moveTo() => pp.pattern('Mm') & wsp().star() & moveToArgumentSequence();

  /// moveto-argument-sequence:
  ///     coordinate-pair
  ///     | coordinate-pair comma-wsp? lineto-argument-sequence
  moveToArgumentSequence() =>
      (coordinatePair() &
          commaWsp().optional() &
          lineToArgumentSequence())
      | coordinatePair();

  /// closepath:
  ///     ("Z" | "z")
  closePath() => pp.pattern('Zz');

  /// lineto:
  ///     ( "L" | "l" ) wsp* lineto-argument-sequence
  lineTo() => pp.pattern('Ll') & wsp().star() & lineToArgumentSequence();

  /// lineto-argument-sequence:
  ///     coordinate-pair
  ///     | coordinate-pair comma-wsp? lineto-argument-sequence
  lineToArgumentSequence() =>
      (coordinatePair() &
          commaWsp().optional() &
          ref(lineToArgumentSequence))
      | coordinatePair();

  /// horizontal-lineto:
  ///     ( "H" | "h" ) wsp* horizontal-lineto-argument-sequence
  horizontalLineTo() =>
      pp.pattern('Hh') & wsp().star() & horizontalLineToArgumentSequence();

  /// horizontal-lineto-argument-sequence:
  ///     coordinate
  ///     | coordinate comma-wsp? horizontal-lineto-argument-sequence
  horizontalLineToArgumentSequence() =>
      (coordinate() &
          commaWsp().optional() &
          ref(horizontalLineToArgumentSequence))
      | coordinate();

  /// vertical-lineto:
  ///     ( "V" | "v" ) wsp* vertical-lineto-argument-sequence
  verticalLineTo() =>
      pp.pattern('Vv') & wsp().star() & verticalLineToArgumentSequence();

  /// vertical-lineto-argument-sequence:
  ///     coordinate
  ///     | coordinate comma-wsp? vertical-lineto-argument-sequence
  verticalLineToArgumentSequence() =>
      (coordinate() &
          commaWsp().optional() &
          ref(verticalLineToArgumentSequence))
      | coordinate();

  /// curveto:
  ///     ( "C" | "c" ) wsp* curveto-argument-sequence
  curveTo() =>
      pp.pattern('Cc') & wsp().star() & curveToArgumentSequence();

  /// curveto-argument-sequence:
  ///     curveto-argument
  ///     | curveto-argument comma-wsp? curveto-argument-sequence
  curveToArgumentSequence() =>
      (curveToArgument() &
          commaWsp().optional() &
          ref(curveToArgumentSequence))
      | curveToArgument();

  /// curveto-argument:
  ///     coordinate-pair comma-wsp? coordinate-pair comma-wsp? coordinate-pair
  curveToArgument() =>
      coordinatePair() & commaWsp().optional() &
      coordinatePair() & commaWsp().optional() &
      coordinatePair();

  /// smooth-curveto:
  ///     ( "S" | "s" ) wsp* smooth-curveto-argument-sequence
  smoothCurveTo() =>
      pp.pattern('Ss') & wsp().star() & smoothCurveToArgumentSequence();

  /// smooth-curveto-argument-sequence:
  ///     smooth-curveto-argument
  ///     | smooth-curveto-argument comma-wsp? smooth-curveto-argument-sequence
  smoothCurveToArgumentSequence() =>
      (smoothCurvetoArgument() &
          commaWsp().optional() &
          ref(smoothCurveToArgumentSequence))
      | smoothCurvetoArgument();

  /// smooth-curveto-argument:
  ///     coordinate-pair comma-wsp? coordinate-pair
  smoothCurvetoArgument() =>
      coordinatePair() & commaWsp().optional() &
      coordinatePair();

  /// quadratic-bezier-curveto:
  ///     ( "Q" | "q" ) wsp* quadratic-bezier-curveto-argument-sequence
  quadraticBezierCurveTo() =>
      pp.pattern('Qq') & wsp().star() &
      quadraticBezierCurveToArgumentSequence();

  /// quadratic-bezier-curveto-argument-sequence:
  ///     quadratic-bezier-curveto-argument
  ///     | quadratic-bezier-curveto-argument comma-wsp?
  ///         quadratic-bezier-curveto-argument-sequence
  quadraticBezierCurveToArgumentSequence() =>
      (quadraticBezierCurveToArgument() &
          commaWsp().optional() &
          ref(quadraticBezierCurveToArgumentSequence))
      | quadraticBezierCurveToArgument();

  /// quadratic-bezier-curveto-argument:
  ///     coordinate-pair comma-wsp? coordinate-pair
  quadraticBezierCurveToArgument() =>
      coordinatePair() & commaWsp().optional() &
      coordinatePair();

  /// smooth-quadratic-bezier-curveto:
  ///     ( "T" | "t" ) wsp* smooth-quadratic-bezier-curveto-argument-sequence
  smoothQuadraticBezierCurveTo() =>
      pp.pattern('Tt') & wsp().star() &
      smoothQuadraticBezierCurveToArgumentSequence();

  /// smooth-quadratic-bezier-curveto-argument-sequence:
  ///     coordinate-pair
  ///     | coordinate-pair comma-wsp? smooth-quadratic-bezier-curveto-argument-sequence
  smoothQuadraticBezierCurveToArgumentSequence() =>
      (coordinatePair() &
          commaWsp().optional() &
          ref(smoothQuadraticBezierCurveToArgumentSequence))
      | coordinatePair();

  /// elliptical-arc:
  ///     ( "A" | "a" ) wsp* elliptical-arc-argument-sequence
  ellipticalArc() =>
      pp.pattern('Aa') & wsp().star() & ellipticalArcArgumentSequence();

  /// elliptical-arc-argument-sequence:
  ///     elliptical-arc-argument
  ///     | elliptical-arc-argument comma-wsp? elliptical-arc-argument-sequence
  ellipticalArcArgumentSequence() =>
      (ellipticalArcArgument() &
          commaWsp().optional() &
          ref(ellipticalArcArgumentSequence))
      | ellipticalArcArgument();

  /// elliptical-arc-argument:
  ///     nonnegative-number comma-wsp? nonnegative-number comma-wsp?
  ///         number comma-wsp flag comma-wsp? flag comma-wsp? coordinate-pair
  ellipticalArcArgument() =>
      nonNegativeNumber() & commaWsp().optional() &
      nonNegativeNumber() & commaWsp().optional() &
      number() & commaWsp() &
      flag() & commaWsp().optional() &
      flag() & commaWsp().optional() &
      coordinatePair();

  /// coordinate-pair:
  ///     coordinate comma-wsp? coordinate
  coordinatePair() =>
      coordinate() & commaWsp().optional() & coordinate();

  /// coordinate:
  ///     number
  coordinate() => number();

  /// nonnegative-number:
  ///     integer-constant
  ///     | floating-point-constant
  nonNegativeNumber() => floatingPointConstant() | integerConstant();

  /// number:
  ///     sign? integer-constant
  ///     | sign? floating-point-constant
  number() =>
      sign().optional() & floatingPointConstant()
      | sign().optional() & integerConstant();

  /// flag:
  ///     "0" | "1"
  flag() => pp.pattern('01');

  /// comma-wsp:
  ///     (wsp+ comma? wsp*) | (comma wsp*)
  commaWsp() =>
      (comma() & wsp().star())
      | (wsp().plus() & comma().optional() & wsp().star());

  /// comma:
  ///     ","
  comma() => pp.char(',');

  /// integer-constant:
  ///     digit-sequence
  integerConstant() => digitSequence();

  /// floating-point-constant:
  ///     fractional-constant exponent?
  ///     | digit-sequence exponent
  floatingPointConstant() =>
      fractionalConstant() & exponent().optional()
      | digitSequence() & exponent();

  /// fractional-constant:
  ///     digit-sequence? "." digit-sequence
  ///     | digit-sequence "."
  fractionalConstant() =>
      (digitSequence().optional() & pp.char('.') & digitSequence())
      | (digitSequence() & pp.char('.'));

  /// exponent:
  ///     ( "e" | "E" ) sign? digit-sequence
  exponent() => pp.pattern('eE') & sign().optional() & digitSequence();

  /// sign:
  ///     "+" | "-"
  sign() => pp.pattern('+-');

  /// digit-sequence:
  ///     digit
  ///     | digit digit-sequence
  digitSequence() =>  digit().plus().flatten();

  /// digit:
  ///     "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
  digit() => pp.digit();

  /// wsp:
  ///    (#x20 | #x9 | #xD | #xA)
  wsp() =>
      // Petiteparser whitespace parser is slightly more lenient
      // than the SVG spec, but that should be all right.
      pp.whitespace();
}
