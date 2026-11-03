# FHIRPath constraint timing

Times fhir_path 0.15.1 (through fhir_r4_path 0.14.0, fhir_r4 0.14.0) on real
R4B root constraints. Each one is evaluated in place on the HL7
blood-pressure Observation (87 nodes), with `%resource` set. The constraint
expressions are copied verbatim from `hl7.fhir.r4b.core#4.3.0`.

    dart pub get
    dart run bin/bench.dart . 200                     # JIT -> run-jit log
    dart compile exe bin/bench.dart -o bench.exe && ./bench.exe . 1000   # AOT

Results are in microseconds. Run 2026-11-03 on an AMD Ryzen 7 PRO 7840U
laptop. AOT is how Flutter release builds run. A phone is unmeasured.

- AOT: a median of 1-5 µs per constraint, and 19 µs to walk all 87 nodes (`descendants()`).
- JIT: 6-43 µs.
- Engine creation: 0.5 ms AOT, 42 ms JIT.
