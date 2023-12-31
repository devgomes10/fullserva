import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/employee.dart';

class EmployeeRepository {
  late CollectionReference employeeCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  EmployeeRepository() {
    employeeCollection = firestore.collection("employees");
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await employeeCollection.add(employee.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Stream<List<Employee>> getEmployee() {
    return employeeCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Employee(
            id: doc["id"],
            name: doc["name"],
            phone: doc["phone"],
            role: doc["role"],
            isVacation: doc["isVacation"],
          );
        }).toList();
      },
    );
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await employeeCollection.get().then(
        (snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.update(employee.toMap());
          }
        },
      );
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Future<void> removeEmployee(String employeeName) async {
    try {
      await employeeCollection
          .where("name", isEqualTo: employeeName)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../domain/entities/employee.dart';
//
// class EmployeeRepository {
//   late String uidEmployee;
//   late CollectionReference employeeCollection;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   EmployeeRepository() {
//     // Creating a unique identifier
//     uidEmployee = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUID';
//     employeeCollection = firestore.collection("employee_$uidEmployee");
//   }
//
//   Future<void> addEmployee(Employee employee) async {
//     try {
//       await employeeCollection.doc(employee.id).set(employee.toMap());
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
//
//   Stream<List<Employee>> getEmployee() {
//     return employeeCollection.snapshots().map(
//       (snapshot) {
//         return snapshot.docs.map(
//           (doc) {
//             return Employee(
//               id: doc.id,
//               name: doc["name"],
//               phone: doc["phone"],
//               role: doc["role"],
//               isVacation: doc["isVacation"],
//             );
//           },
//         ).toList();
//       },
//     );
//   }
//
//   Future<void> updateEmployee(Employee employee) async {
//     try {
//       final doc = await employeeCollection.doc(employee.id).get();
//       if (doc.exists) {
//         await employeeCollection
//             .doc(employee.id)
//             .update(employee.toMap());
//       } else {
//         // tratar em caso de erro
//       }
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
//
//   Future<void> removeEmployee(String employee) async {
//     try {
//       await employeeCollection.doc(employee).delete();
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
// }
