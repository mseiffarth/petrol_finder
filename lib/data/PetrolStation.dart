import 'dart:convert';

class PetrolStation {
  final String address;
  final String postcode;
  final String operator;
  final int timestamp;
  final bool unleadedavail;
  final bool dieselavail;
  final bool superavail;
  final double latitude;
  final double longitude;

  PetrolStation(this.address,
      this.postcode,
      this.operator,
      this.timestamp,
      this.unleadedavail,
      this.dieselavail,
      this.superavail,
      this.latitude,
      this.longitude);

  PetrolStation.fromJson(Map<dynamic, dynamic> json)
      :  address = json['address'] as String,
         postcode = json['postcode'] as String,
         operator = json['operator'] as String,
         timestamp = json['timestamp'] as int,
         unleadedavail = json['unleadedavail'] as bool,
         dieselavail = json['dieselavail'] as bool,
         superavail = json['superavail'] as bool,
         latitude = json['lat'] as double,
         longitude = json['long'] as double;

/* unused code for conversion back into json
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
  }'*/
}

