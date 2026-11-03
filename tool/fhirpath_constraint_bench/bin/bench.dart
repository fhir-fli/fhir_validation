// Times fhir_path 0.15.1 (via fhir_r4_path) on real R4B root constraints,
// evaluated in place on the HL7 blood-pressure Observation with %resource set.
// Writes one line per expression to results.tsv as it goes.
// Constraint expressions are verbatim from the spec, so long lines stay.
// ignore_for_file: avoid_print, lines_longer_than_80_chars
import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';

const exprs = <String, String>{
  'obs-6': 'dataAbsentReason.empty() or value.empty()',
  'obs-7':
      'value.empty() or '
      'component.code.where(coding.intersect(%resource.code.coding).exists())'
      '.empty()',
  'dom-2': 'contained.contained.empty()',
  'dom-3':
      "contained.where(((id.exists() and ('#'+id in (%resource.descendants().reference | %resource.descendants().as(canonical) | %resource.descendants().as(uri) | %resource.descendants().as(url)))) or descendants().where(reference = '#').exists() or descendants().where(as(canonical) = '#').exists() or descendants().where(as(uri) = '#').exists()).not()).trace('unmatched', id).empty()",
  'dom-4':
      'contained.meta.versionId.empty() and contained.meta.lastUpdated.empty()',
  'dom-5': 'contained.meta.security.empty()',
  'dom-6': 'text.`div`.exists()',
  'ele-1-root':
      'hasValue() or (children().count() > id.count()) or \$this is Parameters',
  'descendants': 'descendants().count()',
};

Future<void> main(List<String> args) async {
  final dir = args.first;
  final iterations = int.parse(args[1]);
  final out =
      File('$dir/results.tsv').openSync(mode: FileMode.write)
        ..writeStringSync(
          'key\tparse_us\teval_median_us\teval_p95_us\tresult\n',
        )
        ..flushSync();
  final obs = Observation.fromJson(
    jsonDecode(
          File(
            '$dir/data/observation-example-bloodpressure.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>,
  );
  final sw = Stopwatch()..start();
  final engine = await FHIRPathEngine.create(WorkerContext());
  print('engine create ${sw.elapsedMicroseconds} us');
  out.writeStringSync('# engine_create_us\t${sw.elapsedMicroseconds}\n');

  for (final e in exprs.entries) {
    sw.reset();
    final node = engine.parse(e.value);
    final parseUs = sw.elapsedMicroseconds;
    final times = <int>[];
    List<dynamic>? result;
    for (var i = 0; i < iterations; i++) {
      sw.reset();
      result = await engine.evaluateWithContext(null, obs, obs, obs, node);
      times.add(sw.elapsedMicroseconds);
    }
    times.sort();
    final median = times[times.length ~/ 2];
    final p95 = times[(times.length * 95) ~/ 100];
    final line = '${e.key}\t$parseUs\t$median\t$p95\t$result\n';
    out
      ..writeStringSync(line)
      ..flushSync();
    print(line.trim());
  }
  out.closeSync();
}
