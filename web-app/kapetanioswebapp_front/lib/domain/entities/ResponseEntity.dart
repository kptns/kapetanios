import 'dart:convert';

class Responseentity {
	bool success;
	String message;
	dynamic data;
 bool get getSuccess => this.success;

 set setSuccess(bool success) => this.success = success;

 	String get getMessage => this.message;

 set setMessage(	String message) => this.message = message;

 	dynamic get getData => this.data;

 set setData(	dynamic data) => this.data = data;
  Responseentity({
    required this.success,
    required this.message,
    required this.data,
  });

	

  Responseentity copyWith({
    bool? success,
    String? message,
    dynamic? data,
  }) {
    return Responseentity(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory Responseentity.fromMap(Map<String, dynamic> map) {
    return Responseentity(
      success: map['success'] as bool,
      message: map['message'] as String,
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Responseentity.fromJson(String source) => Responseentity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Responseentity(success: $success, message: $message, data: $data)';

  @override
  bool operator ==(covariant Responseentity other) {
    if (identical(this, other)) return true;
  
    return 
      other.success == success &&
      other.message == message &&
      other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}
