import 'package:sleepfy/controllers/dio_controller.dart';

class KitProductModel {
  final int id;
  final String title;
  final String description;
  final String benefits;
  final String usage;
  final String? warning;
  final int stock;
  final bool isActive;
  final int sortOrder;
  final bool hasImage;
  final String? updatedAt;

  KitProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.benefits,
    required this.usage,
    this.warning,
    this.stock = 0,
    this.isActive = true,
    this.sortOrder = 0,
    this.hasImage = false,
    this.updatedAt,
  });

  factory KitProductModel.fromJson(Map<String, dynamic> json) {
    return KitProductModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      benefits: json['benefits']?.toString() ?? '',
      usage: json['usage']?.toString() ?? '',
      warning: json['warning']?.toString(),
      stock: (json['stock'] is num) ? (json['stock'] as num).toInt() : 0,
      isActive: json['isActive'] != false,
      sortOrder: (json['sortOrder'] is num) ? (json['sortOrder'] as num).toInt() : 0,
      hasImage: json['hasImage'] == true,
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  String? get imageUrl {
    if (!hasImage || id <= 0) return null;
    final versionQuery = updatedAt != null ? '?v=${Uri.encodeComponent(updatedAt!)}' : '';
    return '${DioController.baseUrl}kit-products/$id/image$versionQuery';
  }
}

class KitSettingsModel {
  final String instagramUrl;
  final String whatsapp1;
  final String whatsapp2;

  KitSettingsModel({
    required this.instagramUrl,
    required this.whatsapp1,
    required this.whatsapp2,
  });

  factory KitSettingsModel.fromJson(Map<String, dynamic> json) {
    return KitSettingsModel(
      instagramUrl: json['instagramUrl']?.toString() ?? 'https://www.instagram.com/_sleepfy/',
      whatsapp1: json['whatsapp1']?.toString() ?? '3921694141',
      whatsapp2: json['whatsapp2']?.toString() ?? '',
    );
  }

  factory KitSettingsModel.defaults() {
    return KitSettingsModel(
      instagramUrl: 'https://www.instagram.com/_sleepfy/',
      whatsapp1: '3921694141',
      whatsapp2: '3929308377',
    );
  }
}
