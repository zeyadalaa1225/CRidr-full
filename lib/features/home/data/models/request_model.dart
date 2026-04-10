class RequestModel {
  final int id;
  final String issueType;
  final int carYear;
  final String carMake;
  final String carModel;
  final String carColor;
  final String notes;
  final DateTime requestTime;
  final int userId;
  final int? providerId;
  final int? cost;
  final double latitude;
  final double longitude;
  final String? status;
  final String? customerName;
  final String? customerPhone;

  RequestModel({
    required this.id,
    required this.issueType,
    required this.carYear,
    required this.carMake,
    required this.carModel,
    required this.carColor,
    required this.notes,
    required this.requestTime,
    required this.userId,
    this.providerId,
    this.cost,
    required this.latitude,
    required this.longitude,
    this.status,
    this.customerName,
    this.customerPhone,
  });

  /// Factory method to create Request object from JSON
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    return RequestModel(
      id: json['id'] as int,
      issueType: json['issueType'] as String,
      carYear: json['carYear'] as int,
      carMake: json['carMake'] as String,
      carModel: json['carModel'] as String,
      carColor: json['carColor'] as String,
      notes: json['notes'] as String,
      requestTime: DateTime.parse(json['requestTime']),
      userId: user != null ? user['id'] as int : json['userId'] as int,
      providerId: json['providerId'] as int?,
      cost: json['cost'] as int?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] as String? ?? "",
      customerName: user != null
          ? user['name'] as String? ?? ""
          : json['customerName'] as String? ?? "",
      customerPhone: user != null
          ? user['phoneNumber'] as String? ?? ""
          : json['customerPhone'] as String? ?? "",
    );
  }

  /// Convert Request object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueType': issueType,
      'carYear': carYear,
      'carMake': carMake,
      'carModel': carModel,
      'carColor': carColor,
      'notes': notes,
      'requestTime': requestTime.toIso8601String(),
      'userId': userId,
      'providerId': providerId,
      'cost': cost,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }

  @override
  String toString() {
    return 'RequestModel(id: $id, issueType: $issueType, car: $carMake $carModel $carYear, '
        'color: $carColor, notes: $notes, cost: $cost, status: $status, '
        'location: ($latitude, $longitude), userId: $userId, '
        'customerName: $customerName, customerPhone: $customerPhone, '
        'requestTime: $requestTime)';
  }
}
