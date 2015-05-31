SVG
===

[![Build Status](https://drone.io/github.com/matanlurey/svg/status.png)](https://drone.io/github.com/matanlurey/svg/latest)

A pure-dart implementation of an SVG parser. The end goal of this package is to
provide a semi-full featured implementation that is able to run in both the
browser and on the server (or command line tooling).

Example
---

```dart
import 'package:svg/svg.path';

void main() {
  // Parses an "up-arrow" shape segment.
  print(parseSvgPath('M0,15,L15,15L7.5,0z'));

  // Outputs:
  // [
  //   SvgPathMoveSegment {x: 0, y: 15, isRelative: false},
  //   SvgPathLineSegment {x: 15, y: 15, isRelative: false}, 
  //   SvgPathLineSegment {x: 7.5, y: 0, isRelative: false}, 
  //   SvgPathClose {}
  // ]
}
```

Currently supported
---

- Parsing a single SVG path that contains move, line, and close commands.
