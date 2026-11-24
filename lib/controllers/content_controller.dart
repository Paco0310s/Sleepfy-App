import 'package:sleepfy/controllers/dio_controller.dart';
import 'package:sleepfy/models/content_item_model.dart';
import 'package:sleepfy/models/response_model.dart';

class ContentController {
  static Future<List<ContentItemModel>> getActiveBySection(String section) async {
    try {
      final ResponseModel resp = await DioController.petition(
        HTTPMethods.get,
        'content?section=${Uri.encodeQueryComponent(section)}',
        showLoading: false,
      );

      if (resp.status == 200 && resp.data is List) {
        final list = (resp.data as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => ContentItemModel.fromJson(e))
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {
      // Fallback local si no hay conexión
    }

    return getLocalFallback(section);
  }

  static Future<List<ContentItemModel>> getAdminBySection(String section) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.get,
      'content/admin?section=${Uri.encodeQueryComponent(section)}',
      showLoading: false,
    );

    if (resp.status == 200 && resp.data is List) {
      return (resp.data as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ContentItemModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<ContentItemModel?> createItem(Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.post,
      'content',
      data: data,
    );

    if ((resp.status == 201 || resp.status == 200) && resp.data is Map<String, dynamic>) {
      return ContentItemModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ContentItemModel?> updateItem(int id, Map<String, dynamic> data) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.patch,
      'content/$id',
      data: data,
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return ContentItemModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> deleteItem(int id) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'content/$id',
    );
    return resp.status == 200;
  }

  static Future<ContentItemModel?> uploadImage(
    int id,
    List<int> bytes,
    String filename,
  ) async {
    final ResponseModel resp = await DioController.uploadFile(
      'content/$id/image',
      'image',
      bytes,
      filename,
    );

    if ((resp.status == 200 || resp.status == 201) && resp.data is Map<String, dynamic>) {
      return ContentItemModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ContentItemModel?> deleteImage(int id) async {
    final ResponseModel resp = await DioController.petition(
      HTTPMethods.delete,
      'content/$id/image',
    );

    if (resp.status == 200 && resp.data is Map<String, dynamic>) {
      return ContentItemModel.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  static List<ContentItemModel> getLocalFallback(String section) {
    switch (section) {
      case ContentSections.insomniaCard:
        return [
          ContentItemModel(
            id: 0,
            section: section,
            title: '¿Qué es el Insomnio?',
            body:
                'El insomnio es un trastorno del sueño caracterizado por la dificultad para conciliar el sueño, mantenerse dormido o lograr un descanso verdaderamente reparador. Puede manifestarse de forma aguda (corto plazo) o crónica (más de 3 meses).',
            iconKey: 'help',
            sortOrder: 1,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Características del Insomnio',
            body:
                '◆ Dificultad para conciliar el sueño (tardar más de 30 minutos).\n'
                '◆ Despertares frecuentes e interrupciones durante la noche.\n'
                '◆ Despertarse mucho antes de lo deseado sin poder volver a dormir.\n'
                '◆ Sensación de sueño no reparador y cansancio diurno.',
            iconKey: 'warning',
            sortOrder: 2,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: '¿Cómo Afecta el Insomnio?',
            body:
                '◆ Fatiga persistente y bajo nivel de energía.\n'
                '◆ Dificultad para concentrarse y problemas de retención o memoria.\n'
                '◆ Mayor irritabilidad, ansiedad y fluctuaciones del estado de ánimo.\n'
                '◆ Disminución en la respuesta del sistema inmunológico.',
            iconKey: 'healing',
            sortOrder: 3,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'La Importancia Vital del Sueño',
            body:
                'Durante las fases profundas del sueño se regulan hormonas clave como la melatonina y el cortisol, se restauran las células y el cerebro consolida los recuerdos y aprendizajes del día.',
            iconKey: 'spa',
            sortOrder: 4,
          ),
        ];

      case ContentSections.insomniaLink:
        return [
          ContentItemModel(id: 0, section: section, title: 'MedlinePlus en Español', url: 'https://medlineplus.gov/spanish/', sortOrder: 1),
          ContentItemModel(id: 0, section: section, title: 'Mayo Clinic - Trastornos del Sueño', url: 'https://www.mayoclinic.org/es-es/', sortOrder: 2),
          ContentItemModel(id: 0, section: section, title: 'National Sleep Foundation (NSF)', url: 'https://www.sleepfoundation.org/', sortOrder: 3),
          ContentItemModel(id: 0, section: section, title: 'CDC - Salud y Sueño', url: 'https://www.cdc.gov/sleep/index.html', sortOrder: 4),
        ];

      case ContentSections.meditation:
        return [
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Respiración Profunda (4-4-6)',
            body:
                '◆ Acuéstate en tu cama en una posición cómoda.\n\n'
                '◆ Cierra los ojos y toma una respiración profunda por la nariz, contando mentalmente hasta 4.\n\n'
                '◆ Mantén el aire suavemente durante 4 segundos.\n\n'
                '◆ Exhala lentamente por la boca contando hasta 6, soltando el aire como un suspiro cálido.\n\n'
                '◆ Repite este patrón durante 5 a 10 minutos, sintiendo cómo tu ritmo cardíaco y tu cuerpo se van desacelerando.',
            sortOrder: 1,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Relajación Muscular Progresiva',
            body:
                '◆ Acuéstate cómodamente y cierra los ojos.\n\n'
                '◆ Concéntrate en tus pies: inhala y tensa los músculos de los dedos y plantas durante 5 segundos.\n\n'
                '◆ Exhala y suelta toda la tensión de golpe, notando el calor y alivio de la relajación.\n\n'
                '◆ Avanza lentamente: pantorrillas, muslos, glúteos, abdomen, hombros, cuello y rostro.\n\n'
                '◆ Dedica 10 a 15 minutos para escanear todo tu cuerpo.',
            sortOrder: 2,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Visualización Guiada',
            body:
                '◆ Acuéstate cómodamente y respira de forma natural.\n\n'
                '◆ Imagina un paisaje nocturno en calma: una playa bajo la luna, un bosque sereno o una cabaña acogedora.\n\n'
                '◆ Siente la temperatura suave, el aroma fresco del aire y los sonidos lejanos de la naturaleza.\n\n'
                '◆ Deja que esa sensación de seguridad y paz te transporte suavemente hacia el sueño.',
            sortOrder: 3,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Afirmaciones Nocturnas',
            body:
                '◆ Cierra los ojos y respira hondo por la nariz.\n\n'
                '◆ Repite mentalmente con cada exhalación:\n'
                "  • 'Suelto todo lo ocurrido en el día.'\n"
                "  • 'Mi cuerpo merece descansar y repararse.'\n"
                "  • 'Estoy en paz y a salvo en este momento.'\n\n"
                '◆ Permite que estas palabras disuelvan los pensamientos intrusivos.',
            sortOrder: 4,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Atención Plena (Mindfulness)',
            body:
                '◆ Adopta una postura cómoda sin tensión en la espalda o cuello.\n\n'
                '◆ Centra tu atención únicamente en el flujo del aire al entrar por tu nariz y salir por tu boca.\n\n'
                '◆ Si aparece algún pensamiento, obsérvalo sin juzgarlo y déjalo pasar como una nube en el cielo, volviendo suavemente a tu respiración.',
            sortOrder: 5,
          ),
        ];

      case ContentSections.meditationVideo:
        return [
          ContentItemModel(id: 0, section: section, title: 'Música Relajante con Sonidos de Lluvia', url: 'https://youtu.be/CkAOFDuxB38?si=ENjjRgHkelpzE4ld', sortOrder: 1),
          ContentItemModel(id: 0, section: section, title: 'Frecuencia 432 Hz para Conciliar el Sueño', url: 'https://youtu.be/x0Ig8XNc8d8?si=LTgPK9ONaCB0Dg2h', sortOrder: 2),
          ContentItemModel(id: 0, section: section, title: 'Meditación Guiada para Dormir Profundo', url: 'https://youtu.be/BTXcdQlXRJY?si=i5GsQ-GM47lm1NVe', sortOrder: 3),
        ];

      case ContentSections.music:
        return [
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Peaceful Piano',
            subtitle: 'Hermosas piezas de piano acústico para la calma y el sueño.',
            imageUrl: 'https://i.scdn.co/image/ab67706f0000000283da657fca565320e9311863',
            url: 'https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO?si=3e9f7db161fa4dd4',
            sortOrder: 1,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Nature Sounds',
            subtitle: 'Sonidos inmersivos: lluvia suave, olas del mar y viento nocturno.',
            imageUrl: 'https://i.scdn.co/image/ab67706f00000002e909a20522cfdb017c798ba8',
            url: 'https://open.spotify.com/playlist/37i9dQZF1DX4PP3DA4J0N8?si=5fbffde6e8dc4f61',
            sortOrder: 2,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Meditative Mind',
            subtitle: 'Frecuencias armónicas para meditación y sueño profundo.',
            imageUrl: 'https://seed-mix-image.spotifycdn.com/v6/img/artist/1PTLyE54UyxphMo43yaSc7/es-419/default',
            url: 'https://open.spotify.com/playlist/37i9dQZF1EIXHxNW9W3Wef?si=07d8798603bd49cc',
            sortOrder: 3,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Ambient Chill',
            subtitle: 'Paisajes sonoros electrónicos suaves para desconectar la mente.',
            imageUrl: 'https://image-cdn-ak.spotifycdn.com/image/ab67706c0000d72c7cfb8d8736d7ec67b24670ca',
            url: 'https://open.spotify.com/playlist/1kqBP6eE24L0agNpnTIKtc?si=0673adc81d274ae3',
            sortOrder: 4,
          ),
        ];

      case ContentSections.podcast:
        return [
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Durmiendo Podcast',
            subtitle: 'Ejercicios y meditaciones guiadas breves para reducir la ansiedad, calmar la mente y acompañarte en la transición al sueño.',
            url: 'https://open.spotify.com/show/1w9Me4TrRiDOuK3OsJ2VAW?si=79b3c58968764642',
            sortOrder: 1,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Dormicast',
            subtitle: 'Historias nocturnas, reflexiones serenas y ambientación sonora diseñadas para desviar los pensamientos del estrés diario.',
            url: 'https://open.spotify.com/show/4kC7b9omKVHMu6KPGd4sXV?si=151c55ef86e84bc7',
            sortOrder: 2,
          ),
          ContentItemModel(
            id: 0,
            section: section,
            title: 'Despertando + Durmiendo',
            subtitle: 'Rutinas de audio para irte a la cama en paz cada noche y comenzar tu mañana con calma y claridad.',
            url: 'https://www.youtube.com/@despertandodurmiendo',
            sortOrder: 3,
          ),
        ];

      case ContentSections.challenge:
        return [
          ContentItemModel(id: 1, section: section, title: 'Sin Pantallas Antes de Dormir', subtitle: 'Evitar el uso de dispositivos electrónicos 1 hora antes de dormir.', body: 'Reemplaza el tiempo de pantalla por actividades relajantes como leer un libro o practicar respiración.', sortOrder: 1),
          ContentItemModel(id: 2, section: section, title: 'Hora Fija para Dormir', subtitle: 'Ir a la cama a la misma hora todos los días durante una semana.', body: 'Programa un recordatorio 30 minutos antes y comienza tu ritual de relajación nocturno.', sortOrder: 2),
          ContentItemModel(id: 3, section: section, title: 'Diario de Sueño', subtitle: 'Llevar un diario de sueño y sensaciones durante 7 días.', body: 'Cada mañana, registra cómo fue tu sueño y tu nivel de energía al despertar.', sortOrder: 3),
          ContentItemModel(id: 4, section: section, title: 'Ambiente de Sueño Ideal', subtitle: 'Mantener el dormitorio oscuro, fresco y silencioso durante 5 noches.', body: 'Usa cortinas oscuras, regula la temperatura fresca y usa sonidos relajantes si hay ruido.', sortOrder: 4),
          ContentItemModel(id: 5, section: section, title: 'Desconexión Digital Nocturna', subtitle: "Poner el teléfono en modo 'No molestar' o fuera de tu alcance en la cama.", body: 'Coloca el cargador lejos de la mesita de noche para evitar la tentación de revisarlo.', sortOrder: 5),
          ContentItemModel(id: 6, section: section, title: 'Respiración 4-7-8 al Acostarte', subtitle: 'Practicar 4 ciclos de respiración profunda antes de cerrar los ojos.', body: 'Usa la herramienta de Respiración 4-7-8 de Sleepfy para activar tu sistema parasimpático.', sortOrder: 6),
          ContentItemModel(id: 7, section: section, title: 'Cero Cafeína en la Tarde', subtitle: 'No consumir café, té o refrescos estimulantes después de las 2:00 PM.', body: 'Sustituye la cafeína por infusiones relajantes de manzanilla o lavanda.', sortOrder: 7),
          ContentItemModel(id: 8, section: section, title: 'Noche de Sueño Completa', subtitle: 'Dormir al menos 7.5 horas continuas durante el fin de semana.', body: 'Alinea tus ciclos de sueño calculándolos con la regla de los 90 minutos.', sortOrder: 8),
          ContentItemModel(id: 9, section: section, title: 'Cena Ligera y Temprana', subtitle: 'Cenar ligero al menos 2 horas antes de meterte en la cama.', body: 'Evita comidas pesadas o grasas que obliguen a tu cuerpo a hacer digestión mientras intentas descansar.', sortOrder: 9),
          ContentItemModel(id: 10, section: section, title: 'Luz Solar al Despertar', subtitle: 'Exponerte a la luz natural durante 10 minutos al levantarte por la mañana.', body: 'Abre las cortinas o sal al balcón. La luz solar ancla tu reloj biológico para la siguiente noche.', sortOrder: 10),
        ];

      default:
        return [];
    }
  }
}
