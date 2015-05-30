library svg.src.grammar;

import 'package:petitparser/petitparser.dart';

/// An implementation of the the [WC3 SVG Path Grammar]
/// (http://www.w3.org/TR/SVG/paths.html) for Dart.
class SvgGrammarDefinition extends GrammarDefinition {
  const SvgGrammarDefinition();

  @override
  start() => svgPath();

  /// wsp* moveto-drawto-command-groups? wsp*
  svgPath() =>
      whitespace().star() &
      moveToDrawToCommandGroups().optional() &
      whitespace().star();

  /// moveto-drawto-command-group
  /// | moveto-drawto-command-group wsp* moveto-drawto-command-groups
  moveToDrawToCommandGroups() =>
      (moveToDrawToCommandGroup() &
          whitespace().star() &
          ref(moveToDrawToCommandGroups))
      | moveToDrawToCommandGroup();

  /// moveto wsp* drawto-commands?
  moveToDrawToCommandGroup() =>
      moveTo() & commaWhitespace().optional() & drawToCommands();

  /// drawto-command
  /// | drawto-command wsp* drawto-commands
  drawToCommands() =>
      (drawToCommand() & whitespace().star() & ref(drawToCommands))
      | drawToCommand();

  /// closepath
  /// | lineto
  /// | horizontal-lineto
  /// | vertical-lineto
  /// | curveto
  /// | smooth-curveto
  /// | quadratic-bezier-curveto
  /// | smooth-quadratic-bezier-curveto
  /// | elliptical-arc
  drawToCommand() => closePath() | lineTo();

  /// ( "M" | "m" ) wsp* moveto-argument-sequence
  moveTo() => pattern('Mm') & whitespace().star() & moveToArgumentSequence();

  /// coordinate-pair
  /// | coordinate-pair comma-wsp? lineto-argument-sequence
  moveToArgumentSequence() =>
      (coordinatePair() &
          commaWhitespace().optional() &
          lineToArgumentSequence())
      | coordinatePair();

  /// ( "Z" | "z" )
  closePath() => pattern('Zz');

  /// ( "L" | "l" ) wsp* lineto-argument-sequence
  lineTo() => pattern('Ll') & whitespace().star() & lineToArgumentSequence();

  /// coordinate-pair
  /// | coordinate-pair comma-wsp? lineto-argument-sequence
  lineToArgumentSequence() =>
      (coordinatePair() &
          commaWhitespace().optional() &
          ref(lineToArgumentSequence))
      | coordinatePair();

  /// coordinate comma-wsp? coordinate
  coordinatePair() =>
      coordinate() & commaWhitespace().optional() & coordinate();

  /// number
  coordinate() => number();

  /// integer-constant
  /// | floating-point-constant
  nonNegativeNumber() => floatingPointConstant() | integerConstant();

  /// sign? integer-constant
  /// | sign? floating-point-constant
  number() =>
      sign().optional() & floatingPointConstant()
      | sign().optional() & integerConstant();

  /// "0" | 1
  flag() => pattern('01');

  /// (wsp+ comma? wsp*) | (comma wsp*)
  commaWhitespace() =>
      (comma() & whitespace().star())
      | (whitespace().plus() & comma().optional() & whitespace().star());

  /// ","
  comma() => char(',');

  /// digit-sequence
  integerConstant() => digitSequence();

  /// fractional-constant exponent?
  /// | digit-sequence exponent
  floatingPointConstant() =>
      fractionalConstant() & exponent().optional()
      | digitSequence() & exponent();

  /// digit-sequence? "." digit-sequence
  /// | digit-sequence "."
  fractionalConstant() =>
      (digitSequence().optional() & char('.') & digitSequence())
      | (digitSequence() & char('.'));

  /// ( "e" | "E" ) sign? digit-sequence
  exponent() => pattern('eE') & sign().optional() & digitSequence();

  /// "+" | "-"
  sign() => pattern('+-');

  /// digit
  /// | digit digit-sequence
  digitSequence() =>  digit().plus().flatten();
}
