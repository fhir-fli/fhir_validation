import 'package:flutter/material.dart';

import 'package:fhir_validation/test/fhir_validation_tests.dart';

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
        child: const SizedBox(
          child: Center(
              child: Text(
            'Press me',
            style: TextStyle(fontSize: 20),
          ),),
          height: 200,
          width: 200,
        ),
      ),
    ),),),);
  }
}
