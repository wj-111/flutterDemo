class Album {
  final int code;
  final String data;
  final String message;

  const Album({
    required this.code,
    required this.data,
    required this.message,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      code: json['code'] as int,
      data: json['data'] as String,
      message: json['message'] as String,
    );
  }
}
