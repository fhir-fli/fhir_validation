import 'package:fhir_r4/fhir_r4.dart';
import 'dart/conceptmaps.dart';
import 'dart/dataelements.dart';
import 'dart/extension-definitions.dart';
import 'dart/profiles-others.dart';
import 'dart/profiles-resources.dart';
import 'dart/profiles-types.dart';
import 'dart/search-parameters.dart';
import 'dart/valuesets.dart';

List<Resource> getResources() {
  List<Resource> resources = <Resource>[];
  for (final BundleEntry entry in conceptmaps.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in dataelements.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry
      in extensiondefinitions.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in profilesothers.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in profilesresources.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in profilestypes.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in searchparameters.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  for (final BundleEntry entry in valuesets.entry ?? <BundleEntry>[]) {
    if (entry.resource != null) {
      resources.add(entry.resource!);
    }
  }
  return resources;
}
