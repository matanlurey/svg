library svg;

import 'package:petitparser/petitparser.dart';
import 'package:svg/src/command.dart';
export 'package:svg/src/command.dart';
import 'package:svg/src/parser.dart';
import 'package:quiver/iterables.dart';

final _svgPathParser = new GrammarParser(const SvgParserDefinition());

/// A mockable version of [parseSvgPath].
class SvgParser {
  const SvgParser();

  List<SvgPathSegment> parseSvgPath(String svgPath) {
    return concat(_svgPathParser.parse(svgPath).value).toList(growable: false);
  }
}

/// Parses [svgPath], returning a parsed list of [SvgPathCommand]s that can be
/// followed in order to render a graphic.
///
/// For example:
///     `parseSvgPath('M0,15,L15,15L7.5,0z')`
///
/// Outputs:
///     `[SvgPathMoveSegment, SvgPathLineSegment, .., SvgPathClose]`
List<SvgPathSegment> parseSvgPath(String svgPath) {
  return const SvgParser().parseSvgPath(svgPath);
}
