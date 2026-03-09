class FacebookPost {
  final String id;
  final String message;
  final DateTime createdTime;
  final String? fullPicture;

  FacebookPost({
    required this.id,
    required this.message,
    required this.createdTime,
    required this.fullPicture,
  });

  factory FacebookPost.fromJson(Map<String, dynamic> json) {
    return FacebookPost(
      id: json['id'] as String,
      message: json['message'] as String? ?? '',
      createdTime: DateTime.parse(json['created_time'] as String),
      fullPicture: json['full_picture'] as String?,
    );
  }
}