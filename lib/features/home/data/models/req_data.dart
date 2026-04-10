import 'package:latlong2/latlong.dart';

class ReqData {
  String? reqtype;
  LatLng? location;
  int? year;
  String? make;
  String? model;
  String? color;

  ReqData({
    this.reqtype,
    this.location,
    this.year,
    this.make,
    this.model,
    this.color,
  });

  Map<String, dynamic> toJson() => {
    "reqtype": reqtype,
    "location": location,
    "year": year,
    "make": make,
    "model": model,
    "color": color,
  };
}
