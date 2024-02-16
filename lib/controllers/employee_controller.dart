import 'package:fullserva/data/repositories/employee_repository.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/domain/usecases/employee_usecase.dart';

class EmployeeController implements EmployeeUseCase {
  EmployeeRepository employeeRepository = EmployeeRepository();

  @override
  Future<void> addEmployee(Employee employee) {
    return employeeRepository.addEmployee(employee);
  }

  @override
  Stream<List<Employee>> getEmployees() {
    return employeeRepository.getEmployees();
  }

  @override
  Future<void> updateEmployee(Employee employee) {
    return employeeRepository.updateEmployee(employee);
  }

  @override
  Future<void> removeEmployee(String employee) {
    return employeeRepository.removeEmployee(employee);
  }
}