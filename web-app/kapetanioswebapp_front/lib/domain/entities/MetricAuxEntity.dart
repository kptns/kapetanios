// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MetricAux {
  double? x;
  double? y;
  MetricAux({
    this.x,
    this.y,
  });

  MetricAux copyWith({
    double? x,
    double? y,
  }) {
    return MetricAux(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  factory MetricAux.fromMap(Map<String, dynamic> map) {
    return MetricAux(
      x: map['x'] as double,
      y: map['y'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MetricAux.fromJson(String source) => MetricAux.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MetricAux(x: $x, y: $y)';

  @override
  bool operator ==(covariant MetricAux other) {
    if (identical(this, other)) return true;
  
    return 
      other.x == x &&
      other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
