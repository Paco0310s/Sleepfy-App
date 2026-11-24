class ContentSections {
  static const String insomniaCard = 'insomnia_card';
  static const String insomniaLink = 'insomnia_link';
  static const String meditation = 'meditation';
  static const String meditationVideo = 'meditation_video';
  static const String music = 'music';
  static const String podcast = 'podcast';
  static const String challenge = 'challenge';
  static const String homeBanner = 'home_banner';
}

class ContentItemModel {
  final int id;
  final String section;
  final String title;
  final String? subtitle;
  final String? body;
  final String? url;
  final String? imageUrl;
  final String? iconKey;
  final int sortOrder;
  final bool isActive;

  ContentItemModel({
    required this.id,
    required this.section,
    required this.title,
    this.subtitle,
    this.body,
    this.url,
    this.imageUrl,
    this.iconKey,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory ContentItemModel.fromJson(Map<String, dynamic> json) {
    return ContentItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      section: json['section']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      body: json['body']?.toString(),
      url: json['url']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      iconKey: json['iconKey']?.toString(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] != false,
    );
  }
}
