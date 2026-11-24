import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/kit_product_model.dart';
import 'package:sleepfy/models/response_model.dart';

class KitProductController {
  static Future<List<KitProductModel>> getActiveProducts() async {
    try {
      final ResponseModel resp = await DioController.petition(
        HTTPMethods.get,
        'kit-products',
        showLoading: false,
      );

      if (resp.status == 200 && resp.data is List) {
        final list = (resp.data as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => KitProductModel.fromJson(e))
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {
      // Fallback local si no hay conexión o el servidor aún no despliega
    }

    return getLocalFallbackProducts();
  }

  static Future<List<KitProductModel>> getAdminProducts() async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'kit-products/admin',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is List) {
      return (resp.data as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => KitProductModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<KitProductModel?> createProduct(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'kit-products',
      data: data,
    );

    if ((resp.status == 201 || resp.status == 200) && resp.data is Map<String, dynamic>) {
      return KitProductModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<KitProductModel?> updateProduct(int id, Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'kit-products/$id',
      data: data,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return KitProductModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> deleteProduct(int id) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'kit-products/$id',
    );
    return resp.status == 200;
  }

  static Future<KitProductModel?> uploadImage(int id, List<int> bytes, String filename) async {
    final ResponseModel resp = await DioController.uploadFile(
      'kit-products/$id/image',
      'image',
      bytes,
      filename,
    );

    if ((resp.status == 200 || resp.status == 201) && resp.data is Map<String, dynamic>) {
      return KitProductModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<KitProductModel?> deleteImage(int id) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'kit-products/$id/image',
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return KitProductModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<KitSettingsModel> getSettings() async {
    try {
      final ResponseModel resp = await DioController.petition(
        HTTPMethods.get,
        'kit-products/settings',
        showLoading: false,
      );
      if (resp.status == 200 && resp.data is Map<String, dynamic>) {
        return KitSettingsModel.fromJson(resp.data as Map<String, dynamic>);
      }
    } catch (_) {
      // Fallback local
    }
    return KitSettingsModel.defaults();
  }

  static Future<KitSettingsModel?> updateSettings(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'kit-products/settings',
      data: data,
    );
    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return KitSettingsModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static List<KitProductModel> getLocalFallbackProducts() {
    return [
      KitProductModel(
        id: 0,
        title: 'Spray de Magnesio',
        description:
            'El Spray de Magnesio a base de Cloruro de Magnesio está enfocado a quienes buscan una alternativa natural para relajar músculos y calmar el sistema nervioso.',
        benefits: '◆ Ayuda a relajar los músculos, alivia la tensión acumulada y reduce el estrés nocturno.',
        usage: 'Aplicar 3-5 atomizaciones en la planta de los pies o cuello antes de dormir.',
        warning: 'Solo para uso externo. Evitar contacto con ojos y heridas abiertas.',
        stock: 10,
      ),
      KitProductModel(
        id: 0,
        title: 'Vela Aromática',
        description: 'Combina aceites esenciales de lavanda y notas frescas de bosque, perfecta para acompañar la desconexión nocturna.',
        benefits: '◆ Lavanda: Relaja y reduce el estrés.\n◆ Bosque: Calma la mente y promueve un sueño profundo.',
        usage: 'Enciende la vela 30 minutos antes de acostarte. Asegúrate de apagarla antes de dormir.',
        warning: 'Nunca dejes una vela encendida sin supervisión.',
        stock: 10,
      ),
      KitProductModel(
        id: 0,
        title: 'Tés Anti Insomnio',
        description: 'Infusiones naturales seleccionadas para apaciguar el sistema digestivo y nervioso.',
        benefits: '◆ Té de Manzanilla: Sedante natural y antiinflamatorio.\n◆ Té de 7 Azahares: Reduce la ansiedad y propicia el sueño profundo.',
        usage: 'Tomar una taza tibia 30-45 minutos antes de dormir.',
        warning: 'Consérvese en un lugar fresco y seco.',
        stock: 10,
      ),
      KitProductModel(
        id: 0,
        title: 'Bálsamo Relajante',
        description: 'Bálsamo botánico formulado para liberar tensión mediante aromaterapia y digitopuntura suave.',
        benefits: '◆ Lavanda y Manzanilla: Inducen tranquilidad.\n◆ Vitamina E y Cera de Abeja: Nutren la piel.',
        usage: 'Aplica suavemente en sienes, detrás de las orejas y en las muñecas antes de acostarte.',
        warning: 'Uso tópico únicamente. Evitar el contacto con los ojos.',
        stock: 10,
      ),
      KitProductModel(
        id: 0,
        title: 'Aromatizante de Espacios',
        description: 'Bruma ambiental con aceites esenciales de lavanda, manzanilla, violeta y mandarina.',
        benefits: '◆ Transforma tu habitación en un santuario oscuro, fresco y aromatizado para el descanso.',
        usage: 'Rocía 2-4 veces en la almohada y en el ambiente unos minutos antes de dormir.',
        warning: 'Mantener fuera del alcance de los niños.',
        stock: 10,
      ),
    ];
  }
}
