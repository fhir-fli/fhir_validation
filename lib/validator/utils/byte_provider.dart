import 'dart:io';
import 'dart:async';

abstract class ByteProvider {
  Future<List<int>> getBytes();

  static ByteProvider forStream(Stream<List<int>> stream) {
    return _ByteProviderStream(stream);
  }

  static ByteProvider forBytes(List<int> bytes) {
    return _ByteProviderBytes(bytes);
  }

  static ByteProvider forFile(File file) {
    return _ByteProviderFile(file);
  }

  static ByteProvider forFilePath(String src) {
    return _ByteProviderFile(File(src));
  }
}

class _ByteProviderStream extends ByteProvider {
  final Stream<List<int>> stream;

  _ByteProviderStream(this.stream);

  @override
  Future<List<int>> getBytes() async {
    List<int> bytes = [];
    await for (var chunk in stream) {
      bytes.addAll(chunk);
    }
    return bytes;
  }
}

class _ByteProviderBytes extends ByteProvider {
  final List<int> _bytes;

  _ByteProviderBytes(this._bytes);

  @override
  Future<List<int>> getBytes() async {
    return _bytes;
  }
}

class _ByteProviderFile extends ByteProvider {
  final File _file;

  _ByteProviderFile(this._file);

  @override
  Future<List<int>> getBytes() async {
    try {
      return _file.readAsBytes();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
