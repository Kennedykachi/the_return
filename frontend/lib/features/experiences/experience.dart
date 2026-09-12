class Experience {
  const Experience({
    required this.title,
    required this.slug,
    required this.category,
    required this.region,
    required this.imageUrl,
    required this.timeCommitment,
    required this.physicalLevel,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String slug;
  final String category;
  final String region;
  final String imageUrl;
  final String timeCommitment;
  final String physicalLevel;
  final double latitude;
  final double longitude;

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        title: json['title'] as String,
        slug: json['slug'] as String,
        category: json['category'] as String,
        region: json['region'] as String,
        imageUrl: json['image_url'] as String,
        timeCommitment: json['time_commitment'] as String,
        physicalLevel: json['physical_level'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
}
