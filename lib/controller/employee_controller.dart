import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/employee.dart';

class EmployeeController {
  late String uidEmployee;
  late CollectionReference employeeCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  EmployeeController() {
    uidEmployee = FirebaseAuth.instance.currentUser!.uid;
    employeeCollection =
        FirebaseFirestore.instance.collection("employee_$uidEmployee");
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await employeeCollection.doc(employee.id).set(employee.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Employee>> getEmployee() {
    return employeeCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Employee(
              id: doc.id,
              name: doc["name"],
              email: doc["email"],
              expertise: doc["expertise"],
              appointmentHistory: doc["appointmentHistory"],
              serviceList: doc["serviceList"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateEmployee(Employee updateEmployee) async {
    try {
      final doc = await employeeCollection.doc(updateEmployee.id).get();
      if (doc.exists) {
        await employeeCollection
            .doc(updateEmployee.id)
            .update(updateEmployee.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeEmployee(String employeeId) async {
    try {
      await employeeCollection.doc(employeeId).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
