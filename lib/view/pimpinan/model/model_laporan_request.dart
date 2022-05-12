import 'dart:convert';

List<ChartRequest> chartRequestFromJson(String str) => List<ChartRequest>.from(
    json.decode(str).map((x) => ChartRequest.fromJson(x)));

String chartRequestToJson(List<ChartRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChartRequest {
  ChartRequest({
    required this.tanggal,
    required this.jumlah,
  });

  String tanggal;
  String jumlah;

  factory ChartRequest.fromJson(Map<String, dynamic> json) => ChartRequest(
        tanggal: json["tanggal"],
        jumlah: json["jumlah"],
      );

  Map<String, dynamic> toJson() => {
        "tanggal": tanggal,
        "jumlah": jumlah,
      };
}
