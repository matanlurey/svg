library svg.src.emitter;

import 'dart:mirrors';

import 'package:dart_builder/dart_builder.dart';
import 'package:svg/svg.dart';

SourceFile svgPathsToSource(
    Map<String, String> svgPaths, {
    String libraryName: 'svg.generated'}) {
  /*
  final buffer = new StringBuffer();
  final elements = <Source> [];
  svgPaths.forEach((iconName, svgPath) {});
  return new SourceFile.library(
      libraryName,
      imports: [new ImportDirective(Uri.parse('package:svg/svg.dart'))],
      topLevelElements: elements);
  */
  throw new UnimplementedError();
}

ArrayRef svgPathToSource(String svgPath) {
  final values = parseSvgPath(svgPath).map((parsedPath) {
    final mirror = reflect(parsedPath);
    final typeRef = new DartType(MirrorSystem.getName(mirror.type.simpleName));

    InvokeMethod invoke({
                        List<Source> positionalArguments: const [],
                        Map<String, Source> namedArguments: const {}}) {
      return new InvokeMethod.constructor(
          typeRef,
          isConst: true,
          positionalArguments: positionalArguments,
          namedArguments: namedArguments);
    }
    if (parsedPath is SvgPathClose) {
      return invoke();
    }
    if (parsedPath is SvgPathLineSegment || parsedPath is SvgPathMoveSegment) {
      return invoke(
          positionalArguments: [
            new Source.fromDart(parsedPath.x.toString()),
            new Source.fromDart(parsedPath.y.toString())
          ],
          namedArguments: {
            'isRelative': new Source.fromDart(parsedPath.isRelative.toString())
          });
    }
    if (parsedPath is SvgPathCurveQuadraticSegment) {
      return invoke(
          positionalArguments: [
            new Source.fromDart(parsedPath.x.toString()),
            new Source.fromDart(parsedPath.y.toString()),
            new Source.fromDart(parsedPath.x1.toString()),
            new Source.fromDart(parsedPath.y1.toString()),
          ],
          namedArguments: {
            'isRelative': new Source.fromDart(parsedPath.isRelative.toString())
          });
    }
    if (parsedPath is SvgPathCurveCubicSegment) {
      return invoke(
          positionalArguments: [
            new Source.fromDart(parsedPath.x.toString()),
            new Source.fromDart(parsedPath.y.toString()),
            new Source.fromDart(parsedPath.x1.toString()),
            new Source.fromDart(parsedPath.y1.toString()),
            new Source.fromDart(parsedPath.x2.toString()),
            new Source.fromDart(parsedPath.y2.toString()),
          ],
          namedArguments: {
            'isRelative': new Source.fromDart(parsedPath.isRelative.toString())
          });
    }
    if (parsedPath is SvgPathArcSegment) {
      return invoke(
          positionalArguments: [
            new Source.fromDart(parsedPath.x.toString()),
            new Source.fromDart(parsedPath.y.toString()),
            new Source.fromDart(parsedPath.r1.toString()),
            new Source.fromDart(parsedPath.r2.toString()),
            new Source.fromDart(parsedPath.angle.toString()),
          ],
          namedArguments: {
            'isRelative': new Source.fromDart(parsedPath.isRelative.toString()),
            'isLargeArc': new Source.fromDart(parsedPath.isLargeArc.toString()),
            'isSweep': new Source.fromDart(parsedPath.isSweep.toString()),
          });
    }
  });
  return new ArrayRef(
      values: values.toList(growable: false),
      isConst: true,
      typeRef: new DartType('SvgPathSegment'));
}
