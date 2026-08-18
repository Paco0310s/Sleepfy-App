class ParseUtils {
  static int parseInt(String value) {
    return int.tryParse(value) ?? 0;
  }

  static double parseDouble(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  static String parseDate(String value) {
    return value.split('T').first;
  }

  static String formatDate(DateTime createdAt) {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
