String fullPathFromStartAndCurrent(String startPath, String currentPath) {
  var pathList = currentPath.split('.');
  pathList.removeAt(0);
  pathList = [startPath, ...pathList];
  final path = pathList.join('.');
  return path;
}
