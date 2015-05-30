library svg;

import 'package:petitparser/petitparser.dart';
import 'package:svg/src/command.dart';
export 'package:svg/src/command.dart';
import 'package:svg/src/parser.dart';
import 'package:quiver/iterables.dart';

const _svgPathParserDefinition = const SvgParserDefinition();
final _svgPathParser = new GrammarParser(_svgPathParserDefinition);

/// Parses [svgPath], returning a parsed list of [SvgPathCommand]s that can be
/// followed in order to render a graphic.
///
/// For example:
///     `parseSvgPath('M0,15,L15,15L7.5,0z')`
///
/// Outputs:
///     `[MoveToPathCommand, LineToPathCommand, .., ClosePathCommand]`
List<SvgPathCommand> parseSvgPath(String svgPath) {
  return concat(_svgPathParser.parse(svgPath).value).toList(growable: false);
}
