import 'package:flutter/material.dart';

import 'test/fhir_validation_tests.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
                body: Center(
      child: ElevatedButton(
        onPressed: () async {
          await fhirValidationTest();
        },
        child: SizedBox(
          child: Center(
              child: const Text(
            'Press me',
            style: TextStyle(fontSize: 20),
          )),
          height: 200.0,
          width: 200.0,
        ),
      ),
    ))));
  }
}
