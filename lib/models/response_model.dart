class ResponseModel {
  String? statusCode;
  String? statusMessage;
  Object? dist;
  Object? pagination;

  ResponseModel(
      {this.statusCode, this.statusMessage, this.dist, this.pagination});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      statusCode: json["statusCode"],
      statusMessage: json["statusMessage"],
      dist: json["dist"],
      pagination: json["pagination"],
    );
  }
}
