library svg.emitter;

import 'dart:mirrors';

import 'package:dart_builder/dart_builder.dart';
import 'package:svg/svg.dart';

/// Uses reflection to analyze [svgPathSegment], and convert into Dart source.
///
/// This should only be used in dart:io-based tooling, not in client code.
Source _convertToSource(SvgPathSegment svgPathSegment) {
  final ClassMirror classMirror = reflectType(svgPathSegment.runtimeType);
  final className = classMirror.simpleName;
  final instanceMirror = reflect(svgPathSegment);
  final MethodMirror constructorMirror = classMirror.declarations[className];

  // Convert the ClassMirror to a TypeRef.
  final typeRef = new TypeRef(MirrorSystem.getName(className));

  // Analyze the constructor to determine arguments.
  var positionalArguments = <Source> [];
  var namedArguments = <String, Source> {};
  constructorMirror.parameters.forEach((param) {
    final paramName = MirrorSystem.getName(param.simpleName);
    final paramValue = instanceMirror.getField(param.simpleName).reflectee;
    final sourceValue = new Source.fromDart(paramValue.toString());
    if (!param.isNamed) {
      positionalArguments.add(sourceValue);
    } else if (param.hasDefaultValue &&
               paramValue != param.defaultValue.reflectee) {
      namedArguments[paramName] = sourceValue;
    }
  });

  // Return a constructor invoke Source.
  return new CallRef.constructor(
      typeRef,
      isConst: true,
      positionalArguments: positionalArguments,
      namedArguments: namedArguments);
}

/// Parses [svgPath] and converts it into an [ArrayRef] of constructor calls.
///
/// Returns a generated source array.
///
/// This should only be used in dart:io-based tooling, not in client code.
ArrayRef svgPathToSource(String svgPath) {
  final values = parseSvgPath(svgPath).map(_convertToSource);
  return new ArrayRef(
      values: values.toList(growable: false),
      isConst: true,
      typeRef: const TypeRef('SvgPathSegment'));
}
