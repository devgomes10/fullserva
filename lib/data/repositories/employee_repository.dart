import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/employee.dart';

class EmployeeRepository {
  // late String uidEmployee;
  late CollectionReference employeeCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  EmployeeRepository() {
    // uidEmployee = FirebaseAuth.instance.currentUser!.uid;
    employeeCollection = firestore.collection("employees");
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await employeeCollection.doc(employee.id).set(employee.toMap());
    } catch (error) {
      print("Erro: $error");
    }
  }

  Stream<List<Employee>> getEmployees() {
    return employeeCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Employee(
              id: doc["id"],
              name: doc["name"],
              email: doc["email"],
              password: doc["password"],
              phone: doc["phone"],
              servicesIdList: doc["serviceIdList"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await employeeCollection.doc(employee.id).update(employee.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeEmployee(String employee) async {
    try {
      await employeeCollection.doc(employee).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
