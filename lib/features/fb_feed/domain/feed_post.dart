class FeedPost {
  final String id;
  final String message;
  final DateTime createdTime;
  final String? fullPicture;
  final String source;

  final String? severity;
  final String? location;
  final String? road;
  final String? vehicleType;
  final bool injuryReported;
  final bool roadBlocked;

  final bool isAccidentRelated;
  final double confidence;
  final int sentimentScore;
  final List<String> possibleLocations;
  final List<String> keywords;
  final String? nlpSummary;

  FeedPost({
    required this.id,
    required this.message,
    required this.createdTime,
    required this.source,
    this.fullPicture,
    this.severity,
    this.location,
    this.road,
    this.vehicleType,
    this.injuryReported = false,
    this.roadBlocked = false,
    this.isAccidentRelated = false,
    this.confidence = 0.0,
    this.sentimentScore = 0,
    this.possibleLocations = const [],
    this.keywords = const [],
    this.nlpSummary,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdTime: DateTime.parse(json['createdTime'].toString()),
      fullPicture: json['fullPicture']?.toString(),
      source: json['source']?.toString() ?? 'facebook',
      severity: json['severity']?.toString(),
      location: json['location']?.toString(),
      road: json['road']?.toString(),
      vehicleType: json['vehicleType']?.toString(),
      injuryReported: json['injuryReported'] == true,
      roadBlocked: json['roadBlocked'] == true,
      isAccidentRelated: json['isAccidentRelated'] == true,
      confidence: (json['confidence'] is num)
          ? (json['confidence'] as num).toDouble()
          : double.tryParse(json['confidence']?.toString() ?? '0') ?? 0.0,
      sentimentScore: (json['sentimentScore'] is num)
          ? (json['sentimentScore'] as num).toInt()
          : int.tryParse(json['sentimentScore']?.toString() ?? '0') ?? 0,
      possibleLocations: (json['possibleLocations'] is List)
          ? List<String>.from(
              (json['possibleLocations'] as List)
                  .map((e) => e.toString())
                  .where((e) => e.trim().isNotEmpty),
            )
          : const [],
      keywords: (json['keywords'] is List)
          ? List<String>.from(
              (json['keywords'] as List)
                  .map((e) => e.toString())
                  .where((e) => e.trim().isNotEmpty),
            )
          : const [],
      nlpSummary: json['nlpSummary']?.toString(),
    );
  }
}