import 'package:fullserva/domain/entities/professional.dart';

class Job {
  String id;
  String name;
  Professional professional;
  String description;
  String jobMode;
  String estimatedDuration;
  double price;

  Job({
    required this.id,
    required this.name,
    required this.professional,
    required this.description,
    required this.jobMode,
    required this.estimatedDuration,
    required this.price,
  });

  Job.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        professional = map["professional"],
        description = map["description"],
        jobMode = map["jobMode"],
        estimatedDuration = map["estimatedDuration"],
        price = map["price"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "professional": professional,
      "description": description,
      "jobMode": jobMode,
      "estimatedDuration": estimatedDuration,
      "price": price,
    };
  }
}
