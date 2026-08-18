class ResponseModel {
  String message;
  Map<String, dynamic> data;
  int? status;

  ResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });
}
