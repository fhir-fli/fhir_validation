// Helper function to extract profiles from the resource
List<String> extractProfiles(Map<String, dynamic> resource) {
  List<String> profiles = [];
  if (resource.containsKey('meta') && resource['meta'].containsKey('profile')) {
    profiles = List<String>.from(resource['meta']['profile']);
  }
  return profiles;
}
