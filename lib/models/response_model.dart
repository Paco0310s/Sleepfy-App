class ResponseModel {
  String message;
  dynamic data;
  int? status;

  ResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });
}
