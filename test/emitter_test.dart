library svg.test.emitter_test;

import 'package:svg/src/emitter.dart';
import 'package:test/test.dart';

void main() {
  test('parseSvgPath converts SVG to raw Dart code', () {
    final arrayRef = svgPathToSource('M0,15,L15,15L7.5,0z');
    print(arrayRef.toSource());
    expect(
        arrayRef.toSource(),
        'const <SvgPathSegment> ['
          'const SvgPathMoveSegment(0, 15), '
          'const SvgPathLineSegment(15, 15), '
          'const SvgPathLineSegment(7.5, 0), '
          'const SvgPathClose()'
        ']');
  });
}
