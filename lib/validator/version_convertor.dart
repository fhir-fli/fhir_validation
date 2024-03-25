import 'dart:convert';
import 'dart:typed_data';
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/stu3.dart' as stu3;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;

import 'validation.dart';

class VersionConvertor {
  static Uint8List convertVersionNativeR2(
      String targetVer, Content cnt, FhirFormat format) {
    dstu2.Resource resource;
    switch (cnt.cntType) {
      case FhirFormat.json:
        {
          String jsonString = utf8.decode(cnt.focus!);
          resource = dstu2.Resource.fromJson(jsonDecode(jsonString));
          break;
        }
      default:
        throw UnsupportedError(
            'Unsupported input format: ${cnt.cntType.toString()}');
    }

    if (VersionUtilities.isR2Ver(targetVer)) {
      return _getBytesDstu2(cnt, format, resource);
    } else {
      throw UnsupportedError('Target Version not supported yet: $targetVer');
    }
  }

  static Uint8List convertVersionNativeR3(
      String targetVer, Content cnt, FhirFormat format) {
    stu3.Resource resource;
    switch (cnt.cntType) {
      case FhirFormat.json:
        {
          String jsonString = utf8.decode(cnt.focus!);
          resource = stu3.Resource.fromJson(jsonDecode(jsonString));
          break;
        }
      default:
        throw UnsupportedError(
            'Unsupported input format: ${cnt.cntType.toString()}');
    }

    if (VersionUtilities.isR3Ver(targetVer)) {
      return _getBytesR3(cnt, format, resource);
    } else {
      throw UnsupportedError('Target Version not supported yet: $targetVer');
    }
  }

  static Uint8List convertVersionNativeR4(
      String targetVer, Content cnt, FhirFormat format) {
    r4.Resource resource;
    switch (cnt.cntType) {
      case FhirFormat.json:
        {
          String jsonString = utf8.decode(cnt.focus!);
          resource = r4.Resource.fromJson(jsonDecode(jsonString));
          break;
        }
      default:
        throw UnsupportedError(
            'Unsupported input format: ${cnt.cntType.toString()}');
    }

    if (VersionUtilities.isR4Ver(targetVer)) {
      return _getBytesR4(cnt, format, resource);
    } else {
      throw UnsupportedError('Target Version not supported yet: $targetVer');
    }
  }

  static Uint8List convertVersionNativeR5(
      String targetVer, Content cnt, FhirFormat format) {
    r5.Resource resource;
    switch (cnt.cntType) {
      case FhirFormat.json:
        {
          String jsonString = utf8.decode(cnt.focus!);
          resource = r5.Resource.fromJson(jsonDecode(jsonString));
          break;
        }
      default:
        throw UnsupportedError(
            'Unsupported input format: ${cnt.cntType.toString()}');
    }

    if (VersionUtilities.isR5Ver(targetVer)) {
      return _getBytesR5(cnt, format, resource);
    } else {
      throw UnsupportedError('Target Version not supported yet: $targetVer');
    }
  }

  static Uint8List _getBytesDstu2(
      Content cnt, FhirFormat format, dstu2.Resource r2) {
    switch (format) {
      case FhirFormat.json:
        String jsonString = jsonEncode(r2.toJson());
        return Uint8List.fromList(utf8.encode(jsonString));
      default:
        throw Exception('Unsupported output format: ${cnt.cntType.toString()}');
    }
  }

  static Uint8List _getBytesR3(
      Content cnt, FhirFormat format, stu3.Resource r3) {
    switch (format) {
      case FhirFormat.json:
        String jsonString = jsonEncode(r3.toJson());
        return Uint8List.fromList(utf8.encode(jsonString));
      default:
        throw Exception('Unsupported output format: ${cnt.cntType.toString()}');
    }
  }

  static Uint8List _getBytesR4(Content cnt, FhirFormat format, r4.Resource r4) {
    switch (format) {
      case FhirFormat.json:
        String jsonString = jsonEncode(r4.toJson());
        return Uint8List.fromList(utf8.encode(jsonString));
      default:
        throw Exception('Unsupported output format: ${cnt.cntType.toString()}');
    }
  }

  static Uint8List _getBytesR5(Content cnt, FhirFormat format, r5.Resource r5) {
    switch (format) {
      case FhirFormat.json:
        String jsonString = jsonEncode(r5.toJson());
        return Uint8List.fromList(utf8.encode(jsonString));
      default:
        throw Exception('Unsupported output format: ${cnt.cntType.toString()}');
    }
  }
}
