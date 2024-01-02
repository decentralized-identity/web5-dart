import 'dart:convert';
import 'dart:typed_data';

import 'package:tbdex/src/dns_packet/rdata.dart';

class DnsTxtData implements RData {
  final List<String> data;

  @override
  int numBytes;

  DnsTxtData._(this.data, this.numBytes);

  factory DnsTxtData.decode(Uint8List buf, int offset) {
    final originalOffset = offset;
    int remaining = ByteData.sublistView(buf).getUint16(offset, Endian.big);
    offset += 2;

    final List<String> data = [];
    while (remaining > 0) {
      final len = buf[offset++];
      remaining--;
      if (remaining < len) {
        throw Exception('Buffer overflow');
      }

      final text = String.fromCharCodes(buf.sublist(offset, offset + len));
      data.add(text);
      offset += len;
      remaining -= len;
    }

    final numBytes = offset - originalOffset;
    return DnsTxtData._(data, numBytes);
  }

  int encodingLength() {
    int length = 2;
    for (var buf in data) {
      length += utf8.encode(buf).length + 1;
    }
    return length;
  }

  @override
  DnsTxtData encode() {
    throw UnimplementedError();
  }
}
