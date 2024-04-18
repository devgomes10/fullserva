class Appointment {
  String id;
  String clientName;
  String coworkerId;
  String clientPhone;
  String offeringId;
  DateTime dateTime;
  String? observations;

  Appointment({
    required this.id,
    required this.clientName,
    required this.coworkerId,
    required this.clientPhone,
    required this.offeringId,
    required this.dateTime,
    this.observations,
  });

  // Converting a map to an instance
  Appointment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        clientName = map["clientName"],
        coworkerId = map["coworkerId"],
        clientPhone = map["clientPhone"],
        offeringId = map["offeringId"],
        dateTime = map["dateTime"],
        observations = map["observations"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "clientName": clientName,
      "coworkerId": coworkerId,
      "clientPhone": clientPhone,
      "offeringId": offeringId,
      "dateTime": dateTime,
      "observations": observations,
    };
  }
}
