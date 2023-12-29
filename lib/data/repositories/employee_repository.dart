import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/employee.dart';

class EmployeeRepository {
  late String uidEmployee;
  late CollectionReference employeeCollection;
  FirebaseFirestore firestore;

  EmployeeRepository(this.firestore) {
    // Creating a unique identifier
    uidEmployee = FirebaseAuth.instance.currentUser!.uid;
    employeeCollection = firestore.collection("employee_$uidEmployee");
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
              appointmentHistory: doc["appointmentHistory"],
              serviceList: doc["serviceList"],
              isVacation: doc["isVacation"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final doc = await employeeCollection.doc(employee.id).get();
      if (doc.exists) {
        await employeeCollection
            .doc(employee.id)
            .update(employee.toMap());
      } else {
        // tratar em caso de erro
      }
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
