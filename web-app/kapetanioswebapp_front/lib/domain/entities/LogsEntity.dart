import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogEntity {
  final String id;
  final String hostname;
  final String logLevel;
  final String message;
  final String source;
  final DateTime timestamp;

  LogEntity({
    required this.id,
    required this.hostname,
    required this.logLevel,
    required this.message,
    required this.source,
    required this.timestamp,
  });

  static DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate(); // Si viene como Timestamp
      } else if (timestamp is String) {
        return DateTime.parse(timestamp); // Si viene como String
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now(); // Manejo de error
    }
  }

  factory LogEntity.fromMap(Map<String, dynamic> data, String id) {
    return LogEntity(
      id: id,
      hostname: data['hostname'] ?? '',
      logLevel: data['log_level'] ?? 'INFO',
      message: data['message'] ?? '',
      source: data['source'] ?? '',
      timestamp: _parseTimestamp(data['timestamp'])
    );
  }
}