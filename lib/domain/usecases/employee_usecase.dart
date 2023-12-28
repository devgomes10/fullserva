import '../entities/employee.dart';

abstract class EmployeeUseCase {
  Future<void> addEmployee(Employee employee);

  Stream<List<Employee>> getEmployee();

  Future<void> updateEmployee(Employee employee);

  Future<void> removeEmployee(String employee);
}