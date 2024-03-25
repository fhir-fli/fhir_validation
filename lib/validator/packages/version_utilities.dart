class VersionUtilities {
  static bool isR6Ver(String? ver) {
    return ver != null && (ver.startsWith("6.0"));
  }

  static bool isR5Ver(String? ver) {
    return ver != null && (ver.startsWith("5.0"));
  }

  static bool isR4BVer(String? ver) {
    return ver != null && (ver.startsWith("4.1") || ver.startsWith("4.3"));
  }

  static bool isR4Ver(String? ver) {
    return ver != null && ver.startsWith("4.0");
  }

  static bool isR3Ver(String? ver) {
    return ver != null && ver.startsWith("3.0");
  }

  static bool isR2BVer(String? ver) {
    return ver != null && ver.startsWith("1.4");
  }

  static bool isR2Ver(String? ver) {
    return ver != null && ver.startsWith("1.0");
  }
}
