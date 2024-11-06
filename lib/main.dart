import 'package:fhir_validation/test/fhir_validation_tests.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// Main application widget
class MyApp extends StatelessWidget {
  /// Default constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    fhirValidationTest();
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {},
              child: const SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: Text(
                    'Press me',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
