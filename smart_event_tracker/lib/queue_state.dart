import 'package:flutter/foundation.dart';

class QueueToken {
  final String id;
  final String service;
  final String name;
  final DateTime issuedAt;
  final int ahead;
  final int waitMin;
  const QueueToken({
    required this.id,
    required this.service,
    required this.name,
    required this.issuedAt,
    required this.ahead,
    required this.waitMin,
  });
}

/// The visitor's currently active token (null = none). Shared between the
/// "Get Token" and "My Queue" tabs.
final ValueNotifier<QueueToken?> myToken = ValueNotifier<QueueToken?>(null);

int _seq = 0;
String nextTokenId(String prefix) => '#$prefix-${110 + _seq++}';
