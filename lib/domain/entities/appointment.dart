class Appointment {
  String id;
  String clientName;
  String clientPhone;
  String serviceId;
  DateTime dateTime;
  String? internalObservations;

  Appointment({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.serviceId,
    required this.dateTime,
    this.internalObservations,
  });

  // Converting a map to an instance
  Appointment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        clientName = map["clientName"],
        clientPhone = map["clientPhone"],
        serviceId = map["serviceId"],
        dateTime = map["dateTime"],
        internalObservations = map["internalObservations"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "clientName": clientName,
      "clientPhone": clientPhone,
      "serviceId": serviceId,
      "dateTime": dateTime,
      "internalObservations": internalObservations,
    };
  }
}
